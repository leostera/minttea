open Minttea

type s = { counter : int; keys : string list }

let init _ = Command.Noop
let initial_model () = { counter = 0; keys = [] }

let update event model =
  match event with
  | Event.KeyDown "q" -> (model, Command.Quit)
  | Event.KeyDown k ->
      let model = { counter = model.counter + 1; keys = model.keys @ [ k ] } in
      (model, Command.Noop)
  | _ -> (model, Command.Noop)

let view model =
  if model.counter = -1 then "goodbye! "
  else Printf.sprintf "%d - %s" model.counter (String.concat "" model.keys)

let app = Minttea.app ~initial_model ~init ~update ~view ()
let () = Minttea.start app
