let make_ramp c1 _c2 w = Array.init w (fun _ -> c1)
let default_full_char = "█"
let default_empty_char = " "

let default_color_ramp =
  make_ramp (Spices.color "#B14FFF") (Spices.color "#00FFA3")

let bar ~width ?(color_ramp = default_color_ramp 100)
    ?(full_char = default_full_char) ?(empty_char = default_empty_char) percent
    =
  let buf = Buffer.create width in
  let fmt = Format.formatter_of_buffer buf in

  let w = Float.of_int width in

  let percent = Float.max 0. (Float.min 1. percent) in
  let full_size = Int.of_float (Float.floor (w *. percent)) in

  ignore color_ramp;
  let color _i = full_char in
  List.init full_size color
  |> List.iter (fun cell -> Format.fprintf fmt "%s" cell);

  let empty_size = Int.max 0 (width - full_size) in
  List.init empty_size (fun _ -> empty_char)
  |> List.iter (fun cell -> Format.fprintf fmt "%s" cell);

  Format.fprintf fmt "%.2f%%%!" (percent *. 100.);

  Buffer.contents buf
