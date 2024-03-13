let remove_color_sequences s =
  let regex = Str.regexp "\027\\[[0-9;]*m" in
  Str.global_replace regex "" s

let rec create_string n s =
  if n = 0 then ""
  else
    let str = create_string (n - 1) s in
    str ^ s

let utf8_len str =
  Uuseg_string.fold_utf_8 `Grapheme_cluster (fun x _ -> x + 1) 0 str

let get_width text =
  List.fold_left
    (fun acc line ->
      let len = utf8_len (remove_color_sequences line) in
      if acc < len then len else acc)
    0
    (Str.split (Str.regexp "\r?\n") text)

let get_height text = List.length (Str.split (Str.regexp "\r?\n") text)

type t = {
  top : string option;
  left : string option;
  bottom : string option;
  right : string option;
  top_left : string option;
  top_right : string option;
  bottom_left : string option;
  bottom_right : string option;
  middle_left : string option;
  middle_right : string option;
  middle : string option;
  middle_top : string option;
  middle_bottom : string option;
}

let build_border (border : t) text =
  let top = Option.value border.top ~default:"" in
  let left = Option.value border.left ~default:"" in
  let bottom = Option.value border.bottom ~default:"" in
  let right = Option.value border.right ~default:"" in
  let top_left = Option.value border.top_left ~default:"" in
  let top_right = Option.value border.top_right ~default:"" in
  let bottom_left = Option.value border.bottom_left ~default:"" in
  let bottom_right = Option.value border.bottom_right ~default:"" in

  let width = get_width text in
  let top_border = top_left ^ create_string width top ^ top_right in
  let bottom_border = bottom_left ^ create_string width bottom ^ bottom_right in
  let l = Str.split (Str.regexp "\r?\n") text in
  let l =
    List.map
      (fun x ->
        let x_w = get_width x in
        let extra_right_spacing = create_string (width - x_w) " " in
        let res = left ^ x ^ extra_right_spacing ^ right in
        res)
      l
  in
  let text = String.concat "\n" l in
  Format.sprintf "%s\n%s\n%s" top_border text bottom_border

let normal_border =
  {
    top = Some "─";
    bottom = Some "─";
    left = Some "│";
    right = Some "│";
    top_left = Some "┌";
    top_right = Some "┐";
    bottom_left = Some "└";
    bottom_right = Some "┘";
    middle_left = Some "├";
    middle_right = Some "┤";
    middle = Some "┼";
    middle_top = Some "┬";
    middle_bottom = Some "┴";
  }

let rounded_border =
  {
    top = Some "─";
    bottom = Some "─";
    left = Some "│";
    right = Some "│";
    top_left = Some "╭";
    top_right = Some "╮";
    bottom_left = Some "╰";
    bottom_right = Some "╯";
    middle_left = Some "├";
    middle_right = Some "┤";
    middle = Some "┼";
    middle_top = Some "┬";
    middle_bottom = Some "┴";
  }

let block_border =
  {
    top = Some "█";
    bottom = Some "█";
    left = Some "█";
    right = Some "█";
    top_left = Some "█";
    top_right = Some "█";
    bottom_left = Some "█";
    bottom_right = Some "█";
    middle_left = None;
    middle_right = None;
    middle = None;
    middle_top = None;
    middle_bottom = None;
  }

let outer_half_block_border =
  {
    top = Some "▀";
    bottom = Some "▄";
    left = Some "▌";
    right = Some "▐";
    top_left = Some "▛";
    top_right = Some "▜";
    bottom_left = Some "▙";
    bottom_right = Some "▟";
    middle_left = None;
    middle_right = None;
    middle = None;
    middle_top = None;
    middle_bottom = None;
  }

let inner_half_block_border =
  {
    top = Some "▄";
    bottom = Some "▀";
    left = Some "▐";
    right = Some "▌";
    top_left = Some "▗";
    top_right = Some "▖";
    bottom_left = Some "▝";
    bottom_right = Some "▘";
    middle_left = None;
    middle_right = None;
    middle = None;
    middle_top = None;
    middle_bottom = None;
  }

let thick_border =
  {
    top = Some "━";
    bottom = Some "━";
    left = Some "┃";
    right = Some "┃";
    top_left = Some "┏";
    top_right = Some "┓";
    bottom_left = Some "┗";
    bottom_right = Some "┛";
    middle_left = Some "┣";
    middle_right = Some "┫";
    middle = Some "╋";
    middle_top = Some "┳";
    middle_bottom = Some "┻";
  }

let double_border =
  {
    top = Some "═";
    bottom = Some "═";
    left = Some "║";
    right = Some "║";
    top_left = Some "╔";
    top_right = Some "╗";
    bottom_left = Some "╚";
    bottom_right = Some "╝";
    middle_left = Some "╠";
    middle_right = Some "╣";
    middle = Some "╬";
    middle_top = Some "╦";
    middle_bottom = Some "╩";
  }

let hidden_border =
  {
    top = Some " ";
    bottom = Some " ";
    left = Some " ";
    right = Some " ";
    top_left = Some " ";
    top_right = Some " ";
    bottom_left = Some " ";
    bottom_right = Some " ";
    middle_left = Some " ";
    middle_right = Some " ";
    middle = Some " ";
    middle_top = Some " ";
    middle_bottom = Some " ";
  }

type border_type =
  | Normal
  | Rounded
  | Block
  | Outer_half_block
  | Inner_half_block
  | Thick
  | Double
  | Hidden

let get_border = function
  | Normal -> normal_border
  | Rounded -> rounded_border
  | Block -> block_border
  | Outer_half_block -> outer_half_block_border
  | Inner_half_block -> inner_half_block_border
  | Thick -> thick_border
  | Double -> double_border
  | Hidden -> hidden_border
