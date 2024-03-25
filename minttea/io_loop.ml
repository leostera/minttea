open Riot
open Event
open Tty

type Message.t += Input of Event.t

let translate ?(modifier = None) key =
  match key with
  | " " -> Space
  | "\027" -> Escape
  | "\027[A" -> Up
  | "\027[B" -> Down
  | "\027[C" -> Right
  | "\027[D" -> Left
  | "\127" -> Backspace
  | "\n" -> Enter
  | key -> Key { key; modifier }

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
        | key when key >= "\x01" && key <= "\x1a" ->
            let key =
              key.[0] |> Char.code |> ( + ) 96 |> Char.chr |> String.make 1
            in
            KeyDown (translate ~modifier:(Some Ctrl) key)
        | key -> KeyDown (translate key)
      in
      send runner (Input msg);
      loop runner
  | _ -> loop runner

let run runner =
  process_flag (Trap_exit true);
  link runner;
  let termios = Stdin.setup () in
  let _worker = spawn_link (fun () -> loop runner) in
  let _ = receive () in
  Stdin.shutdown termios
