open Riot

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
  | Key k -> k

type t = KeyDown of key | Timer of unit Ref.t | Frame | Custom of Message.t

let pp fmt t =
  match t with
  | KeyDown key -> Format.fprintf fmt "KeyDown(%S)" (key_to_string key)
  | Timer ref -> Format.fprintf fmt "Timer(%a)" Ref.pp ref
  | Frame -> Format.fprintf fmt "Frame"
  | Custom _msg -> Format.fprintf fmt "Custom"
