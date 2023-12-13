open Riot

type 'model t = { app : 'model App.t; fps : int }

let make ~app ~fps = { app; fps }

exception Exit

let rec run renderer (app : 'model App.t) (model : 'model) =
  match receive () with
  | Io_loop.Input event ->
      Logger.debug (fun f -> f "event: %a" Event.pp event);
      let model, cmd = app.update event model in
      let view = app.view model in
      handle_cmd cmd renderer;
      Renderer.render renderer view;
      run renderer app model
  | _ -> run renderer app model

and handle_cmd cmd renderer =
  match cmd with
  | Quit -> raise Exit
  | Noop -> ()
  | Enter_alt_screen -> Renderer.enter_alt_screen renderer
  | Exit_alt_screen -> Renderer.exit_alt_screen renderer

let run { app; fps } =
  register "Minttea.runner" (self ());

  let io = Io_loop.spawn_link () in
  register "Minttea.io" io;

  let renderer = Renderer.spawn_link ~fps in
  register "Minttea.renderer" renderer;

  let initial_model = app.initial_model () in
  let _init_cmd = app.init initial_model in
  let view = app.view initial_model in
  Renderer.render renderer view;
  try run renderer app initial_model
  with Exit ->
    ();

    shutdown ()
