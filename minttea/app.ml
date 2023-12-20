type 'model t = {
  init : 'model -> Command.t;
  update : Event.t -> 'model -> 'model * Command.t;
  view : 'model -> string;
}

let make ~init ~update ~view () = { init; update; view }
