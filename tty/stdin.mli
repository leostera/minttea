val read_utf8 :
  unit -> [> `Retry | `End | `Malformed of string | `Read of string ]
(** [read_utf8 ()] will do a non-blocking read and either return the next valid UTF-8 string available in [stdin] or immediately return. *)

val setup : unit -> Unix.terminal_io
(** [setup ()] sets up the [stdin] for async reading. *)

val shutdown : Unix.terminal_io -> unit
(** [shutdown ()] restores the [stdin].*)
