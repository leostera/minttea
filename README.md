# Mint Tea
<img src="https://github.com/dmmulroy/minttea/assets/2755722/e9e96e73-1f7f-4b8f-8bb1-445308dfe8bd" alt="Mint Tea Logo" width="400"/>

A fun, functional, and stateful way to build terminal apps in OCaml heavily
inspired by [BubbleTea][bubbletea]. Mint Tea is built on Riot and uses The Elm
Architecture.

[bubbletea]: https://github.com/charmbracelet/bubbletea

<img src="https://github.com/leostera/minttea/raw/main/examples/views/demo.gif"/>

## Tutorial

Mint Tea is based on the functional paradigm of [The Elm
Architecture][tea], which works great with OCaml. It's a delightful
way to build applications.

This tutorial assumes you have a working knowledge of OCaml.

[tea]: https://guide.elm-lang.org/architecture/

### Getting Started

For this tutorial, we're making a shopping list.

We'll start by defining our `dune-project` file:

```dune
(lang dune 3.12)
```

And a `dune` file for our executable:

```dune
(executable
  (name shop)
  (libraries minttea))
```

Then we need to pin the `minttea` package to the github source:

```
$ opam install minttea
```

Opam will do some work installing `minttea` from the github source.

We can run `dune build` to validate the package has been installed correctly.

Great, now we can create a new `shop.ml` file and start by opening up `Minttea`:

```ocaml
open Minttea
```

Mint Tea programs are composed of a **model** that describes the application
state, and three simple functions:

* `init`, a function that returns the initial commands for the application to
  run
* `update` a function that handles incoming events and updates the model
  accordingly
* `view`, a function that renders the UI based on the data in the model

### The Model

We'll start by creating a type for our model. This type can be anything you
want, just remember that it must hold your entire application state.

<!-- $MDX file=./examples/basic/main.ml,part=model -->
```ocaml
type model = {
  (* the choices that will be used and whether they are selected or unselected *)
  choices : (string * [ `selected | `unselected ]) list;
  (* the current position of the cursor *)
  cursor : int;
}
```

### Initialization

Next up, we'll create our `initial_model` function. If creating this initial
state is too expensive, we could make it a function too, so we can call it when
we need to start the application.

<!-- $MDX file=./examples/basic/main.ml,part=initial_model -->
```ocaml
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
```

Next we will define our `init` function. This function takes the initial state
and returns a Mint Tea `Command` that kicks off the application. This can be
going into fullscreen, setting up timers, or just nothing. 

In this case we do nothing:

<!-- $MDX file=./examples/basic/main.ml,part=init -->
```ocaml
let init _model = Command.Noop
```

### The Update Function

The interesting part of any TEA application is always how it updates the model
based off incoming events. In Mint Tea things aren't any different. The
`update` function gets called whenever "things happen" – this could be a key
press, a timer going off, or even every rendering frame. There is even the
possibility of using custom events.

<!-- $MDX file=./examples/basic/main.ml,part=update -->
```ocaml
let update event model =
  match event with
  (* if we press `q` or the escape key, we exit *)
  | Event.KeyDown ((Key "q" | Escape), _modifier) -> (model, Command.Quit)
  (* if we press up or `k`, we move up in the list *)
  | Event.KeyDown ((Up | Key "k"), _modifier) ->
      let cursor =
        if model.cursor = 0 then List.length model.choices - 1
        else model.cursor - 1
      in
      ({ model with cursor }, Command.Noop)
  (* if we press down or `j`, we move down in the list *)
  | Event.KeyDown ((Down | Key "j"), _modifier) ->
      let cursor =
        if model.cursor = List.length model.choices - 1 then 0
        else model.cursor + 1
      in
      ({ model with cursor }, Command.Noop)
  (* when we press enter or space we toggle the item in the list
     that the cursor points to *)
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
  (* for all other events, we do nothing *)
  | _ -> (model, Command.Noop)
```

You may have noticed the special command `Quit` up there. This command tells
Mint Tea that it's time for the application to shutdown.

### The View Method

Finally, we need to render our TUI. For that we define a little `view` method
that takes our model and creates a `string`. That string is our TUI!

Because the view describes the entire UI of your application, you don't have to
worry about redrawing logic or things like that. Mint Tea takes care of it for
you.

<!-- $MDX file=./examples/basic/main.ml,part=view -->
```ocaml
let view model =
  (* we create our options by mapping over them *)
  let options =
    model.choices
    |> List.mapi (fun idx (name, checked) ->
           let cursor = if model.cursor = idx then ">" else " " in
           let checked = if checked = `selected then "x" else " " in
           Format.sprintf "%s [%s] %s" cursor checked name)
    |> String.concat "\n"
  in
  (* and we send the UI for rendering! *)
  Format.sprintf
    {|
What should we buy at the market?

%s

Press q to quit.

  |} options
```

### All Together Now

The last step is to simply run our program. We build our Mint Tea application
by calling `Minttea.app ~init ~update ~view ()` and we can start it by calling
`Minttea.start app ~initial_model`

<!-- $MDX file=./examples/basic/main.ml,part=start -->
```ocaml
let app = Minttea.app ~init ~update ~view ()
let () = Minttea.start app ~initial_model
```

We can now run our application:

`$ dune exec ./shop.exe`

And we get our lovely little TUI app:

<img src="https://github.com/leostera/minttea/raw/main/examples/basic/demo.gif"/>

## What's Next?

This tutorial covers the very basics of building an interactive terminal UI
with Mint Tea, but in the real world you'll also need to perform I/O.

You can also check our other [examples in GitHub](https://github.com/leostera/minttea/tree/main/examples) to see more ways in which
you can build your TUIs.

## Libraries to use with Mint Tea

* [Leaves](./leaves): Common Mint Tea components to get you started
* [Spices](./spices): style, format, and layout tools for terminal applications
