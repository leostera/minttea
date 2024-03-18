(lang dune 3.11)
(using mdx 0.4)

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
 (depends
   (ocaml (>= "5.1"))
   (riot (= "0.0.8"))
   (mdx (and :with-test (>= "2.3.1")))
   (tty (>= "0.0.2"))
   uuseg)
 (tags (tui "terminal-ui" framework riot)))

(package
 (name leaves)
 (synopsis "A collection of reusable components from Mint Tea")
 (description "Leaves is a collection of reusable components for writing TUI applications with Mint Tea")
 (depends 
   (ocaml (>= "5.1"))
   (minttea (= :version))
   (mdx (and :with-test (>= "2.3.1")))
   (spices (= :version)))
 (tags (tui "terminal-ui" apps components component library)))

(package
 (name spices)
 (synopsis "Declarative styles for TUI applications")
 (description "Spices lets you create style definitions for TUIs and provide handy renderers for strings over them")
 (depends 
   (ocaml (>= "5.1"))
   (colors (>= "0.0.1"))
   (mdx (and :with-test (>= "2.3.1")))
   (tty (>= "0.0.2"))
   uuseg)
 (tags (styling styles declarative framework tui "terminal-ui" apps)))
