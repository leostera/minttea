type t = {
  color : [ `Plain of Spices.color | `Gradient of Spices.color array ];
  width : int;
  mutable percent : float;
  mutable finished : bool;
  full_char : string;
  empty_char : string;
  trail_char : string;
  show_percentage : bool;
}

let default_full_char = "█"
let default_empty_char = " "
let default_trail_char = ""
let default_color = `Plain (Spices.color "#00FFA3")
let default_show_percentage = true

let make ?(percent = 0.) ?(full_char = default_full_char)
    ?(trail_char = default_trail_char) ?(empty_char = default_empty_char)
    ?(color = default_color) ?(show_percentage = default_show_percentage) ~width
    () =
  {
    width;
    percent;
    full_char;
    empty_char;
    trail_char;
    show_percentage;
    finished = false;
    color =
      (match color with
      | `Plain c -> `Plain c
      | `Gradient Spices.(No_color, No_color) ->
          `Plain (Tty.Color.of_rgb (127, 127, 127))
      | `Gradient Spices.(No_color, c) -> `Plain c
      | `Gradient Spices.(c, No_color) -> `Plain c
      | `Gradient (start, finish) ->
          `Gradient (Spices.gradient ~start ~finish ~steps:width));
  }

let is_finished t = t.finished

let reset t =
  t.percent <- 0.;
  t.finished <- false;
  t

let set_progress t progress =
  t.percent <- Float.min 1.0 progress;
  if t.percent = 1.0 then t.finished <- true;
  t

let increment t amount =
  if t.percent +. amount < 1.0 then t.percent <- t.percent +. amount
  else (
    t.percent <- 1.0;
    t.finished <- true);
  t

let view t =
  let buf = Buffer.create t.width in
  let fmt = Format.formatter_of_buffer buf in

  let w = Float.of_int t.width in

  let percent = Float.max 0. (Float.min 1. t.percent) in
  let full_size = Int.of_float (Float.floor (w *. t.percent)) in

  let color char =
    match t.color with
    | `Plain c -> fun _ -> Spices.(default |> fg c |> build) "%s" char
    | `Gradient color_ramp ->
        fun i -> Spices.(default |> fg color_ramp.(i) |> build) "%s" char
  in
  List.init full_size (color t.full_char)
  |> List.iter (fun cell -> Format.fprintf fmt "%s" cell);

  let empty_size = Int.max 0 (t.width - full_size - 1) in

  if empty_size > 1 then Format.fprintf fmt "%s" (color t.trail_char full_size);

  List.init empty_size (fun _ -> t.empty_char)
  |> List.iter (fun cell -> Format.fprintf fmt "%s" cell);

  if t.show_percentage then Format.fprintf fmt " %4.1f%%%!" (percent *. 100.);

  Buffer.contents buf
