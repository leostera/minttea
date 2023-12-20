open Minttea
open Leaves

let mint fmt = Spices.(default |> fg (color "#77e5b7") |> build) fmt

type s = { spinners : Sprite.t list }

let initial_model =
  let now = Ptime_clock.now () in
  {
    spinners =
      Spinner.
        [
          { sprite = line; frame = 0; last_frame = now };
          { sprite = dot; frame = 0; last_frame = now };
          { sprite = mini_dot; frame = 0; last_frame = now };
          { sprite = jump; frame = 0; last_frame = now };
          { sprite = pulse; frame = 0; last_frame = now };
          { sprite = points; frame = 0; last_frame = now };
          { sprite = meter; frame = 0; last_frame = now };
          { sprite = globe; frame = 0; last_frame = now };
          { sprite = moon; frame = 0; last_frame = now };
          { sprite = monkey; frame = 0; last_frame = now };
          { sprite = hamburger; frame = 0; last_frame = now };
          { sprite = ellipsis; frame = 0; last_frame = now };
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
