open Leaves
open Minttea

type msg = CursorUp | CursorDown | CursorLeft

let defaults =
  let open Key_map in
  make [
    on
      ~help:{ key = "up"; desc = "↑/k" }
      [ Minttea.Event.Up; Minttea.Event.Key "k" ]
      CursorUp;
    on
      ~help:{ key = "down"; desc = "↓/j" }
      [ Minttea.Event.Down; Minttea.Event.Key "j" ]
      CursorDown;
    on ~disabled:true
      ~help:{ key = "left"; desc = "←/h" }
      [ Minttea.Event.Left; Minttea.Event.Key "h" ]
      CursorLeft;
  ]

let custom_key_map =
  let open Key_map in
  [
    on
      ~help:{ key = "up"; desc = "↑/k" }
      [ Minttea.Event.Up; Minttea.Event.Key "k"; Minttea.Event.Key "u" ]
      CursorUp;
  ]

let () =
  List.iter
    (fun k ->
      match Key_map.find_match ~custom_key_map k defaults with
      | Some CursorUp -> print_endline "up"
      | Some CursorDown -> print_endline "down"
      | Some CursorLeft -> print_endline "left"
      | None -> print_endline "Not Found")
    [
      Event.Up;
      Event.Key "k";
      Event.Key "u";
      Event.Down;
      Event.Key "j";
      Event.Left;
      Event.Enter;
    ]
