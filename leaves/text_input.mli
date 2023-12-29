type t

val make :
  string ->
  ?text_style:Spices.style ->
  ?cursor:Cursor.t ->
  ?prompt:string ->
  unit ->
  t
(**
   Create a new {Text_input}.
   
   {[
     let text_input = Text_input.make "Hello" ()
   ]}
*)

val empty : unit -> t
(**
  Create a new {Text_input} with an empty string and default configuration.

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

val update : t -> Minttea.Event.t -> t
(**
   Given a {Text_input} and a {Minttea.Event.t} update the {Text_input} to
   handle cursor movement, text insertions etc.

   {[
     let text_input = Text_input.update text_input event
   ]}
*)

val current_text : t -> string
(**
   Get the current text of the {Text_input}.

   {[
     let text = Text_input.current_text text_input
   ]}
*)

val set_text : string -> t -> t
(**
   Set the current text in the {Text_input}.
*)
