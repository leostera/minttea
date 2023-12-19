open Riot

module Event : sig
  type key =
    | Up
    | Down
    | Left
    | Right
    | Space
    | Escape
    | Backspace
    | Enter
    | Key of string

  type t = KeyDown of key | Timer of unit Ref.t | Frame | Custom of Message.t

  val pp : Format.formatter -> t -> unit
end

module Command : sig
  type t =
    | Noop
    | Quit
    | Exit_alt_screen
    | Enter_alt_screen
    | Seq of t list
    | Set_timer of unit Riot.Ref.t * float
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
