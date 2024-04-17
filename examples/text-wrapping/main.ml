open Minttea
open Leaves

type model = { text : Text_input.t; quitting : bool }

let mint = Spices.color "#77e5b7"
let white = Spices.color "#FFFFFF"

let cursor =
  Cursor.make ~style:Spices.(default |> bg mint |> fg white |> bold true) ()

let initial_model =
  {
    text = Text_input.make "" ~placeholder:"Type something" ~cursor ();
    quitting = false;
  }

let init _ = Command.Hide_cursor

let update (event : Event.t) model =
  let s =
    match event with
    | e ->
        if e = Event.KeyDown (Enter, No_modifier) then
          ({ model with quitting = true }, Command.Quit)
        else
          let text = Text_input.update model.text e in
          ({ model with text }, Command.Noop)
  in
  s

let view model =
  let style = Spices.(default |> fg mint |> build) in
  let width = 12 in 
  let show s = Shape_the_term.wrap width @@ style "%s" s in 
  if model.quitting then
    Format.sprintf "\n🐫 Your text wrapped ✨ (to %s characters width):\n%s\n" (string_of_int width) 
    @@ show @@ Text_input.current_text model.text
  else 
    Format.sprintf "\n🐫 Text area (%s characters width):\n%s\n" (string_of_int width)
    @@ show @@ Text_input.view model.text

let app = Minttea.app ~init ~update ~view ()
let () = Minttea.start ~config:(config ~render_mode: `clear ~fps: 60 ()) ~initial_model app
