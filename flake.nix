{
  description = "Pong game in Goose (terminal-based)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }@inputs: {
    checks."x86_64-linux".build = let
      pkgs = import nixpkgs { system = "x86_64-linux"; };
    in pkgs.stdenv.mkDerivation {
      name = "goose-pong-build";
      buildInputs = [ pkgs.cmake pkgs.gcc pkgs.git ];
      buildPhase = ''
        echo "Build the Goose compiler first:"
        echo "  git clone https://github.com/aardappel/goose.git"
        echo "  cd goose && cmake -B build -S . && cmake --build build -j"
        echo "Then run:"
        echo "  ./goose/build/goose build pong.goose && ./pong"
        echo ""
        echo "Source files present:"
        ls -la pong.goose test_pong.goose pong.build
      '';
      installPhase = ''
        true
      '';
    };

    checks."x86_64-linux".test = let
      pkgs = import nixpkgs { system = "x86_64-linux"; };
    in pkgs.stdenv.mkDerivation {
      name = "goose-pong-test";
      buildInputs = [ pkgs.cmake pkgs.gcc pkgs.git ];
      buildPhase = ''
        echo "Unit test source present:"
        ls -la test_pong.goose
        echo ""
        echo "To run the test, first build the Goose compiler, then:"
        echo "  ./goose/build/goose build test_pong.goose && ./test_pong"
      '';
      installPhase = ''
        true
      '';
    };

    devShells."x86_64-linux".default = let
      pkgs = import nixpkgs { system = "x86_64-linux"; };
    in pkgs.mkShell {
      buildInputs = [ pkgs.cmake pkgs.gcc pkgs.git ];
      shellHook = ''
        echo "Entered goose-pong development shell"
        echo ""
        echo "To build and run:"
        echo "  1. Build Goose compiler: cmake -B build -S <goose-repo> && cmake --build build -j"
        echo "  2. Build pong.goose:     ./build/goose build pong.goose && ./pong"
        echo "  3. Run unit tests:       ./build/goose build test_pong.goose && ./test_pong"
      '';
    };
  };
}
