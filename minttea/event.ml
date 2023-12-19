open Riot

type t = KeyDown of string | Timer of unit Ref.t | Frame | Custom of Message.t

let pp fmt t =
  match t with
  | KeyDown key -> Format.fprintf fmt "KeyDown(%S)" key
  | Timer ref -> Format.fprintf fmt "Timer(%a)" Ref.pp ref
  | Frame -> Format.fprintf fmt "Frame"
  | Custom _msg -> Format.fprintf fmt "Custom"
