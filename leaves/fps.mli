type t

val of_int : int -> t
val of_float : float -> t

type time

val now : unit -> time
val is_later : time -> than:time -> bool
val time_of_next_frame : last_frame:time -> fps:t -> time
