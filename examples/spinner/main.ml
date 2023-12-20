open Minttea
open Leaves

let mint fmt = Spices.(default |> fg (color "#77e5b7") |> build) fmt

type model = { spinners : Sprite.model list }

let initial_model =
  {
    spinners =
      Spinner.
        [
          Sprite.init line;
          Sprite.init dot;
          Sprite.init mini_dot;
          Sprite.init jump;
          Sprite.init pulse;
          Sprite.init points;
          Sprite.init meter;
          Sprite.init globe;
          Sprite.init moon;
          Sprite.init monkey;
          Sprite.init hamburger;
          Sprite.init ellipsis;
        ];
  }

let init _ = Command.Noop

let update event model =
  match event with
  | Event.Frame ->
      let spinners = model.spinners |> List.map (Sprite.update Frame) in
      ({ spinners }, Command.Noop)
  | Event.KeyDown (Key "q") -> (model, Command.Quit)
  | _ -> (model, Command.Noop)

let view model =
  mint "%s" (String.concat "  " (List.map Sprite.view model.spinners))

let app = Minttea.app ~init ~update ~view ()
let () = Minttea.start ~initial_model app
