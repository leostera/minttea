type help = { key : string; desc : string }

type binding = {
  keys : Minttea.Event.key list;
  help : help option;
  disabled : bool;
}

type 'a t = ('a * binding) list

let on ?help ?(disabled = false) keys msg = (msg, { keys; help; disabled })

let find_match ?(custom_key_map : 'a t option) key (default_key_map : 'a t) =
  let key_map =
    match custom_key_map with
    | Some k_map ->
        List.fold_left
          (fun acc (k, b) ->
            if List.mem_assoc k acc then acc else List.cons (k, b) acc)
          k_map default_key_map
    | None -> default_key_map
  in

  let f (_, (binding : binding)) =
    if binding.disabled then false
    else List.exists (fun k -> k == key) binding.keys
  in
  List.find_opt f key_map |> Option.map (fun (msg, _) -> msg)

(* INFO: This is just for future proofing, in case the underlying type changes *)
let make (key_map : ('a * binding) list) = key_map
let to_list (key_map : 'a t) = key_map
