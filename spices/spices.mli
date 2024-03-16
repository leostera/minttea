type color = Tty.Color.t = private
  | RGB of int * int * int
  | ANSI of int
  | ANSI256 of int
  | No_color

val color : ?profile:Tty.Profile.t -> string -> color
val gradient : start:color -> finish:color -> steps:int -> color array

module Border : sig
  type t

  val make :
    ?top:string ->
    ?left:string ->
    ?bottom:string ->
    ?right:string ->
    ?top_left:string ->
    ?top_right:string ->
    ?bottom_left:string ->
    ?bottom_right:string ->
    ?middle_left:string ->
    ?middle_right:string ->
    ?middle:string ->
    ?middle_top:string ->
    ?middle_bottom:string ->
    unit ->
    t

  val normal : t
  val rounded : t
  val block : t
  val outer_half_block : t
  val inner_half_block : t
  val thick : t
  val double : t
  val hidden : t
end

type style

val default : style
val bg : color -> style -> style
val blink : bool -> style -> style
val bold : bool -> style -> style
val faint : bool -> style -> style
val fg : color -> style -> style
val height : int -> style -> style
val italic : bool -> style -> style
val margin_bottom : int -> style -> style
val margin_left : int -> style -> style
val margin_right : int -> style -> style
val margin_top : int -> style -> style
val max_height : int -> style -> style
val max_width : int -> style -> style
val padding_bottom : int -> style -> style
val padding_left : int -> style -> style
val padding_right : int -> style -> style
val padding_top : int -> style -> style
val reverse : bool -> style -> style
val strikethrough : bool -> style -> style
val underline : bool -> style -> style
val width : int option -> style -> style
val border : Border.t -> style -> style

type 'a style_fun =
  ('a, Format.formatter, unit, unit, unit, string) format6 -> 'a

val build : 'a. style -> 'a style_fun
