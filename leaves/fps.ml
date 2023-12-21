type t = { frame_rate : float; mutable next_frame : Ptime.t }

let add_span time rate =
  Ptime.add_span time (Ptime.Span.of_float_s rate |> Option.get) |> Option.get

let make frame_rate =
  { frame_rate; next_frame = add_span (Ptime_clock.now ()) frame_rate }

let of_int i = make (1.0 /. float_of_int i)
let of_float f = make (1.0 /. f)

let tick ?(now = Ptime_clock.now ()) t =
  if Ptime.is_later now ~than:t.next_frame then (
    t.next_frame <- add_span now t.frame_rate;
    `frame)
  else `skip
