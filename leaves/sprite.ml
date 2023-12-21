type t = {
  frames : string array;
  current_frame : int;
  fps : Fps.t;
  loop : bool;
}

let make ?(starting_frame = 0) ?(loop = true) ~fps frames =
  { frames; fps; loop; current_frame = starting_frame }

let advance_frame m =
  let next_frame = m.current_frame + 1 in
  if m.loop then next_frame mod Array.length m.frames
  else
    let last_frame = Array.length m.frames - 1 in
    min last_frame next_frame

let update ?now m =
  if Fps.tick ?now m.fps = `frame then
    let current_frame = advance_frame m in
    { m with current_frame }
  else m

let view s =
  if s.current_frame > Array.length s.frames then
    let exception Frame_out_of_bounds in
    raise Frame_out_of_bounds
  else s.frames.(s.current_frame)
