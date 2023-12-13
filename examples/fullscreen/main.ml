open Minttea

let ref = Riot.Ref.make ()
let init _ = Command.Seq [ Set_timer (ref, 1.0); Enter_alt_screen ]
let initial_model () = 3

let update event model =
  match event with
  | Event.KeyDown ("q" | "esc" | "ctrl+c") -> (model, Command.Quit)
  | Event.Timer _ref ->
      let model = model - 1 in
      if model <= 0 then (model, Command.Quit)
      else (model, Command.Set_timer (ref, 1.0))
  | _ -> (model, Command.Noop)

let view model =
  Format.sprintf "\n\n     Hi. This program will exit in %d seconds...\n\n"
    model

let () = Minttea.app ~init ~initial_model ~update ~view () |> Minttea.start
