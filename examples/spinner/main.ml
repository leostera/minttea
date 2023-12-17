open Minttea
open Leaves

let mint fmt = Spices.(default |> fg (color "#77e5b7") |> build) fmt

type spinner_state = {
  spinner : Spinner.spinner;
  frame : int;
  ref : unit Riot.Ref.t;
}

let set_timer (s : spinner_state) =
  Command.Set_timer (s.ref, 1.0 /. float_of_int s.spinner.fps)

type s = { spinners : spinner_state list }

let initial_model =
  {
    spinners =
      [
        { spinner = Spinner.line; frame = 0; ref = Riot.Ref.make () };
        { spinner = Spinner.dot; frame = 0; ref = Riot.Ref.make () };
        { spinner = Spinner.mini_dot; frame = 0; ref = Riot.Ref.make () };
        { spinner = Spinner.jump; frame = 0; ref = Riot.Ref.make () };
        { spinner = Spinner.pulse; frame = 0; ref = Riot.Ref.make () };
        { spinner = Spinner.points; frame = 0; ref = Riot.Ref.make () };
        { spinner = Spinner.meter; frame = 0; ref = Riot.Ref.make () };
        { spinner = Spinner.globe; frame = 0; ref = Riot.Ref.make () };
        { spinner = Spinner.moon; frame = 0; ref = Riot.Ref.make () };
        { spinner = Spinner.monkey; frame = 0; ref = Riot.Ref.make () };
        { spinner = Spinner.hamburger; frame = 0; ref = Riot.Ref.make () };
        { spinner = Spinner.ellipsis; frame = 0; ref = Riot.Ref.make () };
      ];
  }

let init model = Command.Seq (List.map set_timer model.spinners)

let update event model =
  match event with
  | Event.Timer ref ->
      let update_spinner ~ref s =
        if Riot.Ref.equal ref s.ref then
          ( { s with frame = (s.frame + 1) mod Array.length s.spinner.frames },
            Some (set_timer s) )
        else (s, None)
      in
      let spinners, cmds =
        model.spinners |> List.map (update_spinner ~ref) |> List.split
      in
      ( { spinners },
        cmds
        |> List.find (fun (c : Minttea.Command.t option) -> Option.is_some c)
        |> Option.value ~default:Command.Noop )
  | Event.KeyDown (Key "q") -> (model, Command.Quit)
  | _ -> (model, Command.Noop)

let view model =
  let render_spinner s = Spinner.view ~frame:s.frame s.spinner in
  mint "%s" (String.concat "  " (model.spinners |> List.map render_spinner))

let app = Minttea.app ~init ~update ~view ()
let () = Minttea.start ~initial_model app
