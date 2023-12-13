module Event : sig
  type t = KeyDown of string

  val pp : Format.formatter -> t -> unit
end

module Command : sig
  type t = Noop | Quit | Exit_alt_screen | Enter_alt_screen
end

module App : sig
  type 'model t
end

val app :
  initial_model:(unit -> 'a) ->
  init:('a -> Command.t) ->
  update:(Event.t -> 'a -> 'a * Command.t) ->
  view:('a -> string) ->
  unit ->
  'a App.t

val start : 'a App.t -> unit
