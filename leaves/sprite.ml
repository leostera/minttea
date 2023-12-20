type sprite = {
  frames : string array;
  fps : Fps.t;
  starting_frame : int;
  loop : bool;
}

let make ?(starting_frame = 0) ?(loop = true) ~fps frames =
  { frames; fps; starting_frame; loop }

type model = { sprite : sprite; frame : int; next_frame : Fps.time }

let init sprite =
  {
    sprite;
    frame = sprite.starting_frame;
    next_frame = Fps.time_of_next_frame ~last_frame:(Fps.now ()) ~fps:sprite.fps;
  }

type event = Frame

let update e m =
  match e with
  | Frame ->
      if Fps.(is_later (now ()) ~than:m.next_frame) then
        {
          m with
          frame =
            (if m.sprite.loop then
               (m.frame + 1) mod Array.length m.sprite.frames
             else min (Array.length m.sprite.frames - 1) (m.frame + 1));
          next_frame =
            Fps.time_of_next_frame ~last_frame:m.next_frame ~fps:m.sprite.fps;
        }
      else m

let view s =
  if s.frame > Array.length s.sprite.frames then
    let exception Frame_out_of_bounds in
    raise Frame_out_of_bounds
  else s.sprite.frames.(s.frame)
