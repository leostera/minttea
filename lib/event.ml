type t = KeyDown of string

let pp fmt t =
  match t with KeyDown key -> Format.fprintf fmt "KeyDown(%s)" key
