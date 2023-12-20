type t = float

let of_int i = 1.0 /. float_of_int i
let of_float f = 1.0 /. f

type time = Ptime.t

let ready_for_next_frame ~last_frame ~fps now =
  let delta = Ptime.diff last_frame now |> Ptime.Span.to_float_s |> Float.abs in
  delta > fps
