open Riot

type t = KeyDown of string | Timer of unit Ref.t

let pp fmt t =
  match t with
  | KeyDown key -> Format.fprintf fmt "KeyDown(%s)" key
  | Timer ref -> Format.fprintf fmt "Timer(%a)" Ref.pp ref
