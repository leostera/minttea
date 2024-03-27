open Minttea
open Leaves

let mint fmt = Spices.(default |> fg (color "#77e5b7") |> build) fmt

type model = { spinners : Sprite.t list }

let initial_model =
  {
    spinners =
      Spinner.
        [
          line;
          dot;
          mini_dot;
          jump;
          pulse;
          points;
          meter;
          globe;
          moon;
          monkey;
          hamburger;
          ellipsis;
        ];
  }

let init _ = Command.Hide_cursor

let update event model =
  match event with
  | Event.Frame now ->
      let spinners = model.spinners |> List.map (Sprite.update ~now) in
      ({ spinners }, Command.Noop)
  | Event.KeyDown (Key "q", _modifier) -> (model, Command.Quit)
  | _ -> (model, Command.Noop)

let view model =
  mint "%s" (String.concat "  " (List.map Sprite.view model.spinners))

let app = Minttea.app ~init ~update ~view ()
let () = Minttea.start ~initial_model app
