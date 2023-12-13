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

let dark_gray = Spices.color "#767676"
let hi_style = Spices.(default |> bold true)

let time_style =
  Spices.(default |> italic true |> fg dark_gray |> max_width 22)

let view model =
  let hi = Spices.render hi_style "Hi" in
  let seconds = Spices.render time_style "%d seconds" model in
  Spices.(
    render default "\n\n     %s. This program will exit in %s...\n\n" hi seconds)

let () = Minttea.app ~init ~initial_model ~update ~view () |> Minttea.start
