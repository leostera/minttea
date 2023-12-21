(**
   Credits: The majority of the following code to convert colors between RGB, Linear
   RGB, XYZ, and LUV, was ported over from the go-colorful library.

   Ref: https://github.com/lucasb-eyer/go-colorful/blob/6e6f2cdd7e293224a813cb9d5411a81ca5eb3029/colors.go
*)

type color = Tty.Color.t

exception Invalid_gradient_color

let ansi_to_rgb =
  [|
    (0, 0, 0);
    (128, 0, 0);
    (0, 128, 0);
    (128, 128, 0);
    (0, 0, 128);
    (128, 0, 128);
    (0, 128, 128);
    (192, 192, 192);
    (128, 128, 128);
    (255, 0, 0);
    (0, 255, 0);
    (255, 255, 0);
    (0, 0, 255);
    (255, 0, 255);
    (0, 255, 255);
    (255, 255, 255);
    (0, 0, 0);
    (0, 0, 95);
    (0, 0, 135);
    (0, 0, 175);
    (0, 0, 215);
    (0, 0, 255);
    (0, 95, 0);
    (0, 95, 95);
    (0, 95, 135);
    (0, 95, 175);
    (0, 95, 215);
    (0, 95, 255);
    (0, 135, 0);
    (0, 135, 95);
    (0, 135, 135);
    (0, 135, 175);
    (0, 135, 215);
    (0, 135, 255);
    (0, 175, 0);
    (0, 175, 95);
    (0, 175, 135);
    (0, 175, 175);
    (0, 175, 215);
    (0, 175, 255);
    (0, 215, 0);
    (0, 215, 95);
    (0, 215, 135);
    (0, 215, 175);
    (0, 215, 215);
    (0, 215, 255);
    (0, 255, 0);
    (0, 255, 95);
    (0, 255, 135);
    (0, 255, 175);
    (0, 255, 215);
    (0, 255, 255);
    (95, 0, 0);
    (95, 0, 95);
    (95, 0, 135);
    (95, 0, 175);
    (95, 0, 215);
    (95, 0, 255);
    (95, 95, 0);
    (95, 95, 95);
    (95, 95, 135);
    (95, 95, 175);
    (95, 95, 215);
    (95, 95, 255);
    (95, 135, 0);
    (95, 135, 95);
    (95, 135, 135);
    (95, 135, 175);
    (95, 135, 215);
    (95, 135, 255);
    (95, 175, 0);
    (95, 175, 95);
    (95, 175, 135);
    (95, 175, 175);
    (135, 135, 255);
    (135, 175, 0);
    (135, 175, 95);
    (135, 175, 135);
    (135, 175, 175);
    (135, 175, 215);
    (135, 175, 255);
    (135, 215, 0);
    (135, 215, 95);
    (135, 215, 135);
    (135, 215, 175);
    (135, 215, 215);
    (135, 215, 255);
    (135, 255, 0);
    (135, 255, 95);
    (135, 255, 135);
    (135, 255, 175);
    (135, 255, 215);
    (135, 255, 255);
    (175, 0, 0);
    (175, 0, 95);
    (175, 0, 135);
    (175, 0, 175);
    (175, 0, 215);
    (175, 0, 255);
    (175, 95, 0);
    (175, 95, 95);
    (175, 95, 135);
    (175, 95, 175);
    (175, 95, 215);
    (175, 95, 255);
    (175, 135, 0);
    (175, 135, 95);
    (175, 135, 135);
    (175, 135, 175);
    (175, 135, 215);
    (175, 135, 255);
    (175, 175, 0);
    (175, 175, 95);
    (175, 175, 135);
    (175, 175, 175);
    (175, 175, 215);
    (175, 175, 255);
    (175, 215, 0);
    (175, 215, 95);
    (175, 215, 135);
    (175, 215, 175);
    (175, 215, 215);
    (175, 215, 255);
    (175, 255, 0);
    (175, 255, 95);
    (175, 255, 135);
    (175, 255, 175);
    (175, 255, 215);
    (175, 255, 255);
    (215, 0, 0);
    (215, 0, 95);
    (215, 0, 135);
    (215, 0, 175);
    (215, 0, 215);
    (215, 0, 255);
    (215, 95, 0);
    (215, 95, 95);
    (215, 95, 135);
    (215, 95, 175);
    (215, 95, 215);
    (215, 95, 255);
    (215, 135, 0);
    (215, 135, 95);
    (215, 135, 135);
    (215, 135, 175);
    (215, 135, 215);
    (215, 135, 255);
    (215, 175, 0);
    (215, 175, 95);
    (215, 175, 135);
    (215, 175, 175);
    (215, 175, 215);
    (215, 175, 255);
    (215, 215, 0);
    (215, 215, 95);
    (215, 215, 135);
    (215, 215, 175);
    (215, 215, 215);
    (215, 215, 255);
    (215, 255, 0);
    (215, 255, 95);
    (215, 255, 135);
    (215, 255, 175);
    (215, 255, 215);
    (215, 255, 255);
    (255, 0, 0);
    (255, 0, 95);
    (255, 0, 135);
    (255, 0, 175);
    (255, 0, 215);
    (255, 0, 255);
    (255, 95, 0);
    (255, 95, 95);
    (255, 95, 135);
    (255, 95, 175);
    (255, 95, 215);
    (255, 95, 255);
    (255, 135, 0);
    (255, 135, 95);
    (255, 135, 135);
    (255, 135, 175);
    (255, 135, 215);
    (255, 135, 255);
    (255, 175, 0);
    (255, 175, 95);
    (255, 175, 135);
    (255, 175, 175);
    (255, 175, 215);
    (255, 175, 255);
    (255, 215, 0);
    (255, 215, 95);
    (255, 215, 135);
    (255, 215, 175);
    (255, 215, 215);
    (255, 215, 255);
    (255, 255, 0);
    (255, 255, 95);
    (255, 255, 135);
    (255, 255, 175);
    (255, 255, 215);
    (255, 255, 255);
    (8, 8, 8);
    (18, 18, 18);
    (28, 28, 28);
    (38, 38, 38);
    (48, 48, 48);
    (58, 58, 58);
    (68, 68, 68);
    (78, 78, 78);
    (88, 88, 88);
    (98, 98, 98);
    (108, 108, 108);
    (118, 118, 118);
    (128, 128, 128);
    (138, 138, 138);
    (148, 148, 148);
    (158, 158, 158);
    (168, 168, 168);
    (178, 178, 178);
    (188, 188, 188);
    (198, 198, 198);
    (208, 208, 208);
    (218, 218, 218);
    (228, 228, 228);
    (238, 238, 238);
  |]

