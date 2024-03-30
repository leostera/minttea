open Riot

module Config : sig
  type t
end

val config : ?render_mode:[ `clear | `persist ] -> ?fps:int -> unit -> Config.t

module Event : sig
  type modifier = No_modifier | Ctrl

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

  type t =
    | KeyDown of key * modifier
    | Timer of unit Ref.t
    | Frame of Ptime.t
    | Custom of Message.t

  val pp : Format.formatter -> t -> unit
end

module Command : sig
  type t =
    | Noop
    | Quit
    | Hide_cursor
    | Show_cursor
    | Exit_alt_screen
    | Enter_alt_screen
    | Seq of t list
    | Set_timer of unit Riot.Ref.t * float
end

module App : sig
  type 'model t
end

val app :
  init:('model -> Command.t) ->
  update:(Event.t -> 'model -> 'model * Command.t) ->
  view:('model -> string) ->
  unit ->
  'model App.t

val run : ?config:Config.t -> initial_model:'model -> 'model App.t -> unit
val start : ?config:Config.t -> 'model App.t -> initial_model:'model -> unit
