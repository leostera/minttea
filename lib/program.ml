open Riot

type Message.t += Timer of unit Ref.t | Shutdown
type 'model t = { app : 'model App.t; fps : int }

let make ~app ~fps = { app; fps }

exception Exit

let rec loop renderer (app : 'model App.t) (model : 'model) =
  match receive () with
  | Timer ref -> handle_input renderer app model (Event.Timer ref)
  | Io_loop.Input event -> handle_input renderer app model event
  | _ -> loop renderer app model

and handle_input renderer app model event =
  let model, cmd = app.update event model in
  let view = app.view model in
  match handle_cmd cmd renderer with
  | exception Exit ->
      Renderer.render renderer view;
      Renderer.shutdown renderer;
      wait_pids [ renderer ]
  | () ->
      Renderer.render renderer view;
      loop renderer app model

and handle_cmd cmd renderer =
  match cmd with
  | Quit -> raise Exit
  | Noop -> ()
  | Enter_alt_screen -> Renderer.enter_alt_screen renderer
  | Exit_alt_screen -> Renderer.exit_alt_screen renderer
  | Seq cmds -> List.iter (fun cmd -> handle_cmd cmd renderer) cmds
  | Set_timer (ref, after) ->
      let _ = Timer.send_after (self ()) (Timer ref) ~after |> Result.get_ok in
      ()

let init { app; _ } renderer =
  let initial_model = app.initial_model () in
  let init_cmd = app.init initial_model in
  handle_cmd init_cmd renderer;

  let view = app.view initial_model in
  Renderer.render renderer view;
  loop renderer app initial_model

let run ({ fps; _ } as t) =
  Printexc.record_backtrace true;
  let renderer = spawn (fun () -> Renderer.run ~fps) in
  let runner = spawn (fun () -> init t renderer) in
  let io = spawn (fun () -> Io_loop.run runner) in
  link io;
  wait_pids [ runner ];
  shutdown ()
