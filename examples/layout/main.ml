open Minttea

(* Type definitions and initial model *)
type model = {
  choices : (string * [ `selected | `unselected ]) list;
  cursor : int;
}

let initial_model =
  {
    cursor = 0;
    choices =
      [
        ("Buy empanadas 🥟", `unselected);
        ("Buy carrots 🥕", `unselected);
        ("Buy cupcakes 🧁", `unselected);
      ];
  }

let init _model = Command.Noop

(* Update function with pattern matching for events *)
let update event model =
  match event with
  | Event.KeyDown ((Key "q" | Escape), _modifier) -> (model, Command.Quit)
  | Event.KeyDown ((Up | Key "k"), _modifier) ->
      let cursor =
        if model.cursor = 0 then List.length model.choices - 1
        else model.cursor - 1
      in
      ({ model with cursor }, Command.Noop)
  | Event.KeyDown ((Down | Key "j"), _modifier) ->
      let cursor =
        if model.cursor = List.length model.choices - 1 then 0
        else model.cursor + 1
      in
      ({ model with cursor }, Command.Noop)
  | Event.KeyDown ((Enter | Space), _modifier) ->
      let toggle status =
        match status with `selected -> `unselected | `unselected -> `selected
      in
      let choices =
        List.mapi
          (fun idx (name, status) ->
            let status = if idx = model.cursor then toggle status else status in
            (name, status))
          model.choices
      in
      ({ model with choices }, Command.Noop)
  | _ -> (model, Command.Noop)

let view model =
  let open Spices in
  (* padding and margin using the Spices module *)
  let checkbox_padded_style = default |> padding_left 1 |> padding_right 1 in
  let list_margin_style = default |> margin_top 2 |> margin_bottom 2 in

  (* apply the padding and margin styling *)
  let apply_checkbox_style = build checkbox_padded_style in
  let apply_list_style = build list_margin_style in

  let options =
    model.choices
    |> List.mapi (fun idx (name, checked) ->
           let cursor = if model.cursor = idx then ">" else " " in
           let checked_symbol = if checked = `selected then "x" else " " in
           let checkbox = apply_checkbox_style "[%s]" checked_symbol in
           Format.sprintf "%s %s %s" cursor checkbox name)
    |> String.concat "\n"
  in
  apply_list_style
    {|
What should we buy at the market?

%s

Press q to quit.
    |}
    options

(* Application start *)
let app = Minttea.app ~init ~update ~view ()
let () = Minttea.start app ~initial_model
