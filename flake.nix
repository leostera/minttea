{
  description = "A little TUI framework for OCaml";

  inputs.colors.url = "github:ocaml-tui/colors";
  inputs.colors.inputs.nixpkgs.follows = "nixpkgs";
  inputs.minttea.url = "github:leostera/minttea";
  inputs.minttea.inputs.nixpkgs.follows = "nixpkgs";
  inputs.riot.url = "github:riot-ml/riot";
  inputs.riot.inputs.nixpkgs.follows = "nixpkgs";
  inputs.tty.url = "github:ocaml-tui/tty";
  inputs.tty.inputs.nixpkgs.follows = "nixpkgs";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
      perSystem = { config, self', inputs', pkgs, system, ... }:
        let
          inherit (pkgs) ocamlPackages mkShell;
          inherit (ocamlPackages) buildDunePackage;
          version = "0.0.2";
        in
          {
            devShells = {
              default = mkShell {
                buildInputs = [ ocamlPackages.utop ];
                inputsFrom = [ self'.packages.spices self'.packages.default self'.packages.leaves ];
              };
            };

            packages = {
              default = buildDunePackage {
                inherit version;
                pname = "minttea";
                propagatedBuildInputs = with ocamlPackages; [
                  inputs'.riot.packages.default
                  (mdx.override {
                    inherit logs;
                  })
                  inputs'.tty.packages.default
                  uuseg
                ];
                src = ./.;
              };
              leaves = buildDunePackage {
                inherit version;
                pname = "leaves";
                propagatedBuildInputs = with ocamlPackages; [
                  self'.packages.default
                  (mdx.override {
                    inherit logs;
                  })
                  inputs'.minttea.packages.spices
                ];
                src = ./.;
              };
              spices = buildDunePackage {
                inherit version;
                pname = "spices";
                propagatedBuildInputs = with ocamlPackages; [
                  inputs'.colors.packages.default
                  inputs'.tty.packages.default
                  (mdx.override {
                    inherit logs;
                  })
                ];
                src = ./.;
              };
            };
          };
    };
}
