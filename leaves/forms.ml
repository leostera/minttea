let checkbox ?(checked = false) label =
  Format.sprintf "[%s] %s" (if checked then "x" else " ") label
