type t = {
  (* cursor style -- defaults to inverted default *)
  style : Spices.style;
  (* whether cursor is visible/active *)
  focus : bool;
  (* whether cursor should blink *)
  blink : bool;
  (* blink state of cursor *)
  show : bool;
  (* blink rate *)
  fps : Fps.t;
}

let default_style = Spices.(default |> reverse true)
let default_fps = Fps.of_float 2.5

let make ?(style = default_style) ?(blink = true) ?(fps = default_fps) () =
  { focus = true; blink; fps; show = true; style }

let update t (e : Minttea.Event.t) =
  match e with
  | Frame now when t.blink ->
      if Fps.tick ~now t.fps = `frame then
        let show = not t.show in
        { t with show }
      else t
  | _ -> t

let view t ~text_style str =
  let style = Spices.(t.style |> build) in
  let text_style = Spices.(text_style |> build) in
  if t.show && t.focus then style "%s" str else text_style "%s" str

let focus t = { t with focus = true; show = true }
let unfocus t = { t with focus = false }
let disable_blink t = { t with blink = false; show = true }
let enable_blink t = { t with blink = true; show = true }
