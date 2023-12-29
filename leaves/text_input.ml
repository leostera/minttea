type t = {
  value : string;
  pos : int;
  cursor : Cursor.t;
  prompt : string;
  text_style : Spices.style;
}

(* Utils *)
open struct
  let cursor_at_beginning t = t.pos = 0
  let cursor_at_end t = t.pos = String.length t.value

  (** Cursor will be at the start of the right part. *)
  let split s ~at =
    let left = String.sub s 0 at in
    let right = String.sub s at (String.length s - at) in
    (left, right)
end

let default_prompt = "> "
let default_text_style = Spices.default
let default_cursor () = Cursor.make ()

let make value ?(text_style = default_text_style) ?(cursor = default_cursor ())
    ?(prompt = default_prompt) () =
  let v, pos =
    match value with "" -> ("", 0) | v -> (value, String.length v)
  in
  { value = v; pos; text_style; cursor; prompt }

let empty () = make "" ()

let view t =
  let text_style = Spices.(t.text_style |> build) in

  let result = ref "" in
  for i = 0 to String.length t.value - 1 do
    let s = String.make 1 @@ t.value.[i] in
    let txt =
      if i = t.pos then Cursor.view t.cursor ~text_style:t.text_style s
      else text_style "%s" s
    in
    result := !result ^ txt
  done;

  if cursor_at_end t then
    result := !result ^ Cursor.view t.cursor ~text_style:t.text_style " ";

  text_style "%s" t.prompt ^ !result

let current_text t = t.value

let write t s =
  match t with
  | t when cursor_at_beginning t ->
      { t with value = s ^ t.value; pos = t.pos + String.length s }
  | t when cursor_at_end t ->
      { t with value = t.value ^ s; pos = t.pos + String.length s }
  | _ ->
      let left, right = split t.value ~at:t.pos in
      let new_value = left ^ s ^ right in
      { t with value = new_value; pos = t.pos + String.length s }

let space t = write t " "

let backspace t =
  if t.pos = 0 then t
  else
    let left, right = split t.value ~at:t.pos in
    (* drop the last char from the left part *)
    let left = String.sub left 0 (t.pos - 1) in
    let new_value = left ^ right in
    { t with value = new_value; pos = t.pos - 1 }

let move_cursor t action =
  let pos =
    match action with
    | `Character_backward when t.pos > 0 -> t.pos - 1
    | `Character_forward when t.pos < String.length t.value -> t.pos + 1
    | `Jump_to_beginning -> 0
    | `Jump_to_end -> String.length t.value
    | _ -> t.pos
  in
  { t with pos }

let character_backward t = move_cursor t `Character_backward
let character_forward t = move_cursor t `Character_forward
let jump_to_beginning t = move_cursor t `Jump_to_beginning
let jump_to_end t = move_cursor t `Jump_to_end

let update t (e : Minttea.Event.t) =
  match e with
  | KeyDown k ->
      {
        (match k with
        | Backspace -> backspace t
        | Key s -> write t s
        | Left -> character_backward t
        | Right -> character_forward t
        | Space -> space t
        | Up -> jump_to_beginning t
        | Down -> jump_to_end t
        | Escape | Enter -> t)
        with
        cursor = Cursor.focus t.cursor;
      }
  | _ -> { t with cursor = Cursor.update t.cursor e }

let set_text value t = { t with value } |> jump_to_end
