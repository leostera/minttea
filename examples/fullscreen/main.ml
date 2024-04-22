open Minttea

let ref = Riot.Ref.make ()
let init _ = Command.Seq [ Set_timer (ref, 1.0); Enter_alt_screen ]
let initial_model = 3

let update event model =
  match event with
  | Event.KeyDown ((Key "q" | Escape), _modifier) -> (model, Command.Quit)
  | Event.Timer _ref ->
      let model = model - 1 in
      if model <= 0 then (model, Command.Quit)
      else (model, Command.Set_timer (ref, 1.0))
  | _ -> (model, Command.Noop)

let dark_gray = Spices.color "#767676"
let bold fmt = Spices.(default |> bold true |> build) fmt

let time fmt =
  Spices.(default |> italic true |> fg dark_gray |> max_width 22 |> build) fmt

let view model =
  let hi = bold "Hi" in
  let seconds = time "%d seconds" model in
  Format.sprintf "\n\n     %s. This program will exit in %s...\n\n" hi seconds

let () = Minttea.app ~init ~update ~view () |> Minttea.start ~initial_model
