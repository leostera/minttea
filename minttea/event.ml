open Riot

type modifier = Ctrl
type key_event = { key : string; modifier : modifier option }

type key =
  | Up
  | Down
  | Left
  | Right
  | Space
  | Escape
  | Backspace
  | Enter
  | Key of key_event

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
  | Key { key; modifier = Some Ctrl } -> "<c-" ^ key ^ ">"
  | Key { key; modifier = None } -> key

type t =
  | KeyDown of key
  | Timer of unit Ref.t
  | Frame of Ptime.t
  | Custom of Message.t

let pp fmt t =
  match t with
  | KeyDown key -> Format.fprintf fmt "KeyDown(%S)" (key_to_string key)
  | Timer ref -> Format.fprintf fmt "Timer(%a)" Ref.pp ref
  | Frame delta -> Format.fprintf fmt "Frame(%a)" Ptime.pp delta
  | Custom _msg -> Format.fprintf fmt "Custom"
