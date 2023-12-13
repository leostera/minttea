[@@@warning "-69"]

type color = Terminal.Color.t

let color ?(profile = Terminal.Profile.default) raw =
  let color = Terminal.Color.make raw in
  let color = Terminal.Profile.convert profile color in
  color

type style = {
  background : color option;
  blink : bool;
  bold : bool;
  faint : bool;
  foreground : color option;
  height : int option;
  italic : bool;
  margin_bottom : int;
  margin_left : int;
  margin_right : int;
  margin_top : int;
  max_height : int option;
  max_width : int option;
  padding_bottom : int;
  padding_left : int;
  padding_right : int;
  padding_top : int;
  reverse : bool;
  strikethrough : bool;
  underline : bool;
  width : int option;
}

let default =
  {
    background = None;
    blink = false;
    bold = false;
    faint = false;
    foreground = None;
    height = None;
    italic = false;
    margin_bottom = 0;
    margin_left = 0;
    margin_right = 0;
    margin_top = 0;
    max_height = None;
    max_width = None;
    padding_bottom = 0;
    padding_left = 0;
    padding_right = 0;
    padding_top = 0;
    reverse = false;
    strikethrough = false;
    underline = false;
    width = None;
  }

let bg x t = { t with background = Some x }
let blink x t = { t with blink = x }
let bold x t = { t with bold = x }
let faint x t = { t with faint = x }
let fg x t = { t with foreground = Some x }
let height x t = { t with height = Some x }
let italic x t = { t with italic = x }
let margin_bottom x t = { t with margin_bottom = x }
let margin_left x t = { t with margin_left = x }
let margin_right x t = { t with margin_right = x }
let margin_top x t = { t with margin_top = x }
let max_height x t = { t with max_height = Some x }
let max_width x t = { t with max_width = Some x }
let padding_bottom x t = { t with padding_bottom = x }
let padding_left x t = { t with padding_left = x }
let padding_right x t = { t with padding_right = x }
let padding_top x t = { t with padding_top = x }
let reverse x t = { t with reverse = x }
let strikethrough x t = { t with strikethrough = x }
let underline x t = { t with underline = x }
let width x t = { t with width = x }

let do_render t str =
  (* build formatting sequenc *)
  let format =
    Formatter.
      [
        (if t.blink then [ Blink ] else []);
        (if t.bold then [ Bold ] else []);
        (if t.faint then [ Faint ] else []);
        (if t.italic then [ Italic ] else []);
        (if t.reverse then [ Reverse ] else []);
        (if t.strikethrough then [ Cross_out ] else []);
        (if t.underline then [ Underline ] else []);
        (match t.foreground with
        | Some color when Terminal.Color.is_no_color color -> []
        | Some color -> [ Foreground color ]
        | None -> []);
        (match t.background with
        | Some color when Terminal.Color.is_no_color color -> []
        | Some color -> [ Background color ]
        | None -> []);
      ]
    |> List.flatten
  in

  (* render core text *)
  let str =
    let buf = Buffer.create (String.length str) in
    let fmt = Format.formatter_of_buffer buf in

    let lines = String.split_on_char '\n' str in
    Format.pp_print_list
      ~pp_sep:(fun fmt _ -> Format.fprintf fmt "\r\n")
      (fun fmt line -> Formatter.format fmt format line)
      fmt lines;
    Format.fprintf fmt "%!";
    Buffer.contents buf
  in

  (* handle padding *)
  let str = ref str in
  if t.padding_left > 0 then str := String.make t.padding_left ' ' ^ !str;
  if t.padding_right > 0 then str := !str ^ String.make t.padding_right ' ';
  if t.padding_top > 0 then str := String.make t.padding_top '\n' ^ !str;
  if t.padding_bottom > 0 then str := !str ^ String.make t.padding_bottom '\n';

  (match t.max_height with
  | Some max_height when max_height > 0 ->
      let lines = String.split_on_char '\n' !str in
      let lines = lines |> List.to_seq |> Seq.take max_height |> List.of_seq in
      str := String.concat "\n" lines
  | _ -> ());

  !str

let build t fmt =
  let buf = Buffer.create 128 in
  Format.kfprintf
    (fun _ -> do_render t (Buffer.contents buf))
    (Format.formatter_of_buffer buf)
    (fmt ^^ "%!")
