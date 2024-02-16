type color = Tty.Color.t

exception Invalid_gradient_color of color

let to_rgb c =
  match c with
  | Tty.Color.RGB (r, g, b) -> `rgb (r, g, b)
  | ANSI i | ANSI256 i -> Colors.ANSI.to_rgb (`ansi i)
  | No_color -> raise (Invalid_gradient_color c)

let make ~start ~finish ~steps : color array =
  let colors = Array.make steps start in
  let start = to_rgb start in
  let finish = to_rgb finish in
  for i = 0 to steps - 1 do
    let p =
      if steps = 1 then 0.5 else Int.to_float i /. Int.to_float (steps - 1)
    in
    let (`rgb (r, g, b)) = Colors.RGB.blend start finish ~mix:p in
    colors.(i) <- Tty.Color.of_rgb (r, g, b)
  done;
  colors
