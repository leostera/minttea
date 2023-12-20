open Minttea
open Leaves

let mint fmt = Spices.(default |> fg (color "#77e5b7") |> build) fmt

type s = { spinners : Spinner.t list }

let initial_model =
  let now = Ptime_clock.now () in
  {
    spinners =
      Spinner.
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
      let spinners = model.spinners |> List.map (Spinner.update ~now) in
      ({ spinners }, Command.Noop)
  | Event.KeyDown (Key "q") -> (model, Command.Quit)
  | _ -> (model, Command.Noop)

let view model =
  mint "%s" (String.concat "  " (List.map Spinner.view model.spinners))

let app = Minttea.app ~init ~update ~view ()
let () = Minttea.start ~initial_model app
