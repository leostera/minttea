open Leaves
open Minttea

module Msg = struct
  type t = CursorUp | CursorDown | CursorLeft

  let defaults : (t * Key_map.binding) list =
    [
      ( CursorUp,
        {
          keys = [ Minttea.Event.Up; Minttea.Event.Key "k" ];
          help = { key = "up"; desc = "↑/k" };
          disabled = false;
        } );
      ( CursorDown,
        {
          keys = [ Minttea.Event.Down; Minttea.Event.Key "j" ];
          help = { key = "down"; desc = "↓/j" };
          disabled = false;
        } );
      ( CursorLeft,
        {
          keys = [ Minttea.Event.Left; Minttea.Event.Key "h" ];
          help = { key = "left"; desc = "←/h" };
          disabled = true;
        } );
    ]
end

module Test_key_map = Key_map.Make (Msg)

let m =
  Test_key_map.make
    [
      ( CursorUp,
        {
          keys = [ Minttea.Event.Up; Minttea.Event.Key "k" ];
          help = { key = "up"; desc = "↑/k" };
          disabled = false;
        } );
    ]

let () =
  List.iter
    (fun k ->
      match Test_key_map.find_match k m with
      | Some CursorUp -> print_endline "up"
      | Some CursorDown -> print_endline "down"
      | Some CursorLeft -> print_endline "left"
      | None -> print_endline "Not Found")
    [
      Event.Up;
      Event.Key "k";
      Event.Down;
      Event.Key "j";
      Event.Left;
      Event.Enter;
    ]
