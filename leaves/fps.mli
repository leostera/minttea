type t

val of_int : int -> t
val of_float : float -> t
val tick : ?now:Ptime.t -> t -> [ `frame | `skip ]
