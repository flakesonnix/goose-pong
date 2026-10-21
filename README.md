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

```bash
goose build pong.goose && ./pong
```

Or typecheck without raylib:

```bash
goose check pong.goose
```

**Requirements:** `raylib` (library + headers) must be installed on your system for building and running.

## Unit Tests

```bash
goose build test_pong.goose && ./test_pong
```

## Files

| File | Purpose |
|------|---------|
| `pong.goose` | Main game with raylib bindings embedded |
| `test_pong.goose` | Unit tests for collision logic (no raylib needed) |
| `pong.build` | C build config: `c_libs = ["raylib"]` |
| `README.md` | This file |
| `flake.nix` | Nix flake (build/test/devShell) |
| `.github/workflows/ci.yml` | GitHub Actions CI |

## flake.nix Note

The `flake.nix` uses only `nixpkgs` as input (not `goose`, because `aardappel/goose` does not publish a flake). It provides `build`, `test`, and `devShell` outputs that document how to build and run. You still need to build the Goose compiler manually and have `raylib` installed.
