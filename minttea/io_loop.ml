open Riot
open Event
open Tty

type Message.t += Input of Event.t

let translate = function " " -> "space" | key -> key

let rec loop runner =
  yield ();
  match Stdin.read_utf8 () with
  | `Read key ->
      let msg = KeyDown (translate key) in
      send runner (Input msg);
      loop runner
  | _ -> loop runner

let run runner =
  let termios = Stdin.setup () in
  Fun.protect
    ~finally:(fun () -> Stdin.shutdown termios)
    (fun () -> loop runner)
