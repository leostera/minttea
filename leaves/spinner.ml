type spinner = { frames : string array; fps : Fps.t }

let line = { frames = [| "|"; "/"; "-"; "\\" |]; fps = Fps.of_int 10 }

let dot =
  {
    frames = [| "⣾ "; "⣽ "; "⣻ "; "⢿ "; "⡿ "; "⣟ "; "⣯ "; "⣷ " |];
    fps = Fps.of_int 10;
  }

let mini_dot =
  {
    frames = [| "⠋"; "⠙"; "⠹"; "⠸"; "⠼"; "⠴"; "⠦"; "⠧"; "⠇"; "⠏" |];
    fps = Fps.of_int 12;
  }

let jump =
  { frames = [| "⢄"; "⢂"; "⢁"; "⡁"; "⡈"; "⡐"; "⡠" |]; fps = Fps.of_int 10 }

let pulse = { frames = [| "█"; "▓"; "▒"; "░" |]; fps = Fps.of_int 8 }

let points = { frames = [| "∙∙∙"; "●∙∙"; "∙●∙"; "∙∙●" |]; fps = Fps.of_int 7 }

let meter =
  {
    frames = [| "▱▱▱"; "▰▱▱"; "▰▰▱"; "▰▰▰"; "▰▰▱"; "▰▱▱"; "▱▱▱" |];
    fps = Fps.of_int 7;
  }

let globe = { frames = [| "🌍"; "🌎"; "🌏" |]; fps = Fps.of_int 4 }

let moon =
  { frames = [| "🌑"; "🌒"; "🌓"; "🌔"; "🌕"; "🌖"; "🌗"; "🌘" |]; fps = Fps.of_int 8 }

let monkey = { frames = [| "🙈"; "🙉"; "🙊" |]; fps = Fps.of_int 3 }
let hamburger = { frames = [| "☱"; "☲"; "☴"; "☲" |]; fps = Fps.of_int 3 }
let ellipsis = { frames = [| ""; "."; ".."; "..." |]; fps = Fps.of_int 3 }

type t = { spinner : spinner; frame : int; last_frame : Fps.time }

let update ~now s =
  if Fps.ready_for_next_frame ~last_frame:s.last_frame ~fps:s.spinner.fps now
  then
    {
      s with
      frame = (s.frame + 1) mod Array.length s.spinner.frames;
      last_frame = now;
    }
  else s

let view s =
  if s.frame > Array.length s.spinner.frames then "(error)"
  else s.spinner.frames.(s.frame)
