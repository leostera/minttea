# Spices

<img src="https://github.com/leostera/minttea/assets/854222/7a4fc1d6-4be4-4de9-bce8-7d3d6b71e9e6" width="300" />


Spices is a small declarative styling library for TUI applications.

## Getting Started

```ocaml
let gray = Spices.color "#232323"
let keyword = Spices.(default () |> bold true |> fg gray)
let send_btn = Spices.render keyword "send"
```
