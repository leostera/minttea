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
  let show width s = Shape_the_term.wrap_by_word width @@ style "%s" s in 
  if model.quitting then
    Format.sprintf "\n🐫 Your text wrapped by word ✨ (to 12 characters width):\n%s\n"
    @@ show 12  @@ Text_input.current_text model.text
  else 
    (Format.sprintf "\n%s\n" @@ show 36 @@ Text_input.view model.text) ^
    Format.sprintf "\n🐫 Wrap by word (to 12 characters width):\n%s\n"
    @@ show 12 @@ Text_input.current_text model.text

let app = Minttea.app ~init ~update ~view ()
let () = Minttea.start ~config:(config ~render_mode: `clear ~fps: 60 ()) ~initial_model app
