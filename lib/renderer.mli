val spawn_link : fps:int -> Riot.Pid.t
val render : Riot.Pid.t -> string -> unit
val enter_alt_screen : Riot.Pid.t -> unit
val exit_alt_screen : Riot.Pid.t -> unit
