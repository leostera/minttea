type t

val default_style : Spices.style
(** The default style used for the cursor. *)

val default_fps : Fps.t
(** The default blinking rate. *)

val make : ?style:Spices.style -> ?blink:bool -> ?fps:Fps.t -> unit -> t
(** [make ()] creates a default cursor that will be blinking and use the
    [default_style].

    [make ~style ~blink ~fps ()] will create a custom cursor that will use the
    [style] style, and will blink at a speed of [fps].
*)

val update : t -> Minttea.Event.t -> t
(** [update t e] updates the cursor [t] with information from the event [e].
    Note: This is only needed if `blink` is set to `true`.
 *)

val view : t -> text_style:Spices.style -> string -> string
(** [view t ~text_style text] will display the cursor over a given input of the
    string [text].

    When the cursor is not visible, for example while blinking, [text_style]
    determines style when cursor is not visible.

    {@ocaml[
      Cursor.view cursor " "
    ]}
 *)

val focus : t -> t
(** [focus t] make the cursor [t] visible and reset blink state to visible. *)

val unfocus : t -> t
(** [unfocus t] hides the cursor [t]. *)

val enable_blink : t -> t
(** [enable_blink t] enables blinking for the cursor [t]. *)

val disable_blink : t -> t
(** [disable_blink t] disables blinking for the cursor [t]. *)
