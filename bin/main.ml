type s = { counter : int; keys : string list };;

Minttea.app
  ~initial_model:(fun () -> { counter = 0; keys = [] })
  ~init:(fun _ -> Noop)
  ~update:(fun ~msg model ->
    match msg with
    | KeyDown "q" -> (model, Quit)
    | KeyDown k ->
        let model = { counter = model.counter + 1; keys = k :: model.keys } in
        (model, Noop))
  ~view:(fun model ->
    if model.counter = -1 then "goodbye! "
    else Printf.sprintf "%d - %s" model.counter (String.concat ", " model.keys))
  ()
|> Minttea.start
