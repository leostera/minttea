type style = Dots | Numerals

type t = {
  style : style;
  page : int;
  per_page : int;
  total_pages : int;
  active_dot : string;
  inactive_dot : string;
  numerals_format : (int -> int -> string, unit, string) format;
  text_style : Spices.style;
}

let set_total_pages t items =
  if items < 1 then (t, t.total_pages)
  else
    let n = items / t.per_page in
    let n = if items mod t.per_page > 0 then n + 1 else n in
    let new_t = { t with total_pages = n } in
    (new_t, n)

let get_slice_bounds t length =
  let start = t.page * t.per_page in
  let end_pos = min ((t.page * t.per_page) + t.per_page) length in
  (start, end_pos)

let items_on_page t total_items =
  if total_items < 1 then 0
  else
    let start, end_pos = get_slice_bounds t total_items in
    end_pos - start

let on_last_page t = t.page = t.total_pages - 1
let on_first_page t = t.page = 0
let prev_page t = { t with page = max (t.page - 1) 0 }
let next_page t = if on_last_page t then t else { t with page = t.page + 1 }

let make ?(style = Numerals) ?(page = 0) ?(per_page = 1) ?(total_pages = 1)
    ?(active_dot = "•") ?(inactive_dot = "○")
    ?(numerals_format : (int -> int -> string, unit, string) format = "%d/%d")
    ?(text_style = Spices.default) () =
  {
    style;
    page;
    per_page;
    total_pages;
    active_dot;
    inactive_dot;
    numerals_format;
    text_style;
  }

let update t (e : Minttea.Event.t) =
  match e with
  | KeyDown ((Key "h" | Left), _) -> prev_page t
  | KeyDown ((Key "l" | Right), _) -> next_page t
  | _ -> t

let dots_view t text_style =
  let text_style = text_style |> Spices.build in
  let result = ref "" in
  for i = 0 to t.total_pages - 1 do
    let dot =
      if i == t.page then text_style "%s" t.active_dot
      else text_style "%s" t.inactive_dot
    in
    result := !result ^ dot
  done;
  !result

let numerals_view t text_style =
  let text_style = text_style |> Spices.build in
  let txt = Format.sprintf t.numerals_format (t.page + 1) t.total_pages in
  text_style "%s" txt

let view t =
  match t.style with
  | Dots -> dots_view t t.text_style
  | Numerals -> numerals_view t t.text_style
