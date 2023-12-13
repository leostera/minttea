type t = RGB of int * int * int | ANSI of int | ANSI256 of int | No_color

exception Invalid_color of string
exception Invalid_color_param of string
exception Invalid_color_num of string * int

let to_255 str =
  match int_of_string_opt ("0x" ^ str) with
  | None -> raise (Invalid_color_param str)
  | Some c -> c

let rgb r g b = RGB (to_255 r, to_255 g, to_255 b)

let rgb str =
  match String.to_seq str |> List.of_seq |> List.map (String.make 1) with
  | [ "#"; r1; r2; g1; g2; b1; b2 ] -> rgb (r1 ^ r2) (g1 ^ g2) (b1 ^ b2)
  | [ "#"; r1; g1; b1 ] -> rgb r1 g1 b1
  | _ -> raise (Invalid_color str)

let ansi i = ANSI i
let ansi256 i = ANSI256 i
let no_color = No_color

let make str =
  if String.starts_with ~prefix:"#" str then rgb str
  else
    match int_of_string_opt str with
    | None -> raise (Invalid_color str)
    | Some i when i < 16 -> ansi i
    | Some i -> ansi256 i

let to_escape_seq ~mode t =
  match t with
  | RGB (r, g, b) -> Format.sprintf ";2;%d;%d;%d" r g b
  | ANSI c ->
      let bg_mod x = if mode = `bg then x + 10 else x in
      let c = if c < 8 then bg_mod c + 30 else bg_mod (c - 8) + 90 in
      Int.to_string c
  | ANSI256 c -> Format.sprintf ";5;%d" c
  | No_color -> ""

let is_no_color t = t = No_color
let is_rgb t = match t with RGB _ -> true | _ -> false
let is_ansi t = match t with ANSI _ -> true | _ -> false
let is_ansi256 t = match t with ANSI256 _ -> true | _ -> false
