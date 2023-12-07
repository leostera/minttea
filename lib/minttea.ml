open Riot

type cmd = Noop | Quit
type message = KeyDown of string

let message_pp fmt t =
  match t with
  | KeyDown key -> Format.fprintf fmt "KeyDown(%s)" key

type 'model app = {
  initial_model : unit -> 'model;
  init : 'model -> cmd;
  update : msg:message -> 'model -> 'model * cmd;
  view : 'model -> string;
}

let app ~initial_model ~init ~update ~view () =
  { initial_model; init; update; view }

type 'model program = { app : 'model app }

let make app = { app }

type Message.t += Input of message | Render of string

let rec run renderer app model =
  match receive () with
  | Input msg ->
      Logger.debug (fun f -> f "message: %a" message_pp msg);
      let model, cmd = app.update ~msg model in
      let view = app.view model in
      send renderer (Render view);
      handle_cmd cmd renderer app model
  | _ -> run renderer app model

and handle_cmd cmd renderer app model =
  match cmd with Quit -> () | _ -> run renderer app model

let run_loop app renderer =
  let initial_model = app.initial_model () in
  let _init_cmd = app.init initial_model in
  let _final_model = run renderer app initial_model in
  ()

module Renderer = struct
  let clear_screen () = print_string ""

  let rec run () =
    match receive () with
    | Render output ->
        Printf.printf "\x1B[2J\x1B[H%s%!" output;
        run ()
    | _ -> run ()

  let spawn_link () = spawn_link @@ fun () -> run ()
end

module Io_loop = struct
  let stdin_fd = Unix.descr_of_in_channel stdin

  let set_raw_mode () =
    let termios = Unix.tcgetattr stdin_fd in
    let new_termios =
      Unix.
        {
          termios with
          c_icanon = false;
          c_echo = false;
          c_vmin = 1;
          c_vtime = 0;
        }
    in
    Unix.tcsetattr stdin_fd TCSANOW new_termios;
    termios

  let restore_mode termios = Unix.tcsetattr stdin_fd TCSANOW termios

  let rec read_inputs stdin =
    match Uutf.decode stdin with
    | `Uchar u ->
        let buf = Buffer.create 1 in
        Uutf.Buffer.add_utf_8 buf u;
        let key = Buffer.contents buf in
        KeyDown key
    | `End ->
        yield ();
        read_inputs stdin
    | _ -> assert false

  let rec run () =
    let stdin = Uutf.decoder ~encoding:`UTF_8 (`Channel stdin) in
    let msg = read_inputs stdin in
    send_by_name ~name:"Minttea.runner" (Input msg);
    yield ();
    run ()

  let spawn_link () =
    spawn_link @@ fun () ->
    let original_termios = set_raw_mode () in
    Fun.protect ~finally:(fun () -> restore_mode original_termios) run
end

let run { app } =
  let io = Io_loop.spawn_link () in
  register "Minttea.io" io;

  let renderer = Renderer.spawn_link () in
  register "Minttea.renderer" renderer;

  register "Minttea.runner" (self ());
  run_loop app renderer;
  shutdown ()

let start t =
  let prog = make t in
  let module App = struct
    let name = "my_app"

    let start () =
      Logger.set_log_level None;
      let pid = spawn_link (fun () -> run prog) in
      Ok pid
  end in
  Riot.start ~apps:[ (module Riot.Logger); (module App) ] ()
