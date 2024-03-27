open Minttea
open Leaves

type model = { paginator : Paginator.t; items : string list }

let items = List.init 9 (fun x -> "Item " ^ string_of_int (x + 1))
let paginator = Paginator.make ~per_page:3 ~style:Paginator.Dots ()
let paginator, _ = Paginator.set_total_pages paginator 9
let initial_model = { paginator; items }
let init _ = Command.Hide_cursor

let update (event : Event.t) model =
  match event with
  | Event.KeyDown (Key "q", _modifier) -> (model, Command.Quit)
  | _ ->
      ( { model with paginator = Paginator.update model.paginator event },
        Command.Noop )

let view model =
  let start, end_pos = Paginator.get_slice_bounds model.paginator 9 in
  let x = List.to_seq model.items in
  let y = Seq.drop start x in
  let z = Seq.take (end_pos - start) y in
  "\n Look! We have 9 items!\n\n "
  ^ String.concat "\n " (List.of_seq z)
  ^ Format.sprintf "\n %s\n" (Paginator.view model.paginator)
  ^ "\n h/l ←/→ page • q: quit\n"

let app = Minttea.app ~init ~update ~view ()
let () = Minttea.start ~initial_model app
