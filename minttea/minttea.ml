open Riot
module Event = Event
module Command = Command
module App = App
module Program = Program
module Config = Config

let config ?(render_mode = `clear) ?(fps = 60) () = Config.{ render_mode; fps }
let app = App.make

let run ?(config = config ()) ~initial_model app =
  let prog = Program.make ~app ~config in
  Program.run prog initial_model;
  Logger.trace (fun f -> f "terminating")

let start ?(config = config ()) app ~initial_model =
  let module App = struct
    let start () =
      Logger.set_log_level None;
      let pid =
        spawn_link (fun () ->
            run ~config app ~initial_model;
            Logger.trace (fun f -> f "about to shutdown");
            shutdown ~status:0 ())
      in
      Ok pid
  end in
  Riot.start ~apps:[ (module Riot.Logger); (module App) ] ()
