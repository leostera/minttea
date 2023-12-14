open Riot
open Minttea

let ref = Riot.Ref.make ()
let download_ref = Riot.Ref.make ()
let finished_ref = Riot.Ref.make ()
let dot = Spices.(default |> fg (color "236") |> build) " • "
let subtle fmt = Spices.(default |> fg (color "241") |> build) fmt
let keyword fmt = Spices.(default |> fg (color "211") |> build) fmt
let highlight fmt = Spices.(default |> fg (color "#FF06B7") |> build) fmt

type selection_screen = { selected : int; options : string list; timeout : int }

let select_next screen =
  let option_count = List.length screen.options in
  let selected = screen.selected + 1 in
  let selected = if selected >= option_count then 0 else selected in
  { screen with selected }

let select_prev screen =
  let option_count = List.length screen.options in
  let selected = screen.selected - 1 in
  let selected = if selected < 0 then option_count - 1 else selected in
  { screen with selected }

type reading_screen = { timeout : int; percent : float; finished : bool }

type section =
  | Selection_screen of selection_screen
  | Reading_screen of reading_screen

exception Invalid_transition

let transition screen =
  match screen with
  | Selection_screen _select ->
      ( Reading_screen { timeout = 5; percent = 0.; finished = false },
        Command.Set_timer (download_ref, 0.5) )
  | _ -> raise Invalid_transition

type model = { quit : bool; section : section }

let init _ = Command.Set_timer (ref, 1.)

let initial_model () =
  {
    quit = false;
    section =
      Selection_screen
        {
          timeout = 9;
          selected = 0;
          options =
            [
              "Plant carrots";
              "Go to the market";
              "Read something";
              "See friends";
            ];
        };
  }

exception Exit

let update event model =
  try
    if event = Event.KeyDown "q" then raise Exit
    else
      let section, cmd =
        match model.section with
        | Reading_screen screen -> (
            match event with
            | Event.Timer ref when screen.finished && Ref.equal ref finished_ref
              ->
                let timeout = screen.timeout - 1 in
                if timeout = 0 then raise Exit
                else
                  ( Reading_screen { screen with timeout },
                    Command.Set_timer (finished_ref, 1.) )
            | Event.Timer ref
              when (not screen.finished) && Ref.equal ref download_ref ->
                let percent, finished =
                  if screen.percent < 1.0 then (screen.percent +. 0.03, false)
                  else (1.0, true)
                in
                ( Reading_screen { screen with percent; finished },
                  if finished then Command.Set_timer (finished_ref, 1.)
                  else Command.Set_timer (download_ref, 0.1) )
            | _ -> (model.section, Command.Noop))
        | Selection_screen screen -> (
            match event with
            | Event.KeyDown "space" -> transition model.section
            | Event.KeyDown ("j" | "down") ->
                (Selection_screen (select_next screen), Command.Noop)
            | Event.KeyDown ("k" | "up") ->
                (Selection_screen (select_prev screen), Command.Noop)
            | Event.Timer ref ->
                let timeout = screen.timeout - 1 in
                if timeout = 0 then raise Exit
                else
                  ( Selection_screen { screen with timeout },
                    Command.Set_timer (ref, 1.) )
            | _ -> (model.section, Command.Noop))
      in
      ({ model with section }, cmd)
  with Exit -> ({ model with quit = true }, Command.Quit)

let progress_bar_width = 50
let color_ramp = Leaves.Progress.default_color_ramp progress_bar_width
let progress_bar = Leaves.Progress.bar ~width:progress_bar_width ~color_ramp

let view model =
  if model.quit then "Bye 👋🏼"
  else
    match model.section with
    | Reading_screen screen when screen.finished ->
        Format.sprintf
          {|Reading time?

Okay, cool, then we'll need a library! Yes, an %s.

Done, waiting %d seconds before exiting...

|}
          (keyword "actual library") screen.timeout
    | Reading_screen screen ->
        Format.sprintf
          {|Reading time?

Okay, cool, then we'll need a library! Yes, an %s.

%s

|}
          (keyword "actual library")
          (progress_bar screen.percent)
    | Selection_screen screen ->
        let choices =
          List.mapi
            (fun idx choice ->
              let checked = idx = screen.selected in
              let checkbox = Leaves.Forms.checkbox ~checked choice in
              if checked then highlight "%s" checkbox else checkbox)
            screen.options
          |> String.concat "\n  "
        in
        let help =
          subtle "j/k: select" ^ dot ^ subtle "space: choose" ^ dot
          ^ subtle "q: quit"
        in

        Format.sprintf
          {|What do to today?

  %s

Program quits in %d seconds

%s
|} choices
          screen.timeout help

let () = Minttea.app ~init ~initial_model ~update ~view () |> Minttea.start
