open Tty

type format =
  | Reset
  | Bold
  | Faint
  | Italic
  | Underline
  | Blink
  | Reverse
  | Cross_out
  | Overline
  | Foreground of Color.t
  | Background of Color.t

let to_string fmt =
  match fmt with
  | Reset -> Escape_seq.reset_seq
  | Bold -> Escape_seq.bold_seq
  | Faint -> Escape_seq.faint_seq
  | Italic -> Escape_seq.italics_seq
  | Underline -> Escape_seq.underline_seq
  | Blink -> Escape_seq.blink_seq
  | Reverse -> Escape_seq.reverse_seq
  | Cross_out -> Escape_seq.cross_out_seq
  | Overline -> Escape_seq.overline_seq
  | Foreground color ->
      Escape_seq.foreground_seq ^ ";" ^ Color.to_escape_seq ~mode:`fg color
  | Background color ->
      Escape_seq.background_seq ^ ";" ^ Color.to_escape_seq ~mode:`bg color

let format fmt seqs line =
  let seqs = List.map to_string seqs |> String.concat ";" in
  if seqs = "" then Format.fprintf fmt "%s" line
  else
    Format.fprintf fmt "%s%sm%s%s%sm" Escape_seq.csi seqs line Escape_seq.csi
      Escape_seq.reset_seq
