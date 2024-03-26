open Riot
open Minttea
open Leaves

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

type reading_screen = {
  timeout : int;
  progress : Progress.t;
  spinner : Sprite.t;
  finished : bool;
}

type section =
  | Selection_screen of selection_screen
  | Reading_screen of reading_screen

exception Invalid_transition

let transition screen =
  match screen with
  | Selection_screen _select ->
      ( Reading_screen
          {
            timeout = 5;
            progress =
              Progress.make ~width:50
                ~color:
                  (`Gradient (Spices.color "#b14fff", Spices.color "#00ffa3"))
                ();
            finished = false;
            spinner = Spinner.globe;
          },
        Command.Set_timer (download_ref, 0.5) )
  | _ -> raise Invalid_transition

type model = { quit : bool; section : section }

let init _ = Command.Set_timer (ref, 1.)

let initial_model =
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
    if event = Event.KeyDown (Key "q", No_modifier) then raise Exit
    else
      let section, cmd =
        match model.section with
        | Reading_screen screen -> (
            match event with
            | Event.Frame now ->
                let spinner = Sprite.update ~now screen.spinner in
                (Reading_screen { screen with spinner }, Command.Noop)
            | Event.Timer ref when screen.finished && Ref.equal ref finished_ref
              ->
                let timeout = screen.timeout - 1 in
                if timeout = 0 then raise Exit
                else
                  ( Reading_screen { screen with timeout },
                    Command.Set_timer (finished_ref, 1.) )
            | Event.Timer ref
              when (not screen.finished) && Ref.equal ref download_ref ->
                let progress = Progress.increment screen.progress 0.03 in
                let finished = Progress.is_finished progress in
                ( Reading_screen { screen with progress; finished },
                  if finished then Command.Set_timer (finished_ref, 1.)
                  else Command.Set_timer (download_ref, 0.1) )
            | _ -> (model.section, Command.Noop))
        | Selection_screen screen -> (
            match event with
            | Event.KeyDown (Space, _modifier) -> transition model.section
            | Event.KeyDown ((Key "j" | Down), _modifier) ->
                (Selection_screen (select_next screen), Command.Noop)
            | Event.KeyDown ((Key "k" | Up), _modifier) ->
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

let view model =
  if model.quit then "Bye 👋🏼"
  else
    match model.section with
    | Reading_screen screen when screen.finished ->
        Format.sprintf
          {|Reading time?

Okay, cool, then we'll need a library! Yes, an %s.

Done, waiting %d seconds before exiting... %s

|}
          (keyword "actual library") screen.timeout
          (Sprite.view screen.spinner)
    | Reading_screen screen ->
        Format.sprintf
          {|Reading time?

Okay, cool, then we'll need a library! Yes, an %s.

%s

|}
          (keyword "actual library")
          (Progress.view screen.progress)
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

let () = Minttea.app ~init ~update ~view () |> Minttea.start ~initial_model
