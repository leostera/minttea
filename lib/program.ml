open Riot
open Messages

type 'model t = { app : 'model App.t }

let make app = { app }

let rec run renderer (app : 'model App.t) (model : 'model) =
  match receive () with
  | Input event ->
      Logger.debug (fun f -> f "event: %a" Event.pp event);
      let model, cmd = app.update event model in
      let view = app.view model in
      send renderer (Render view);
      handle_cmd cmd renderer app model
  | _ -> run renderer app model

and handle_cmd cmd renderer app model =
  match cmd with Quit -> () | _ -> run renderer app model

let run_loop (app : 'model App.t) renderer =
  let initial_model = app.initial_model () in
  let _init_cmd = app.init initial_model in
  let _final_model = run renderer app initial_model in
  ()

let run { app } =
  register "Minttea.runner" (self ());

  let io = Io_loop.spawn_link () in
  register "Minttea.io" io;

  let renderer = Renderer.spawn_link () in
  register "Minttea.renderer" renderer;

  run_loop app renderer;

  shutdown ()