let parts c =
  match c with
  | Tty.Color.RGB (r, g, b) -> (r, g, b)
  | ANSI i | ANSI256 i -> ansi_to_rgb.(i)
  | No_color -> raise Invalid_gradient_color

let linearize v =
  if v < 0.04045 then v /. 12.92 else Float.pow ((v +. 0.055) /. 1.055) 2.4

let linearize_rbg (r, g, b) =
  `rgb
    ( r |> Float.of_int |> linearize,
      g |> Float.of_int |> linearize,
      b |> Float.of_int |> linearize )

let delinearize v =
  if v <= 0.0031308 then 12.92 *. v
  else (1.055 *. Float.pow v (1.0 /. 2.4)) -. 0.055

let delinearize_rgb (`rgb (r, g, b)) =
  (r |> delinearize, g |> delinearize, b |> delinearize)

let linear_rgb_to_xyz (`rgb (r, g, b)) =
  let x =
    (0.41239079926595948 *. r) +. (0.35758433938387796 *. g)
    +. (0.18048078840183429 *. b)
  in
  let y =
    (0.21263900587151036 *. r) +. (0.71516867876775593 *. g)
    +. (0.072192315360733715 *. b)
  in
  let z =
    (0.019330818715591851 *. r)
    +. (0.11919477979462599 *. g) +. (0.95053215224966058 *. b)
  in
  `xyz (x, y, z)

let xyz_to_linear_rgb (`xyz (x, y, z)) =
  let r =
    (3.2409699419045214 *. x) -. (1.5373831775700935 *. y)
    -. (0.49861076029300328 *. z)
  in
  let g =
    (-0.96924363628087983 *. x)
    +. (1.8759675015077207 *. y)
    +. (0.041555057407175613 *. z)
  in
  let b =
    (0.055630079696993609 *. x)
    -. (0.20397695888897657 *. y) +. (1.0569715142428786 *. z)
  in
  `rgb (r, g, b)

let xyz_to_uv (`xyz (x, y, z)) =
  let denom = x +. (15.0 *. y) +. (3.0 *. z) in
  if denom = 0.0 then (0.0, 0.0)
  else
    let u = 4.0 *. x /. denom in
    let v = 9.0 *. y /. denom in
    (u, v)

(* standard reference white point *)
let d65 = `xyz (0.95047, 1.00000, 1.08883)

let xyz_to_luv_with_ref (`xyz (_, y, _) as xyz) (`xyz (_, wref1, _) as wref) =
  let l =
    if y /. wref1 <= 6.0 /. 29.0 *. 6.0 /. 29.0 *. 6.0 /. 29.0 then
      y /. wref1 *. (29.0 /. 3.0 *. 29.0 /. 3.0 *. 29.0 /. 3.0) /. 100.0
    else (1.16 *. Float.cbrt (y /. wref1)) -. 0.16
  in
  let ubis, vbis = xyz_to_uv xyz in
  let un, vn = xyz_to_uv wref in
  let u = 13.0 *. l *. (ubis -. un) in
  let v = 13.0 *. l *. (vbis -. vn) in
  `luv (l, u, v)

(* use d65 white as reference point by default.
   http://www.fredmiranda.com/forum/topic/1035332
   http://en.wikipedia.org/wiki/Standard_illuminant *)
let xyz_to_luv xyz = xyz_to_luv_with_ref xyz d65

let luv_to_xyz_with_ref (`luv (l, u, v)) (`xyz (_, wref1, _) as wref) =
  let y =
    if l <= 0.08 then
      wref1 *. l *. 100.0 *. 3.0 /. 29.0 *. 3.0 /. 29.0 *. 3.0 /. 29.0
    else wref1 *. Float.pow ((l +. 0.16) /. 1.16) 3.
  in
  let un, vn = xyz_to_uv wref in
  if l != 0.0 then
    let ubis = (u /. (13.0 *. l)) +. un in
    let vbis = (v /. (13.0 *. l)) +. vn in
    let x = y *. 9.0 *. ubis /. (4.0 *. vbis) in
    let z = y *. (12.0 -. (3.0 *. ubis) -. (20.0 *. vbis)) /. (4.0 *. vbis) in
    `xyz (x, y, z)
  else `xyz (0.0, 0.0, 0.0)

let luv_to_xyz luv = luv_to_xyz_with_ref luv d65

let luv l u v =
  `luv (l, u, v) |> luv_to_xyz |> xyz_to_linear_rgb |> delinearize_rgb

let blend_luv (c1 : color) (c2 : color) (mix : float) : color =
  let mix = Float.(min (max 0. mix) 1.) in

  let (`luv (l1, u1, v1)) =
    c1 |> parts |> linearize_rbg |> linear_rgb_to_xyz |> xyz_to_luv
  in
  let (`luv (l2, u2, v2)) =
    c2 |> parts |> linearize_rbg |> linear_rgb_to_xyz |> xyz_to_luv
  in

  let l = l1 +. (mix *. (l2 -. l1)) in
  let u = u1 +. (mix *. (u2 -. u1)) in
  let v = v1 +. (mix *. (v2 -. v1)) in

  let r, g, b = luv l u v in

  let r = Int.of_float r in
  let g = Int.of_float g in
  let b = Int.of_float b in
  let rgb = Tty.Color.of_rgb (r, g, b) in
  (* NOTE(@leostera): useful for when we find color bugs
       Format.printf "rgb: %a - c1: %a - c2: %a - mix: %f\n" Tty.Color.pp rgb Tty.Color.pp c1 Tty.Color.pp c2 mix;
  *)
  rgb

let make ~start ~finish ~steps : color array =
  let colors = Array.make steps start in
  for i = 0 to steps - 1 do
    let p =
      if steps = 1 then 0.5 else Int.to_float i /. Int.to_float (steps - 1)
    in
    colors.(i) <- blend_luv start finish p
  done;
  colors
