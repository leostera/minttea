type help = { key : string; desc : string }

type binding = {
  keys : Minttea.Event.key list;
  help : help option;
  disabled : bool;
}

type 'a t = ('a * binding) list

val on :
  ?help:help ->
  ?disabled:bool ->
  Minttea.Event.key list ->
  'a ->
  'a * binding

val find_match :
  ?custom_key_map:'a t ->
  Minttea.Event.key ->
  'a t ->
  'a option

val make : ('a * binding) list -> 'a t
val to_list : 'a t -> ('a * binding) list

