{
  description = "Pong game in Goose (terminal-based)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    goose.url = "github:aardappel/goose";
    goose.flake = false;
  };

  outputs = { self, nixpkgs, goose }@inputs: let
    pkgs = import nixpkgs { system = "x86_64-linux"; };
  in {
    checks."x86_64-linux".default = pkgs.runCommand "goose-pong" {
      src = ./.;
      buildInputs = [ pkgs.cmake pkgs.gcc ];
    } ''
      export HOME=$(mktemp -d)
      cp -r $src/* .
      cmake -B build -S ${goose}
      cmake --build build -j
      ./build/goose build test_pong.goose
      mkdir -p $out/bin
      cp test_pong $out/bin/
      ./test_pong
    '';

    packages.x86_64-linux.default = pkgs.runCommand "goose-pong-bin" {
      src = ./.;
      buildInputs = [ pkgs.cmake pkgs.gcc ];
    } ''
      export HOME=$(mktemp -d)
      cp -r $src/* .
      cmake -B build -S ${goose}
      cmake --build build -j
      ./build/goose build test_pong.goose
      mkdir -p $out/bin
      cp test_pong $out/bin/
    '';
  };
}
