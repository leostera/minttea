open Minttea
module Input = Leaves.Text_input
module FList = Leaves.Filtered_list

type model = {
  elements : FList.t;
  choices : string list option;
  edit_filter : bool;
  filter_input : Input.t;
}

let initial_model =
  {
    (* Choices is to Some list at the end of the program *)
    choices = None;
    (* A Text_input is used to enter a substring used for filtering *)
    filter_input = Input.make "" ~prompt:"/" ();
    edit_filter = false;
    elements =
      FList.make
        [
          "brain 🧠";
          "bread 🍞";
          "butter 🧈";
          "cake 🍰";
          "carrots 🥕";
          "chocolate 🍫";
          "cupcakes 🧁";
          "empanadas 🥟";
          "hamburgers 🍔";
          "ice cream 🍦";
          "milk 🥛";
          "pizza 🍕";
          "strawberries 🍓";
          "waffles 🧇";
          "yogurt 🥛";
        ]
        ~style_selected:Spices.(default |> bold true)
        ();
  }

let init _model = Command.Noop

let update event model : model * Command.t =
  if model.edit_filter then
    match event with
    (* validate the search and go back to navigating the list *)
    | Event.KeyDown (Enter, _modifier) ->
        let elements =
          FList.show_string_contains model.elements
            (Input.current_text model.filter_input)
        in
        ({ model with elements; edit_filter = false }, Command.Noop)
    (* cancel the search and go back to navigating the list *)
    | Event.KeyDown (Escape, _modifier) ->
        let elements = FList.show_all model.elements in
        ( {
            model with
            elements;
            edit_filter = false;
            filter_input = Input.set_text "" model.filter_input;
          },
          Command.Noop )
    (* everything else is passed to underlying component *)
    | _ ->
        let filter_input = Input.update model.filter_input event in
        (* incremental search: update the search on all event *)
        let elements =
          FList.show_string_contains model.elements
            (Input.current_text filter_input)
        in
        ({ model with filter_input; elements }, Command.Noop)
  else
    match event with
    (* Validate the selection, print it and quit *)
    | Event.KeyDown (Enter, _modifier) ->
        let elements = FList.get_selection model.elements in
        ({ model with choices = Some elements }, Command.Quit)
    (* Quit right away *)
    | Event.KeyDown ((Key "q" | Escape), _modifier) -> (model, Command.Quit)
    (* Open the search Text_input *)
    | Event.KeyDown (Key "/", _modifier) ->
        ({ model with edit_filter = true }, Command.Noop)
    (* Delegate the rest to the list *)
    | _ ->
        let elements = FList.update event model.elements in
        ({ model with elements }, Command.Noop)

let view model =
  match model.choices with
  (* ready to leave *)
  | Some elements -> String.concat "\n" elements
  (* normal running *)
  | None ->
      let help_msg =
        if model.edit_filter then "Esc: cancel filter, Enter: validate filter"
        else "q: quit, /: search, j/k: up/down, space: select, enter: validate."
      in
      Format.sprintf {|Pick your favorite food:

%s
%s

%s|}
        (FList.view model.elements)
        (if model.edit_filter then Input.view model.filter_input else "")
        help_msg

let app = Minttea.app ~init ~update ~view ()
let () = Minttea.start app ~initial_model
