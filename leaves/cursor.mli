type t

val make : ?style:Spices.style -> ?blink:bool -> ?fps:Fps.t -> unit -> t
(**
   Create a new {Cursor}.
*)

val update : t -> Minttea.Event.t -> t
(**
   Update the cursor. Note: This is only needed if `blink` is set to `true`.
 *)

val view : t -> ?text_style:Spices.style -> string -> string
(**
   Display cursor over given input string.
   `text_style` determines style when cursor is not visible.
  {[
    Cursor.view cursor " "
  ]}
 *)

val focus : t -> t
(**
   Make cursor visible and reset blink state to visible.
 *)

val unfocus : t -> t
(**
   Hide the cursor.
 *)
