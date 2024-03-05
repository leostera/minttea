{
  description = "A little TUI framework for OCaml";

  inputs.colors.url = "github:ocaml-tui/colors";
  inputs.tty.url = "github:ocaml-tui/tty";
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
                inputsFrom = [ self'.packages.spices ];
              };
            };

            packages = {
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
