open Minttea
open Leaves

let mint fmt = Spices.(default |> fg (color "#77e5b7") |> build) fmt

type spinner_state = {
  spinner : Spinner.spinner;
  frame : int;
  last_frame : Ptime.t;
}

type s = { spinners : spinner_state list }

let initial_model =
  let now = Ptime_clock.now () in
  {
    spinners =
      [
        { spinner = Spinner.line; frame = 0; last_frame = now };
        { spinner = Spinner.dot; frame = 0; last_frame = now };
        { spinner = Spinner.mini_dot; frame = 0; last_frame = now };
        { spinner = Spinner.jump; frame = 0; last_frame = now };
        { spinner = Spinner.pulse; frame = 0; last_frame = now };
        { spinner = Spinner.points; frame = 0; last_frame = now };
        { spinner = Spinner.meter; frame = 0; last_frame = now };
        { spinner = Spinner.globe; frame = 0; last_frame = now };
        { spinner = Spinner.moon; frame = 0; last_frame = now };
        { spinner = Spinner.monkey; frame = 0; last_frame = now };
        { spinner = Spinner.hamburger; frame = 0; last_frame = now };
        { spinner = Spinner.ellipsis; frame = 0; last_frame = now };
      ];
  }

let init _ = Command.Noop

let update event model =
  match event with
  | Event.Frame ->
      let now = Ptime_clock.now () in
      let update_spinner s =
        let delta =
          Ptime.diff now s.last_frame |> Ptime.Span.to_float_s |> Float.abs
        in
        if delta > 1.0 /. float_of_int s.spinner.fps then
          {
            s with
            frame = (s.frame + 1) mod Array.length s.spinner.frames;
            last_frame = now;
          }
        else s
      in
      let spinners = model.spinners |> List.map update_spinner in
      ({ spinners }, Command.Noop)
  | Event.KeyDown (Key "q") -> (model, Command.Quit)
  | _ -> (model, Command.Noop)

let view model =
  let render_spinner s = Spinner.view ~frame:s.frame s.spinner in
  mint "%s" (String.concat "  " (model.spinners |> List.map render_spinner))

let app = Minttea.app ~init ~update ~view ()
let () = Minttea.start ~initial_model app
