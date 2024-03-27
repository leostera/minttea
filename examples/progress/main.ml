open Minttea
open Leaves

let init _ = Command.Noop

type model = {
  gray_bar : Progress.t;
  color_bar : Progress.t;
  emoji_bar : Progress.t;
  no_percentage_bar : Progress.t;
}

let initial_model =
  let width = 50 in
  {
    gray_bar = Progress.make ~width ~color:(`Plain (Spices.color "#3fa2a3")) ();
    color_bar =
      Progress.make ~width
        ~color:(`Gradient (Spices.color "#b14fff", Spices.color "#00ffa3"))
        ();
    emoji_bar =
      Progress.make ~full_char:"⭐" ~trail_char:"🚀" ~width:25
        ~color:(`Plain (Spices.color "#000000"))
        ();
    no_percentage_bar =
      Progress.make ~width
        ~color:(`Plain (Spices.color "#4776E6"))
        ~show_percentage:false ();
  }

let update event m =
  match event with
  | Event.KeyDown ((Key "q" | Escape), _modifier) -> (m, Command.Quit)
  | Event.Frame _now ->
      let gray_bar = Progress.increment m.gray_bar 0.001 in
      let color_bar = Progress.increment m.color_bar (Random.float 0.0001) in
      let emoji_bar = Progress.increment m.emoji_bar 0.00005 in
      let no_percentage_bar = Progress.increment m.no_percentage_bar 0.00003 in
      ({ gray_bar; color_bar; emoji_bar; no_percentage_bar }, Command.Noop)
  | _ -> (m, Command.Noop)

let view m =
  Format.sprintf "\n\n%s\n\n%s\n\n%s\n\n%s\n\n" (Progress.view m.gray_bar)
    (Progress.view m.color_bar)
    (Progress.view m.emoji_bar)
    (Progress.view m.no_percentage_bar)

let () = Minttea.app ~init ~update ~view () |> Minttea.start ~initial_model
