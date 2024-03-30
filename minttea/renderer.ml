open Riot
open Tty

type Message.t +=
  | Render of string
  | Enter_alt_screen
  | Exit_alt_screen
  | Tick
  | Shutdown
  | Set_cursor_visibility of [ `hidden | `visible ]

type t = {
  runner : Pid.t;
  ticker : Timer.timer;
  width : int;
  height : int;
  mutable buffer : string;
  mutable last_render : string;
  mutable lines_rendered : int;
  mutable is_altscreen_active : bool;
  mutable cursor_visibility : [ `hidden | `visible ];
}
[@@warning "-69"]

let is_empty t = String.length t.buffer = 0
let same_as_last_flush t = t.buffer = t.last_render
let lines t = t.buffer |> String.split_on_char '\n'

let rec loop t =
  match receive_any () with
  | Shutdown ->
      flush t;
      restore t
  | Tick ->
      tick t;
      loop t
  | Render output ->
      handle_render t output;
      loop t
  | Set_cursor_visibility cursor ->
      handle_set_cursor_visibility cursor t;
      loop t
  | Enter_alt_screen ->
      handle_enter_alt_screen t;
      loop t
  | Exit_alt_screen ->
      handle_exit_alt_screen t;
      loop t
  | _ -> loop t

and restore t =
  if t.cursor_visibility = `hidden then Tty.Escape_seq.show_cursor_seq ()

and tick t =
  let now = Ptime_clock.now () in
  if is_empty t || same_as_last_flush t then () else flush t;
  send t.runner (Io_loop.Input (Event.Frame now))

and flush t =
  let new_lines = lines t in
  let new_lines_this_flush = List.length new_lines in

  (* clean last rendered lines *)
  if t.lines_rendered > 0 then
    for _i = 1 to t.lines_rendered - 1 do
      Terminal.clear_line ();
      Terminal.cursor_up 1
    done;

  (* reset screen if its on alt *)
  Format.printf "%s%!" t.buffer;

  if t.is_altscreen_active then Terminal.move_cursor new_lines_this_flush 0
  else Terminal.cursor_back t.width;

  (* update state *)
  t.last_render <- t.buffer;
  t.lines_rendered <- new_lines_this_flush;
  t.buffer <- ""

and handle_render t output = t.buffer <- output ^ "\n"

and handle_enter_alt_screen t =
  if t.is_altscreen_active then ()
  else (
    t.is_altscreen_active <- true;
    Terminal.enter_alt_screen ();
    Terminal.clear ();
    t.last_render <- "")

and handle_exit_alt_screen t =
  if not t.is_altscreen_active then ()
  else (
    t.is_altscreen_active <- false;
    Terminal.exit_alt_screen ();
    t.last_render <- "")

and handle_set_cursor_visibility cursor t =
  if t.cursor_visibility = cursor then ()
  else (
    (match cursor with
    | `hidden -> Tty.Escape_seq.hide_cursor_seq ()
    | `visible -> Tty.Escape_seq.show_cursor_seq ());
    t.cursor_visibility <- cursor)

let max_fps = 120
let cap fps = Int.max 1 (Int.min fps max_fps) |> Int.to_float
let fps_to_float fps = 1. /. cap fps *. 1_000. |> Int64.of_float

let run ~fps ~runner =
  let ticker =
    Riot.Timer.send_interval ~every:(fps_to_float fps) (self ()) Tick
    |> Result.get_ok
  in
  loop
    {
      runner;
      ticker;
      buffer = "";
      width = 0;
      height = 0;
      last_render = "";
      is_altscreen_active = false;
      lines_rendered = 0;
      cursor_visibility = `visible;
    }

let render pid output = send pid (Render output)
let enter_alt_screen pid = send pid Enter_alt_screen
let exit_alt_screen pid = send pid Exit_alt_screen
let shutdown pid = send pid Shutdown
let hide_cursor pid = send pid (Set_cursor_visibility `hidden)
let show_cursor pid = send pid (Set_cursor_visibility `visible)
