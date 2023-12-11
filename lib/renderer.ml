open Riot
open Messages

let clear_screen () = print_string ""

let rec run () =
  match receive () with
  | Render output ->
      Printf.printf "\x1B[2J\x1B[H%s%!" output;
      run ()
  | _ -> run ()

let spawn_link () = spawn_link @@ fun () -> run ()
