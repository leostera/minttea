open Riot

type modifier = No_modifier | Ctrl

type key =
  | Up
  | Down
  | Left
  | Right
  | Space
  | Escape
  | Backspace
  | Enter
  | Key of string

let key_to_string key =
  match key with
  | Up -> "<up>"
  | Down -> "<down>"
  | Left -> "<left>"
  | Right -> "<right>"
  | Space -> "<space>"
  | Escape -> "<esc>"
  | Backspace -> "<backspace>"
  | Enter -> "<enter>"
  | Key key -> key

type t =
  | KeyDown of key * modifier
  | Timer of unit Ref.t
  | Frame of Ptime.t
  | Custom of Message.t

let pp fmt t =
  match t with
  | KeyDown (key, _) -> Format.fprintf fmt "KeyDown(%S)" (key_to_string key)
  | Timer ref -> Format.fprintf fmt "Timer(%a)" Ref.pp ref
  | Frame delta -> Format.fprintf fmt "Frame(%a)" Ptime.pp delta
  | Custom _msg -> Format.fprintf fmt "Custom"
