open Riot
open Event

type Message.t += Input of Event.t

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
let translate = function " " -> "space" | key -> key

let try_read src =
  let bytes = Bytes.create 8 in
  match Unix.read stdin_fd bytes 0 8 with 
  | exception Unix.(Unix_error ((EINTR | EAGAIN | EWOULDBLOCK), _, _)) -> ()
  | len -> Uutf.Manual.src src bytes 0 len

let rec read_inputs src =
  match Uutf.decode src with
  | `Uchar u ->
      let buf = Buffer.create 8 in
      Uutf.Buffer.add_utf_8 buf u;
      let key = Buffer.contents buf in
      KeyDown (translate key)
  | `End ->
      yield ();
      read_inputs src
  | `Await -> 
      try_read src;
      yield ();
      read_inputs src
  | _ -> assert false

let rec run runner =
  let stdin = Uutf.decoder ~encoding:`UTF_8 `Manual in
  let msg = read_inputs stdin in
  send runner (Input msg);
  yield ();
  run runner

let run runner =
  Unix.set_nonblock stdin_fd;
  let original_termios = set_raw_mode () in
  Fun.protect ~finally:(fun () -> restore_mode original_termios) (run runner)
