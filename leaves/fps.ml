type t = float

let of_int i = 1.0 /. float_of_int i
let of_float f = 1.0 /. f

type time = Ptime.t

let now = Ptime_clock.now
let is_later = Ptime.is_later

let time_of_next_frame ~last_frame ~fps =
  Ptime.add_span last_frame (Ptime.Span.of_float_s fps |> Option.get)
  |> Option.get
