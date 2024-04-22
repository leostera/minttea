type style = Dots | Numerals
type t

val set_total_pages : t -> int -> t * int
(** [set_total_pages paginator total] calculates the total number of pages
from a given number of items. Its use is optional since this pager can be
used for other things beyond navigating sets. Note that it both returns the
number of total pages and alters the model.

    {@ocaml[
      let paginator = Paginator.make () in
      let total_pages, paginator = Paginator.set_total_pages paginator 3
    ]}
 *)

val get_slice_bounds : t -> int -> int * int
(**  [get_slice_bounds paginator item_count] returns the start and end bounds of slice you're
     rendering for the current page based on total number of items

     {@ocaml[
       let bunch_of_stuff = List.to_seq [...] in
       let start, end_pos = Paginator.get_slice_bounds (Seq.length bunch_of_stuff) in
       let slice_to_render = Seq.take (end_pos - start) @@ Seq.drop start bunch_of_stuff
     ]}
 *)

val items_on_page : t -> int -> int
(** [items_on_page paginator items_count] returns the number of items on the
    current page given the total number of items passed as an argument.

    {@ocaml[
      let paginator = Paginator.make () in
      let item_count = Paginator.items_on_page paginator 10
    ]}
 *)

val on_last_page : t -> bool
(** [on_last_page paginator] returns whether or not we're on the last page.

    {@ocaml[
      let paginator = Paginator.make () in
      Paginator.on_last_page paginator
    ]}
 *)

val on_first_page : t -> bool
(** [on_first_page paginator] returns whether or not we're on the first page.

    {@ocaml[
      let paginator = Paginator.make () in
      Paginator.on_first_page paginator
    ]}
 *)

val prev_page : t -> t
(** [prev_page paginator] navigates one page backward with a lower bound of 0.

    {@ocaml[
      let paginator = Paginator.make () in
      let paginator = Paginator.prev_page paginator
    ]}
 *)

val next_page : t -> t
(** [next_page paginator] navigates one page forward with an upper bound of total_pages - 1.

    {@ocaml[
      let paginator = Paginator.make () in
      let paginator = Paginator.next_page paginator
    ]}
 *)

val make :
  ?style:style ->
  ?page:int ->
  ?per_page:int ->
  ?total_pages:int ->
  ?active_dot:string ->
  ?inactive_dot:string ->
  ?numerals_format:(int -> int -> string, unit, string) format ->
  ?text_style:Spices.style ->
  unit ->
  t
(** [make ()] creates a new {Paginator.t}

    A different start page can be specified using `page`.

    For helper functions like `get_slice_bounds` to work correctly, the number of items to be rendered on each page can be passed to `per_page`.

    By default, Paginator uses Numerals format, displaying page 1 of 3 as "1/3".
    The format for numerals can be changed using `numerals_format` to any format that takes two integers, e.g. "%d of %d" rendering "1 of 3" instead.
    Alternatively, `style` can be specified as `Paginator.Dots` to display pages using characters instead with the `active_dot` "•" and inactive_dot "○" defaults, which can be specified/overriden.

    By default, Spices.default is used, which can be overriden using `text_style`.

    {@ocaml[
      let paginator = Paginator.make ()
    ]}
 *)

val update : t -> Minttea.Event.t -> t
(** [update paginator event] is the Tea update function which binds keystrokes to pagination.

    {@ocaml[
      let paginator = Paginator.update paginator event
    ]}
 *)

val view : t -> string
(** [view paginator] renders the pagination to a string.

    {@ocaml[
      let paginator = Paginator.make () in
      let pagination_string = Paginator.view paginator
    ]}
 *)
