type t

val make :
  ?percent:float ->
  ?full_char:string ->
  ?trail_char:string ->
  ?empty_char:string ->
  ?color:
    [< `Gradient of Spices.color * Spices.color
    | `Plain of Spices.color > `Plain ] ->
  width:int ->
  unit ->
  t

val is_finished : t -> bool
val reset : t -> t
val increment : t -> float -> t
val view : t -> string
