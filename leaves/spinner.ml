let line = Sprite.{ frames = [| "|"; "/"; "-"; "\\" |]; fps = Fps.of_int 10 }

let dot =
  Sprite.
    {
      frames = [| "⣾ "; "⣽ "; "⣻ "; "⢿ "; "⡿ "; "⣟ "; "⣯ "; "⣷ " |];
      fps = Fps.of_int 10;
    }

let mini_dot =
  Sprite.
    {
      frames = [| "⠋"; "⠙"; "⠹"; "⠸"; "⠼"; "⠴"; "⠦"; "⠧"; "⠇"; "⠏" |];
      fps = Fps.of_int 12;
    }

let jump =
  Sprite.
    { frames = [| "⢄"; "⢂"; "⢁"; "⡁"; "⡈"; "⡐"; "⡠" |]; fps = Fps.of_int 10 }

let pulse = Sprite.{ frames = [| "█"; "▓"; "▒"; "░" |]; fps = Fps.of_int 8 }

let points =
  Sprite.{ frames = [| "∙∙∙"; "●∙∙"; "∙●∙"; "∙∙●" |]; fps = Fps.of_int 7 }

let meter =
  Sprite.
    {
      frames = [| "▱▱▱"; "▰▱▱"; "▰▰▱"; "▰▰▰"; "▰▰▱"; "▰▱▱"; "▱▱▱" |];
      fps = Fps.of_int 7;
    }

let globe = Sprite.{ frames = [| "🌍"; "🌎"; "🌏" |]; fps = Fps.of_int 4 }

let moon =
  Sprite.
    {
      frames = [| "🌑"; "🌒"; "🌓"; "🌔"; "🌕"; "🌖"; "🌗"; "🌘" |];
      fps = Fps.of_int 8;
    }

let monkey = Sprite.{ frames = [| "🙈"; "🙉"; "🙊" |]; fps = Fps.of_int 3 }

let hamburger = Sprite.{ frames = [| "☱"; "☲"; "☴"; "☲" |]; fps = Fps.of_int 3 }

let ellipsis =
  Sprite.{ frames = [| ""; "."; ".."; "..." |]; fps = Fps.of_int 3 }

let update ~now s = Sprite.update ~now s
let view s = Sprite.view s
