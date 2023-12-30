type help = { key : string; desc : string }
type binding = { keys : Minttea.Event.key list; help : help; disabled : bool }

module type Key_map_with_defaults = sig
  type t

  val defaults : (t * binding) list
end

module Make (K : Key_map_with_defaults) = struct
  type t = (K.t * binding) list

  let make bindings =
    let f (default_msg, default_binding) bindings =
      let is_bound = List.mem_assoc default_msg bindings in

      if is_bound then bindings
      else List.cons (default_msg, default_binding) bindings
    in

    List.fold_right f K.defaults bindings

  let find_match key key_map =
    let f (_, (binding : binding)) =
      if binding.disabled then false
      else List.exists (fun k -> k == key) binding.keys
    in
    List.find_opt f key_map |> Option.map (fun (msg, _) -> msg)

  let update_binding msg f bindings =
    let updated_binding = f (List.assoc_opt msg bindings) in

    List.remove_assoc msg bindings |> List.cons (msg, updated_binding)

  (* INFO: This is just incase the underlying type changes in refactorings *)
  let to_list bindings = bindings
end
