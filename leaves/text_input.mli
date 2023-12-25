type t = {
  value : string;
  cursor : int;
  text_style : Spices.style;
  cursor_style : Spices.style;
}

val make :
  value:string ->
  ?text_style:Spices.style ->
  ?cursor_style:Spices.style ->
  unit ->
  t
(**
   Create a new {Text_input}. You can optionally provide styles for the text and/or the cursor.
   
   {[
     let text_input = Text_input.make ~value:"Hello" ()
   ]}
*)

val empty : unit -> t
(**
  Create a new {Text_input} with an empty string and default styles.

  {[
    let text_input = Text_input.empty ()
  ]}
*)

val view : t -> string
(** 
    Render the {Text_input} as a string.
    
    {[
      let text_input = Text_input.make ~value:"Hello" ()
      let text = Text_input.view text_input
    ]}
*)

val update : t -> Minttea.Event.key -> t
(**
   Given a {Text_input} and a {Minttea.Event.key}, update the {Text_input}.

   This maps the key event to the corresponding actions which are also exposed
   for manual use.

   {[
     let text_input = Text_input.update text_input key
   ]}
*)

val write : t -> string -> t
val space : t -> t
val backspace : t -> t
val move_cursor : t -> [ `Character_backward | `Character_forward ] -> t
val character_backward : t -> t
val character_forward : t -> t
