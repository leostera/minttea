type help = { key : string; desc : string }
type binding = { keys : Minttea.Event.key list; help : help; disabled : bool }

module type Key_map_with_defaults = sig
  type t

  val defaults : (t * binding) list
end

module Make : functor (K : Key_map_with_defaults) -> sig
  type t = (K.t * binding) list

  val make : (K.t * binding) list -> t
  val find_match : Minttea.Event.key -> t -> K.t option
  val update_binding : K.t -> (binding option -> binding) -> t -> t
  val to_list : t -> (K.t * binding) list
end

