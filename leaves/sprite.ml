type sprite = { frames : string array; fps : Fps.t }
type t = { sprite : sprite; frame : int; last_frame : Fps.time }

let update ~now s =
  if Fps.ready_for_next_frame ~last_frame:s.last_frame ~fps:s.sprite.fps now
  then
    {
      s with
      frame = (s.frame + 1) mod Array.length s.sprite.frames;
      last_frame = now;
    }
  else s

let view s =
  if s.frame > Array.length s.sprite.frames then "(error)"
  else s.sprite.frames.(s.frame)
