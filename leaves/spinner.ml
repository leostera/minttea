type spinner = { frames : string array; fps : int }

let line = { frames = [| "|"; "/"; "-"; "\\" |]; fps = 10 }

let dot =
  { frames = [| "⣾ "; "⣽ "; "⣻ "; "⢿ "; "⡿ "; "⣟ "; "⣯ "; "⣷ " |]; fps = 10 }

let mini_dot =
  { frames = [| "⠋"; "⠙"; "⠹"; "⠸"; "⠼"; "⠴"; "⠦"; "⠧"; "⠇"; "⠏" |]; fps = 12 }

let jump = { frames = [| "⢄"; "⢂"; "⢁"; "⡁"; "⡈"; "⡐"; "⡠" |]; fps = 10 }

let pulse = { frames = [| "█"; "▓"; "▒"; "░" |]; fps = 8 }

let points = { frames = [| "∙∙∙"; "●∙∙"; "∙●∙"; "∙∙●" |]; fps = 7 }

let meter =
  { frames = [| "▱▱▱"; "▰▱▱"; "▰▰▱"; "▰▰▰"; "▰▰▱"; "▰▱▱"; "▱▱▱" |]; fps = 7 }

let globe = { frames = [| "🌍"; "🌎"; "🌏" |]; fps = 4 }

let moon = { frames = [| "🌑"; "🌒"; "🌓"; "🌔"; "🌕"; "🌖"; "🌗"; "🌘" |]; fps = 8 }

let monkey = { frames = [| "🙈"; "🙉"; "🙊" |]; fps = 3 }
let hamburger = { frames = [| "☱"; "☲"; "☴"; "☲" |]; fps = 3 }
let ellipsis = { frames = [| ""; "."; ".."; "..." |]; fps = 3 }

let view ~frame spinner =
  if frame > Array.length spinner.frames then "(error)"
  else spinner.frames.(frame)
