# Pong

Classic Pong game written in Goose with raylib (graphics).

## Game

- Two paddles, one ball, score
- Computer controls the left paddle (AI follows the ball)
- You control the right paddle
- Ball speeds up slightly on each paddle hit
- First to 5 points wins
- Ball angle changes based on where it hits the paddle

## Controls

| Key | Action |
|-----|--------|
| `W` | Right paddle up |
| `S` | Right paddle down |
| `Q` or `ESC` | Quit game |

## Build & Run

### Main game (requires raylib)

```bash
# 1. Build the Goose compiler
git clone https://github.com/aardappel/goose.git
cd goose && cmake -B build -S . && cmake --build build -j

# 2. Build Pong with raylib
./build/goose build pong.goose

# 3. Run
./pong
```

**Requirements:** `raylib` (library + headers) must be installed on your system for building and running the main game. Install it with your package manager, e.g.:

- Debian/Ubuntu: `sudo apt install libraylib-dev`
- Arch: `sudo pacman -S raylib`
- macOS: `brew install raylib`
- Nix: `nix-shell -p raylib`

### Unit tests (no raylib needed)

```bash
./build/goose build test_pong.goose && ./test_pong
```

Or use the Nix flake (builds and runs unit tests only):

```bash
nix build
```

## Files

| File | Purpose |
|------|---------|
| `pong.goose` | Main game with raylib bindings embedded |
| `test_pong.goose` | Unit tests for collision logic (no raylib needed) |
| `pong.build` | C build config: `c_libs = ["raylib"]` |
| `README.md` | This file |
| `flake.nix` | Nix flake (builds and runs unit tests only) |
| `.github/workflows/ci.yml` | GitHub Actions CI |

## flake.nix Note

The `flake.nix` uses `nixpkgs` and `aardappel/goose` as inputs. It builds the Goose compiler from source and runs the unit tests. The main game (`pong.goose`) requires `raylib` to be installed on your system and is built manually as shown above.
