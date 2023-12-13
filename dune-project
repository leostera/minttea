(lang dune 3.11)

(name minttea)

(generate_opam_files true)

(source
 (github username/reponame))

(authors "Author Name")

(maintainers "Maintainer Name")

(license LICENSE)

(documentation https://url/to/documentation)

(package
 (name minttea)
 (synopsis "A short synopsis")
 (description "A longer description")
 (depends (ocaml (>= "5.1")) (dune (>= "3.11")) (riot (>= "0.0.4")))
 (tags
  (topics "to describe" your project)))

(package
 (name spices)
 (synopsis "A short synopsis")
 (description "A longer description")
 (depends (ocaml (>= "5.1")) (dune (>= "3.11")) (riot (>= "0.0.4")))
 (tags
  (topics "to describe" your project)))

(package
 (name terminal)
 (synopsis "A short synopsis")
 (description "A longer description")
 (depends (ocaml (>= "5.1")) (dune (>= "3.11")) (riot (>= "0.0.4")))
 (tags
  (topics "to describe" your project)))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/dune-files.html#dune-project
