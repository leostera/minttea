type column = { title : string; width : int }
type row = string list

type styles = {
  cursor : Spices.style;
  header : Spices.style;
  cell : Spices.style;
}

let default_styles =
  {
    cursor =
      Spices.(
        default |> bold true |> fg (color "#FFFFFF") |> bg (color "#053d37"));
    header =
      Spices.(
        default |> bold true
        |> fg (color "#FFFFFF")
        |> padding_right 1 |> padding_left 1);
    cell = Spices.(default |> padding_right 1 |> padding_left 1);
  }

type t = {
  columns : column array;
  rows : row list;
  styles : styles;
  cursor : int;
  start_of_frame : int;
  height_of_frame : int;
}

type action = Up | Down | PageUp | PageDown

let update t (e : action) =
  let go_up t steps =
    let cursor = max (t.cursor - steps) 0 in
    let start_of_frame =
      if cursor < t.start_of_frame then cursor else t.start_of_frame
    in
    { t with cursor; start_of_frame }
  in
  let go_down t steps =
    let cursor = min (t.cursor + steps) (List.length t.rows - 1) in
    let start_of_frame =
      if cursor > t.start_of_frame + t.height_of_frame - 1 then
        cursor - t.height_of_frame + 1
      else t.start_of_frame
    in
    { t with cursor; start_of_frame }
  in
  match e with
  | PageUp -> go_up t t.height_of_frame
  | PageDown -> go_down t t.height_of_frame
  | Up -> go_up t 1
  | Down -> go_down t 1

let truncate_or_pad_unicode ~width str =
  (* Truncates a Unicode string to a target width with an ellipsis
     or pads it with spaces on the right. *)
  let uuseg_string_length s =
    (* TODO(@sabine): we probably don't want the uuseg dependency
       or move this somewhere where it actually belongs. Also for uuseg_string_sub,
       we need to write actually good code. *)
    Uuseg_string.fold_utf_8 `Grapheme_cluster (fun len _ -> len + 1) 0 s
  in
  let uuseg_string_sub s start n =
    let inner s start n acc =
      Uuseg_string.fold_utf_8 `Grapheme_cluster
        (fun (pos, collected, s) c ->
          if pos >= start && collected < n then (pos + 1, collected + 1, s ^ c)
          else (pos + 1, collected, s))
        acc s
    in
    let _, _, r = inner s start n (0, 0, "") in
    r
  in
  let len = uuseg_string_length str in
  if len > width then uuseg_string_sub str 0 (width - 1) ^ "…"
  else str ^ String.make (width - len) ' '

let view t =
  let column_titles =
    let render_title col =
      truncate_or_pad_unicode ~width:col.width col.title
      |> (t.styles.header |> Spices.build) "%s"
    in
    t.columns |> Array.to_list |> List.map render_title |> String.concat ""
  in
  let rows =
    let get_visible_rows t =
      t.rows |> List.to_seq |> Seq.drop t.start_of_frame
      |> Seq.take t.height_of_frame |> List.of_seq
    in
    let render_row i row =
      let render_cell i item =
        truncate_or_pad_unicode ~width:t.columns.(i).width item
        |> (t.styles.cell |> Spices.build) "%s"
      in
      let row = row |> List.mapi render_cell |> String.concat "" in
      if i = t.cursor - t.start_of_frame then
        (t.styles.cursor |> Spices.build) "%s" row
      else row
    in
    t |> get_visible_rows |> List.mapi render_row |> String.concat "\n"
  in
  Printf.sprintf {|%s

%s|} column_titles rows
