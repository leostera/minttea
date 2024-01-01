open Riot
module Event = Event
module Command = Command
module App = App
module Program = Program

let app = App.make

let run ?(fps = 60) ~initial_model app =
  let prog = Program.make ~app ~fps in
  Program.run prog initial_model

let start app ~initial_model =
  let module App = struct
    let name = "my_app"

    let start () =
      Logger.set_log_level None;
      let pid =
        spawn_link (fun () ->
            run app ~initial_model;
            shutdown ())
      in
      Ok pid
  end in
  Riot.start ~apps:[ (module Riot.Logger); (module App) ] ()
