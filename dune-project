(lang dune 3.11)

(name minttea)

(generate_opam_files true)

(source (github leostera/minttea))

(authors "Leandro Ostera <leandro@abstractmachines.dev>")

(maintainers "Leandro Ostera <leandro@abstractmachines.dev>")

(license MIT)

(package
 (name minttea)
 (synopsis "A fun, functional, and stateful way to build terminal apps in OCaml heavily inspired by Go's BubbleTea")
 (description "A longer description")
 (depends (ocaml (>= "5.1")) (dune (>= "3.11")) (riot (>= "0.0.4")))
 (tags (tui "terminal-ui" framework riot)))

(package
 (name leaves)
 (synopsis "A collection of reusable components from Mint Tea")
 (description "A longer description")
 (depends (ocaml (>= "5.1")) (dune (>= "3.11")) spices)
 (tags (tui "terminal-ui" apps components component library)))

(package
 (name spices)
 (synopsis "Declarative styles for TUI applications")
 (description "A longer description")
 (depends (ocaml (>= "5.1")) (dune (>= "3.11")) terminal)
 (tags (styling styles declarative framework tui "terminal-ui" apps)))

(package
 (name terminal)
 (synopsis "A short synopsis")
 (description "A longer description")
 (depends (ocaml (>= "5.1")) (dune (>= "3.11")))
 (tags (topics "to describe" your project)))

