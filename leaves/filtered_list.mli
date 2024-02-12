type t

val make :
  string list ->
  ?cursor:string ->
  ?style_selected:Spices.style ->
  ?style_unselected:Spices.style ->
  ?max_height:int ->
  unit ->
  t
(** Create a new list component *)

val show_string_contains : t -> string -> t
(** Only show elements that contain a given substring *)

val show_pred : t -> (int -> string -> bool) -> t
(** Show elements matching a predicate *)

val show_all : t -> t
(** Clear filtering *)

val update : Minttea.Event.t -> t -> t
(** Update the component based on events *)

val view : t -> string
(** Produce the view as a string *)

val get_selection : t -> string list
(** Return the selected elements of the list *)

val append : t -> string list -> t
(** Append more elements at the end of the list *)

val filter : t -> (int -> string -> bool) -> t
(** Permanently remove elements not verifying the predicate *)
