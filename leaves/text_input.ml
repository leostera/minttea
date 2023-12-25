type t = {
  value : string;
  cursor : int;
  text_style : Spices.style;
  cursor_style : Spices.style;
}

(* utils *)
open struct
  (** Cursor will be at the start of the right part. *)
  let split s ~at =
    let left = String.sub s 0 at in
    let right = String.sub s at (String.length s - at) in
    (left, right)

  let cursor_at_beginning t = t.cursor = 0
  let cursor_at_end t = t.cursor = String.length t.value
end

(* colors *)
open struct
  let white = Spices.color "#FFFFFF"
  let black = Spices.color "#000000"
end

let make ~value ?(text_style = Spices.(default))
    ?(cursor_style = Spices.(default |> bg white |> fg black)) () =
  let v, c = match value with "" -> ("", 0) | v -> (value, String.length v) in
  { value = v; cursor = c; text_style; cursor_style }

let empty () = make ~value:"" ()

let view t =
  let text_style = Spices.(t.text_style |> build) in
  let cursor_style = Spices.(t.cursor_style |> build) in

  let result = ref "" in
  for i = 0 to String.length t.value - 1 do
    let s = String.make 1 @@ t.value.[i] in
    let style = if i = t.cursor then cursor_style else text_style in

    result := !result ^ style "%s" s
  done;

  if cursor_at_end t then result := !result ^ cursor_style "%s" " ";

  !result

let set_cursor t cursor = { t with cursor }
let set_value t value = { t with value }

let write t s =
  match t with
  | t when cursor_at_beginning t ->
      { t with value = s ^ t.value; cursor = t.cursor + String.length s }
  | t when cursor_at_end t ->
      { t with value = t.value ^ s; cursor = t.cursor + String.length s }
  | _ ->
      let left, right = split t.value ~at:t.cursor in
      let new_value = left ^ s ^ right in
      { t with value = new_value; cursor = t.cursor + String.length s }

let space t = write t " "

let backspace t =
  if t.cursor = 0 then t
  else
    let left, right = split t.value ~at:t.cursor in
    (* drop the last char from the left part *)
    let left = String.sub left 0 (t.cursor - 1) in
    let new_value = left ^ right in
    { t with value = new_value; cursor = t.cursor - 1 }

let move_cursor t action =
  let new_cursor =
    match action with
    | `Character_backward when t.cursor > 0 -> t.cursor - 1
    | `Character_forward when t.cursor < String.length t.value -> t.cursor + 1
    | _ -> t.cursor
  in
  { t with cursor = new_cursor }

let character_backward t = move_cursor t `Character_backward
let character_forward t = move_cursor t `Character_forward

let update t (key : Minttea.Event.key) =
  match key with
  | Left -> character_backward t
  | Right -> character_forward t
  | Backspace -> backspace t
  | Key s -> write t s
  | Space -> space t
  | Up | Down | Escape | Enter -> t
