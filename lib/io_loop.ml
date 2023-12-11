open Riot
open Messages
open Event

let stdin_fd = Unix.descr_of_in_channel stdin

let set_raw_mode () =
  let termios = Unix.tcgetattr stdin_fd in
  let new_termios =
    Unix.
      { termios with c_icanon = false; c_echo = false; c_vmin = 1; c_vtime = 0 }
  in
  Unix.tcsetattr stdin_fd TCSANOW new_termios;
  termios

let restore_mode termios = Unix.tcsetattr stdin_fd TCSANOW termios

let rec read_inputs stdin =
  match Uutf.decode stdin with
  | `Uchar u ->
      let buf = Buffer.create 8 in
      Uutf.Buffer.add_utf_8 buf u;
      let key = Buffer.contents buf in
      KeyDown key
  | `End ->
      yield ();
      read_inputs stdin
  | _ -> assert false

let rec run () =
  let stdin = Uutf.decoder ~encoding:`UTF_8 (`Channel stdin) in
  let msg = read_inputs stdin in
  send_by_name ~name:"Minttea.runner" (Input msg);
  yield ();
  run ()

let spawn_link () =
  spawn_link @@ fun () ->
  let original_termios = set_raw_mode () in
  Fun.protect ~finally:(fun () -> restore_mode original_termios) run
