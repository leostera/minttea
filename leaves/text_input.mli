type t

val make :
  value:string ->
  ?text_style:Spices.style ->
  ?cursor_style:Spices.style ->
  ?prompt:string ->
  unit ->
  t
(**
   Create a new {Text_input}.
   
   {[
     let text_input = Text_input.make ~value:"Hello" ()
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
   Given a {Text_input} and a {Minttea.Event.key}, update the {Text_input}.

   {[
     let text_input = Text_input.update text_input key
   ]}
*)

val current_text : t -> string
(**
   Get the current text of the {Text_input}.

   {[
     let text = Text_input.current_text text_input
   ]}
*)
