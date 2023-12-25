open Minttea
open Leaves

type model = { text : Text_input.t; quitting : bool }

let initial_model = { text = Text_input.empty (); quitting = false }
let init _ = Command.Noop

let update (event : Event.t) model =
  let s =
    match event with
    | e ->
        if e = Event.KeyDown Enter then
          ({ model with quitting = true }, Command.Quit)
        else
          let text = Text_input.update model.text e in
          ({ model with text }, Command.Noop)
  in
  s

let view model =
  if model.quitting then
    Format.sprintf "\n🐫 You typed: %s\n" @@ Text_input.value model.text
  else Format.sprintf "\n%s\n" @@ Text_input.view model.text

let app = Minttea.app ~init ~update ~view ()
let () = Minttea.start ~initial_model app
