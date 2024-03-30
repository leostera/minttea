open Riot

type Message.t += Timer of unit Ref.t | Shutdown
type 'model t = { app : 'model App.t; fps : int }

let make ~app ~fps = { app; fps }

exception Exit

let rec loop renderer (app : 'model App.t) (model : 'model) =
  let event =
    match receive_any () with
    | Timer ref -> Event.Timer ref
    | Io_loop.Input event -> event
    | message -> Event.Custom message
  in
  handle_input renderer app model event

and handle_input renderer app model event =
  let model, cmd = app.update event model in
  let view = app.view model in
  match handle_cmd cmd renderer with
  | exception Exit ->
      Renderer.render renderer view;
      Renderer.show_cursor renderer;
      Renderer.exit_alt_screen renderer;
      Renderer.shutdown renderer;
      Logger.trace (fun f -> f "runner is waiting for renderer to finish ");
      wait_pids [ renderer ];
      Logger.trace (fun f -> f "renderer finishied")
  | () ->
      Renderer.render renderer view;
      loop renderer app model

and handle_cmd cmd renderer =
  match cmd with
  | Quit -> raise Exit
  | Noop -> ()
  | Hide_cursor -> Renderer.hide_cursor renderer
  | Show_cursor -> Renderer.show_cursor renderer
  | Enter_alt_screen -> Renderer.enter_alt_screen renderer
  | Exit_alt_screen -> Renderer.exit_alt_screen renderer
  | Seq cmds -> List.iter (fun cmd -> handle_cmd cmd renderer) cmds
  | Set_timer (ref, after) ->
      (* NOTE(@leostera): Riot works in microseconds and 1 second = 1_000_000 micros *)
      let after = after *. 1_000_000.0 |> Int64.of_float in
      let _ = Timer.send_after (self ()) (Timer ref) ~after |> Result.get_ok in
      ()

let init { app; _ } initial_model renderer =
  let init_cmd = app.init initial_model in
  handle_cmd init_cmd renderer;

  let view = app.view initial_model in
  Renderer.render renderer view;
  loop renderer app initial_model

let run ({ fps; _ } as t) initial_model =
  Printexc.record_backtrace true;
  let renderer =
    spawn (fun () ->
        (* NOTE(@leostera): reintroduce this when riot brings back process-stealing *)
        (* process_flag (Priority High); *)
        let runner = Process.await_name "Minttea.runner" in
        Renderer.run ~fps ~runner)
  in
  let runner =
    spawn (fun () ->
        register "Minttea.runner" (self ());
        init t initial_model renderer;
        Logger.trace (fun f -> f "runner finished"))
  in
  let io =
    spawn (fun () ->
        Io_loop.run runner;
        Logger.trace (fun f -> f "io finished"))
  in
  Logger.trace (fun f -> f "program is waiting for runner and io to finish");
  wait_pids [ runner; io ];
  Logger.trace (fun f -> f "runner and io finished")
