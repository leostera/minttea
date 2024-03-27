module Command = Minttea.Command
module Event = Minttea.Event
module Input = Text_input

type t = {
  elements : (bool * string) list;
  shown : int list option;
  cursor : int;
  max_height : int;
  cursor_string : string;
  style_selected : Spices.style;
  style_unselected : Spices.style;
  predicate : int -> string -> bool;
}

let default_cursor = ">"

let make (elements : string list) ?(cursor = default_cursor)
    ?(style_selected = Spices.default) ?(style_unselected = Spices.default)
    ?(max_height = 10) () =
  {
    elements = List.map (fun e -> (false, e)) elements;
    cursor = 0;
    shown = None;
    cursor_string = cursor;
    predicate = (fun _ _ -> true);
    max_height;
    style_selected;
    style_unselected;
  }

let rec last = function
  | [] -> raise Not_found
  | [ e ] -> e
  | _ :: rest -> last rest

let show_pred model predicate =
  let indices =
    (* list of shown indices *)
    model.elements
    |> List.mapi (fun idx (_, e) -> (idx, predicate idx e))
    |> List.filter (fun (_, selected) -> selected)
    |> List.map fst
  in
  let cursor =
    (* set the cursor to the closest visible element *)
    if List.length indices = 0 then 0
    else
      match List.find (( <= ) model.cursor) indices with
      | exception Not_found -> last indices
      | idx -> idx
  in
  { model with cursor; predicate; shown = Some indices }

let show_string_contains model s =
  (* return true if the filter matches the element *)
  let match_filter filter _ element =
    match Str.search_forward (Str.regexp filter) element 0 with
    | exception Not_found -> false
    | _ -> true
  in
  show_pred model (match_filter s)

let show_all model = { model with shown = None }

(* move the cursor in the list of visible elements, eventually wrapping *)
let prev_visible cur shown =
  if shown = [] then 0
  else
    let last = last shown in
    let rec loop cur shown =
      match shown with
      | a :: _ when a < cur -> a
      | _ :: rest -> loop cur rest
      | [] -> last
    in
    loop cur (List.rev shown)

(* move the cursor in the list of visible elements, eventually wrapping *)
let next_visible cur shown =
  let first = match shown with a :: _ -> a | [] -> 0 in
  let rec loop cur shown =
    match shown with
    | a :: _ when a > cur -> a
    | _ :: rest -> loop cur rest
    | [] -> first
  in
  loop cur shown

let update event (model : t) =
  match event with
  | Event.KeyDown ((Key "s" | Space), _) ->
      (* select current element *)
      {
        model with
        elements =
          List.mapi
            (fun idx (s, e) ->
              if idx = model.cursor then (not s, e) else (s, e))
            model.elements;
      }
  | Event.KeyDown ((Up | Key "k"), _) ->
      let len = List.length model.elements in
      if len = 0 then model
      else
        {
          model with
          cursor =
            (match model.shown with
            | None -> (model.cursor + len - 1) mod len
            | Some shown -> prev_visible model.cursor shown);
        }
  | Event.KeyDown ((Down | Key "j"), _) ->
      let len = List.length model.elements in
      if len = 0 then model
      else
        {
          model with
          cursor =
            (match model.shown with
            | None -> (model.cursor + 1) mod len
            | Some shown -> next_visible model.cursor shown);
        }
  | Event.KeyDown ((Left | Key "h"), _) ->
      (* previous page, not wrapping *)
      { model with cursor = max (model.cursor - model.max_height) 0 }
  | Event.KeyDown ((Right | Key "l"), _) ->
      (* next page, not wrapping *)
      {
        model with
        cursor =
          min
            (model.cursor + model.max_height)
            (max 0 (List.length model.elements - 1));
      }
  | _ -> model

(* drop the first n elements of the list *)
let rec drop n lst =
  if n = 0 then lst
  else match lst with _ :: rest -> drop (n - 1) rest | [] -> []

(* keep the first n elements of the list *)
let take n lst =
  let rec aux lst n acc =
    if n = 0 then List.rev acc
    else
      match lst with
      | x :: rest -> aux rest (n - 1) (x :: acc)
      | [] -> List.rev acc
  in
  aux lst n []

(* only keep visible items, counting on the order of shown and elems *)
let pick_visible shown elems =
  let rec loop shown elems acc =
    match (shown, elems) with
    | [], _ -> List.rev acc
    | _, [] -> List.rev acc
    | idxa :: shown, (idxb, s, e) :: elems when idxa = idxb ->
        loop shown elems ((idxa, s, e) :: acc)
    | shown, _ :: elems -> loop shown elems acc
  in
  loop shown elems []

let visible_cursor model =
  match model.shown with
  | None -> model.cursor
  | Some shown ->
      let rec loop rest acc =
        match rest with
        | [] -> acc
        | idx :: _ when idx = model.cursor -> acc
        | _ :: rest -> loop rest (acc + 1)
      in
      loop shown 0

let view (model : t) =
  let npages =
    (match model.shown with
    | Some shown -> List.length shown / model.max_height
    | None -> List.length model.elements / model.max_height)
    + 1
  in
  let page = 1 + (visible_cursor model / model.max_height) in
  let elems =
    model.elements
    |> List.mapi (fun idx (selected, element) -> (idx, selected, element))
    |> (match model.shown with
       | None -> fun x -> x
       | Some shown -> pick_visible shown)
    |> drop ((page - 1) * model.max_height)
    |> take model.max_height
  in

  (* Represent rows with cursor, index and selection marker *)
  let format_row (idx, selected, element) =
    let cursor =
      if model.cursor = idx then model.cursor_string
      else String.make (String.length model.cursor_string) ' '
    in
    let bullet =
      if selected then Format.sprintf "[%2d]" (idx + 1)
      else Format.sprintf " %2d " (idx + 1)
    in
    let style =
      if selected then model.style_selected else model.style_unselected
    in
    Spices.build style "%s %s %s" cursor bullet element
  in

  let rows = List.map format_row elems in
  let lst =
    if List.length rows < model.max_height then
      String.concat "\n"
        (rows @ List.init (model.max_height - List.length rows) (fun _ -> ""))
    else String.concat "\n" rows
  in
  let page_indicator =
    String.concat " "
    @@ List.init npages (fun idx -> if idx + 1 = page then "*" else ".")
  in
  lst ^ "\n\n" ^ page_indicator

(* Append more elements at the end of the list *)
let append model elements =
  let model =
    {
      model with
      elements = model.elements @ List.map (fun e -> (false, e)) elements;
    }
  in
  (* reapply the predicate with currently active *)
  match model.shown with
  | None -> model
  | Some _ -> show_pred model model.predicate

let filter model predicate =
  let model =
    {
      model with
      elements = List.filteri (fun idx (_, e) -> predicate idx e) model.elements;
    }
  in
  (* reapply the filter predicate with currently active *)
  match model.shown with
  | None -> model
  | Some _ -> show_pred model model.predicate

(* Return the selected elements of the list *)
let get_selection model =
  model.elements |> List.filter (fun (selected, _) -> selected) |> List.map snd
