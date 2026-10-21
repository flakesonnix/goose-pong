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
      buildInputs = [ pkgs.cmake pkgs.gcc pkgs.raylib ];
    } ''
      export HOME=$(mktemp -d)
      cp -r $src/* .
      # Build the Goose compiler from source (fetched as Flake input)
      cmake -B build -S ${goose}
      cmake --build build -j
      # Create a gcc wrapper that links raylib (needed because Goose compiler
      # calls gcc directly without Nix wrapper environment)
      cat > wrapper-gcc << EOF
#!/bin/bash
exec ${pkgs.gcc}/bin/gcc -L${pkgs.raylib}/lib -lraylib "\$@"
EOF
      chmod +x wrapper-gcc
      export CC=$PWD/wrapper-gcc
      # Build the Goose programs
      ./build/goose build pong.goose
      ./build/goose build test_pong.goose
      mkdir -p $out/bin
      cp pong $out/bin/
      cp test_pong $out/bin/
      # Run tests
      ./test_pong
    '';
  };
}
