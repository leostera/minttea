open Minttea
open Leaves

type model = { text : Text_input.t; quitting : bool }

let initial_model = { text = Text_input.empty (); quitting = false }
let init _ = Command.Noop

let update (event : Event.t) model =
  let s =
    match event with
    | KeyDown k ->
        if k = Enter then ({ model with quitting = true }, Command.Quit)
        else
          let text = Text_input.update model.text k in
          ({ model with text }, Command.Noop)
    | _ -> (model, Command.Noop)
  in
  s

let view model =
  if model.quitting then Format.sprintf "\n🐫 You typed: %s\n" model.text.value
  else Format.sprintf "\nType something: %s\n" @@ Text_input.view model.text

let app = Minttea.app ~init ~update ~view ()
let () = Minttea.start ~initial_model app
