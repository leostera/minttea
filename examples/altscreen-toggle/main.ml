open Minttea

let red = Spices.color "204"
let gray = Spices.color "235"
let dark_gray = Spices.color "241"
let keyword = Spices.(default |> fg red |> bg gray |> build)
let help = Spices.(default |> fg dark_gray |> build)

type model = { altscreen : bool; quitting : bool }

let init _ = Command.Noop
let initial_model = { altscreen = false; quitting = false }

let update event model =
  match event with
  | Event.KeyDown ((Key "q" | Escape), _modifier) ->
      ({ model with quitting = true }, Command.Quit)
  | Event.KeyDown (Space, _modifier) ->
      let cmd =
        if model.altscreen then Command.Exit_alt_screen
        else Command.Enter_alt_screen
      in
      ({ model with altscreen = not model.altscreen }, cmd)
  | _ -> (model, Command.Noop)

let view model =
  if model.quitting then "Bye!\n"
  else
    let mode = if model.altscreen then "altscreen" else "inline" in
    let mode = keyword "%s" mode in
    let help = help "  space: switch modes • q: exit\n" in
    Format.sprintf "\n\n You're in %s mode\n\n\n%s" mode help

let () = Minttea.app ~init ~update ~view () |> Minttea.start ~initial_model
