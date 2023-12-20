type t

val of_int : int -> t
val of_float : float -> t

type time = Ptime.t

val ready_for_next_frame : last_frame:time -> fps:t -> time -> bool
