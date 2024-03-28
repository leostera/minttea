type t = {
  value : string;
  placeholder : string;
  prompt : string;
  last_action : float;
  (* cursor *)
  cursor : Cursor.t;
  pos : int;
  (* styles *)
  text_style : Spices.style;
  placeholder_style : Spices.style;
}

(* Utils *)
open struct
  let cursor_at_beginning t = t.pos = 0
  let cursor_at_end t = t.pos = String.length t.value
  let now_secs () = Ptime_clock.now () |> Ptime.to_float_s

  (** Cursor will be at the start of the right part. *)
  let split s ~at =
    let left = String.sub s 0 at in
    let right = String.sub s at (String.length s - at) in
    (left, right)
end

let default_prompt = "> "
let default_placeholder = ""
let default_text_style = Spices.default
let default_placeholder_style = Spices.default |> Spices.faint true
let default_cursor () = Cursor.make ()
let resume_blink_after = 0.25

let make value ?(text_style = default_text_style)
    ?(placeholder_style = default_placeholder_style)
    ?(cursor = default_cursor ()) ?(placeholder = default_placeholder)
    ?(prompt = default_prompt) () =
  let value, pos =
    if String.length value = 0 then ("", 0) else (value, String.length value)
  in
  {
    value;
    placeholder;
    pos;
    text_style;
    placeholder_style;
    cursor;
    prompt;
    last_action = now_secs ();
  }

let empty () = make "" ()

let placeholder_view t =
  let placeholder_style = Spices.(t.placeholder_style |> build) in
  let text_style = Spices.(t.text_style |> build) in

  let result = ref "" in

  for i = 0 to String.length t.placeholder - 1 do
    let s = String.make 1 @@ t.placeholder.[i] in
    let txt =
      if i = 0 then Cursor.view t.cursor ~text_style:t.placeholder_style s
      else placeholder_style "%s" s
    in
    result := !result ^ txt
  done;

  text_style "%s" t.prompt ^ !result

let view t =
  if String.length t.value = 0 then placeholder_view t
  else
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
  | KeyDown (key, modifier) ->
      let s =
        match (key, modifier) with
        (* Movement *)
        | Up, _ -> jump_to_beginning t
        | Key s, Ctrl when s = "a" -> jump_to_beginning t

        | Down, _ -> jump_to_end t
        | Key s, Ctrl when s = "e" -> jump_to_end t

        | Left, _ -> character_backward t
        | Key s, Ctrl when s = "b" -> character_backward t

        | Right, _ -> character_forward t
        | Key s, Ctrl when s = "f" -> character_forward t

        (* Typing *)
        | Backspace, _ -> backspace t
        | Key s, _ -> write t s
        | Space, _ -> space t
        | Escape, _ | Enter, _ -> t
      in

      { s with cursor = Cursor.focus t.cursor; last_action = now_secs () }
  | _ ->
      let time_since_last_action = now_secs () -. t.last_action in

      let updated_cursor =
        if time_since_last_action <= resume_blink_after then
          Cursor.enable_blink t.cursor
        else t.cursor
      in
      { t with cursor = Cursor.update updated_cursor e }

let set_text value t = { t with value } |> jump_to_end
