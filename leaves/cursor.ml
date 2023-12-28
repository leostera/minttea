type t = {
    style : Spices.style;
    (* whether cursor is visible *)
    focus : bool;

    (* blinking parameters *)
    blink : bool;
    show : bool;
    fps : Fps.t;
  }


open struct
  (* Colors *)
  let white = Spices.color "#FFFFFF"
  let black = Spices.color "#000000"
end

let make
      ?(style=Spices.(default |> bg white |> fg black))
      ?(blink=true)
      ?(fps=Fps.of_float 2.5) ()
  = {
    focus = true;
    blink = blink;
    fps = fps;
    show = true || (not blink);
    style = style;
  }


let update t (e : Minttea.Event.t) =
  match e with
  | Frame now when t.blink ->
     if (Fps.tick ~now t.fps) = `frame then
       let show = not t.show in
       { t with show }
     else t
  | _ -> t

let view t ?(text_style=Spices.(default |> bg black |> fg white)) str =
  let style = Spices.(t.style |> build) in
  let text_style = Spices.(text_style |> build) in
  if t.show && t.focus then
    style "%s" str
  else (text_style "%s" str)

let focus t =
  {t with focus = true; show = true }

let unfocus t =
  {t with focus = false }
