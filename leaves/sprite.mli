type t
(** A string-based animation that can be looped, and runs at a specific
    frame-rate
*)

val make : ?starting_frame:int -> ?loop:bool -> fps:Fps.t -> string array -> t
(** [ make ~fps:(Fps.of_int 30) [| "1"; "2"; "3" |] ] creates a new {Sprite.t}
    that will use the strings ["1"], ["2"], and ["3"] as its frames, and will
    run the animation at 30 frames per second.

    By default the starting frame will be the 0-th element of the frames array,
    and the animation will loop indefinitely.

    If you need your animation to start at a different frame, you can indicate
    it by passing [starting_frame]. Note that this value must be within the
    bounds of the array.

    If you'd like the animation to stop once it reaches the end, you can pass
    [~loop:false].
*)

val update : ?now:Ptime.t -> t -> t
(** [update t] will update the {Sprite.t} based on the current time or a
    specific time if [~now] is passed.

    Normally this function is called within an `update` loop, like this:

    {@ocaml[
      match e with
      | Frame now ->
        let spinner = Sprite.update ~now model.spinner in
        (spinned, Command.Noop)
      | _ ->
        (* ... *)
    ]}
*)

val view : t -> string
(** [view t] renders the current sprite into a string. *)
