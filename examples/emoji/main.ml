open Minttea
open Leaves

let dark_gray = Spices.color "245"
let help = Spices.(default |> faint true |> fg dark_gray |> build)
let floor = "🟫"
let _space = "⬛"
let sky = "🟦"

module Tilemap = struct
  let w = 40
  let h = 14

  let bg =
    let bg = Array.make_matrix h w sky in
    Array.set bg 0 (Array.make w floor);
    Array.set bg (h - 1) (Array.make w floor);
    for i = 0 to h - 1 do
      bg.(i).(0) <- floor;
      bg.(i).(w - 1) <- floor
    done;
    bg

  let overlay overrides =
    let base = Array.make_matrix h w "" in
    List.iter (fun (icon, (x, y)) -> base.(y).(x) <- icon) overrides;
    base

  let view map =
    let buf = Buffer.create 1024 in
    let fmt = Format.formatter_of_buffer buf in
    Format.fprintf fmt "\r\n";
    for i = 0 to Array.length bg - 1 do
      for j = 0 to Array.length bg.(i) - 1 do
        let tile = map.(i).(j) in
        let tile = if tile = "" then bg.(i).(j) else tile in
        Format.fprintf fmt "%s" tile
      done;
      Format.fprintf fmt "\r\n"
    done;
    Format.fprintf fmt "%!";
    Buffer.contents buf
end

type model = {
  player_view : string;
  player_pos : int * int;
  monkey_pos : int * int;
  monkey : Sprite.t;
  screen : string array array;
}

let initial_model =
  {
    monkey = Spinner.monkey;
    monkey_pos = (12, 7);
    player_view = "🧍";
    player_pos = (11, 7);
    screen = Tilemap.overlay [];
  }

let init _ = Command.Noop

let update event m =
  match event with
  | Event.Frame now ->
      let monkey = Sprite.update ~now m.monkey in
      let screen =
        Tilemap.overlay
          [ (m.player_view, m.player_pos); (Sprite.view monkey, m.monkey_pos) ]
      in
      ({ m with screen; monkey }, Command.Noop)
  | Event.KeyDown ((Down | Key "j"), _modifier) ->
      let player_pos =
        let x, y = m.player_pos in
        (x, Int.min (Tilemap.h - 1) (y + 1))
      in
      ({ m with player_pos }, Command.Noop)
  | Event.KeyDown ((Up | Key "k"), _modifier) ->
      let player_pos =
        let x, y = m.player_pos in
        (x, Int.max 0 (y - 1))
      in
      ({ m with player_pos }, Command.Noop)
  | Event.KeyDown ((Right | Key "l"), _modifier) ->
      let player_pos =
        let x, y = m.player_pos in
        (Int.min (Tilemap.w - 1) (x + 1), y)
      in
      ({ m with player_pos }, Command.Noop)
  | Event.KeyDown ((Left | Key "h"), _modifier) ->
      let player_pos =
        let x, y = m.player_pos in
        (Int.max 0 (x - 1), y)
      in
      ({ m with player_pos }, Command.Noop)
  | Event.KeyDown (Key "q", _modifier) -> (m, Command.Quit)
  | _ -> (m, Command.Noop)

let view m =
  let help = help "%s" "move: h/j/k/l or ←/↓/↑/→ • quit: q" in
  Format.sprintf "%s\r\n%s" (Tilemap.view m.screen) help

let app = Minttea.app ~init ~update ~view ()
let () = Minttea.start ~initial_model app
