type t
(** An {Fps.t} is a little utility you can use to let the frame-rate guide some
    behavior.

    It can be used for animation purposes, or as a rough timer.

    It is mutable, so references to it are important.

    To use it we first create it, and then call the {Fps.tick} function with
    the current time. This lets the internal clock update itself and signal
    whether a frame or more has passed, or if there is no need to act yet.
*)

val of_int : int -> t
(** [of_int n] creates an {Fps.t} that will sync to [n] frames per second. *)

val of_float : float -> t
(** [of_float f] creates an {Fps.t} that will sync to [f] frames per second.

    Float values will be rounded down.
*)

val tick : ?now:Ptime.t -> t -> [ `frame | `skip ]
(** [tick t] updates the internal Fps clock in [t] and returns whether we are now in
    a new frame ([`frame]) or if we should skip the current action ([`skip]).

    Normally you call [`tick] in an [`update] loop, and if it is [`frame] you
    do some work:

    {@ocaml[
      if Fps.tick ?now m.fps = `frame then
        let current_frame = advance_frame m in
        { m with current_frame }
      else m
    ]}
*)
