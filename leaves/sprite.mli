type t

val make : ?starting_frame:int -> ?loop:bool -> fps:Fps.t -> string array -> t
val update : ?now:Ptime.t -> t -> t
val view : t -> string
