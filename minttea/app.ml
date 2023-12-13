type 'model t = {
  initial_model : unit -> 'model;
  init : 'model -> Command.t;
  update : Event.t -> 'model -> 'model * Command.t;
  view : 'model -> string;
}

let make ~initial_model ~init ~update ~view () =
  { initial_model; init; update; view }
