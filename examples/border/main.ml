open Minttea

let red_with_border fmt =
  Spices.(
    default |> border Border.thick |> padding_left 5 |> padding_right 5
    |> fg (color "#FF0000")
    |> build)
    fmt

let overlay_border fmt = Spices.(default |> border Border.double |> build) fmt

type s = { text : string }

let init _ = Command.Noop
let initial_model = { text = "" }

let update event model =
  match event with
  | Event.KeyDown (Key { key = "q"; _ } | Escape) -> (model, Command.Quit)
  | Event.KeyDown (Key { key = k; _ }) ->
      let model = { text = model.text ^ k } in
      (model, Command.Noop)
  | Event.KeyDown Space ->
      let model = { text = model.text ^ " " } in
      (model, Command.Noop)
  | Event.KeyDown Enter ->
      let model = { text = model.text ^ "\n" } in
      (model, Command.Noop)
  | _ -> (model, Command.Noop)

let view model = overlay_border "%s" (red_with_border "%s" model.text)
let () = Minttea.app ~init ~update ~view () |> Minttea.start ~initial_model
