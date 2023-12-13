open Minttea

type state = {
  measured : float;
  start_time : Ptime.t;
  quit : bool;
  stopped : bool;
}

let ref = Riot.Ref.make ()
let init _ = Command.Set_timer (ref, 0.01)

let initial_model () =
  {
    start_time = Ptime_clock.now ();
    measured = 0.;
    quit = false;
    stopped = false;
  }

let update event model =
  match event with
  | Event.KeyDown "space" ->
      let start_time = Ptime_clock.now () in
      let measured = 0. in
      ({ model with start_time; measured }, Command.Set_timer (ref, 0.01))
  | Event.KeyDown "s" ->
      let stopped = not model.stopped in
      ({ model with stopped }, Command.Set_timer (ref, 0.01))
  | Event.KeyDown ("q" | "esc" | "ctrl+c") ->
      ({ model with quit = true }, Command.Quit)
  | Event.Timer _ref ->
      let model =
        if model.stopped then
          let start_time = Ptime_clock.now () in
          { model with start_time }
        else
          let now = Ptime_clock.now () in
          let diff = Ptime.diff now model.start_time in
          let measured = Ptime.Span.to_float_s diff +. model.measured in
          { model with measured; start_time = now }
      in
      (model, Command.Set_timer (ref, 0.01))
  | _ -> (model, Command.Noop)

let view model =
  if model.quit then Format.sprintf "%.3fs" model.measured
  else
    Format.sprintf "Elapsed: %.3fs\n\n q: quit • space: reset • s: %s"
      model.measured
      (if model.stopped then "start" else "stop")

let () = Minttea.app ~init ~initial_model ~update ~view () |> Minttea.start
