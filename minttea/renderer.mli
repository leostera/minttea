open Riot

val run : fps:int -> runner:Pid.t -> unit
val render : Pid.t -> string -> unit
val enter_alt_screen : Pid.t -> unit
val exit_alt_screen : Pid.t -> unit
val shutdown : Pid.t -> unit
val show_cursor : Pid.t -> unit
val hide_cursor : Pid.t -> unit
