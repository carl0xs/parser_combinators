{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      beam = pkgs.beam.packages.erlang_27;
    in {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [
          beam.erlang
          beam.elixir_1_18
        ];
      };
    };
}

