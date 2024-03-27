open Riot
open Minttea

let dark_gray = Spices.color "241"
let yellow fmt = Spices.(default |> fg (color "#999922") |> build) fmt
let red fmt = Spices.(default |> fg (color "#992222") |> build) fmt
let green fmt = Spices.(default |> fg (color "#229922") |> build) fmt

let keyword fmt =
  Spices.(default |> faint true |> fg dark_gray |> bold true |> build) fmt

type model = { frames : int; fps : int; last_frame : Ptime.t }

let init _ = Command.Noop
let initial_model = { frames = 0; fps = 30; last_frame = Ptime_clock.now () }

let update event model =
  match event with
  | Event.KeyDown (Key "q", _modifier) -> (model, Command.Quit)
  | Event.KeyDown (Key "s", _modifier) ->
      sleep 0.5;
      (model, Command.Noop)
  | Event.Frame now ->
      let delta = Ptime.diff now model.last_frame in
      let delta = Float.abs (Ptime.Span.to_float_s delta) in
      let model =
        if delta >= 1.0 then
          let fps = model.frames + 1 in
          let frames = 0 in
          { frames; fps; last_frame = now }
        else { model with frames = model.frames + 1 }
      in
      (model, Command.Noop)
  | _ -> (model, Command.Noop)

let view model =
  let fps =
    if model.fps < 25 then red "%d" model.fps
    else if model.fps < 45 then yellow "%d" model.fps
    else green "%d" model.fps
  in
  keyword "fps: " ^ fps
  ^ keyword " | counter: %d\n\npress s to slow down" model.frames

let () = Minttea.app ~init ~update ~view () |> Minttea.start ~initial_model
