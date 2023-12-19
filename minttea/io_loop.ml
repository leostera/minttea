open Riot
open Event
open Tty

type Message.t += Input of Event.t

let translate : string -> Event.key = function
  | " " -> Space
  | "\027" -> Escape
  | "\027[A" -> Up
  | "\027[B" -> Down
  | "\027[C" -> Left
  | "\027[D" -> Right
  | "\127" -> Backspace
  | "\n" -> Enter
  | key -> Key key

let rec loop runner =
  yield ();
  match Stdin.read_utf8 () with
  | `Read key ->
      let msg =
        match key with
        | "\027" -> (
            match Stdin.read_utf8 () with
            | `Read "[" -> (
                match Stdin.read_utf8 () with
                | `Read key -> KeyDown (translate ("\027[" ^ key))
                | _ -> KeyDown (translate key))
            | _ -> KeyDown (translate key))
        | key -> KeyDown (translate key)
      in
      send runner (Input msg);
      loop runner
  | _ -> loop runner

let run runner =
  let termios = Stdin.setup () in
  Fun.protect
    ~finally:(fun () -> Stdin.shutdown termios)
    (fun () -> loop runner)
