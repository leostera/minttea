type t

val make :
  string ->
  ?text_style:Spices.style ->
  ?placeholder_style:Spices.style ->
  ?cursor:Cursor.t ->
  ?placeholder:string ->
  ?prompt:string ->
  unit ->
  t
(** [make text ()] Create a new {Text_input.t}.

    If unspecified, it will use the `default_text_style`, `default_cursor`, and
    `default_prompt`.
   
    {@ocaml[
      let text_input = Text_input.make "Hello" ()
    ]}
*)

val empty : unit -> t
(** [empty ()] creates a new {Text_input.t} with an empty string and default
    configuration.

    {@ocaml[
      let text_input = Text_input.empty ()
    ]}
*)

val view : t -> string
(** [view text_input] renders [text_input] into a string.
    
    {@ocaml[
      let text_input = Text_input.make "Hello" () in
      let text: string = Text_input.view text_input
    ]}
*)

val update : t -> Minttea.Event.t -> t
(** [update text_input event] updates the [text_input] to handle cursor
    movement, text insertions etc.

    {@ocaml[
      let text_input = Text_input.update text_input event
    ]}
*)

val current_text : t -> string
(** [current_text t] gets the current text of the {Text_input} [t].

    {@ocaml[
      let text = Text_input.current_text text_input
    ]}
*)

val set_text : string -> t -> t
(** [set_text text t] updates the current text of [t] to [text].

    {@ocaml[
      let text = Text_input.make "hello" () in
      (* Text_input.current_text text == "hello" *)
      let new_text = Text_input.set_text "world" text in
      (* Text_input.current_text new_text == "world" *)
    ]}
*)
