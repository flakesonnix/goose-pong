# Pong

Classic Pong game in the terminal (like DOS/Atari), written in Goose.

## Game

- Two paddles, one ball, score
- Computer controls the left paddle (follows the ball automatically)
- You control the right paddle
- First to 5 points wins

## Controls

| Key | Action |
|---|---|
| `w` | Right paddle up |
| `s` | Right paddle down |
| `o` | Right paddle up (alternative) |
| `l` | Right paddle down (alternative) |
| `q` | Quit game |

## Build & Run

```bash
goose build pong.goose && ./pong
```

Or directly in the compiler (JIT):

```bash
goose pong.goose
```

## Example Output

```
##################################################
#                                                #
#                                                #
#        |                                       #
#                                                #
#        O                                       #
#                                                #
#        |                                       #
#                                                #
#                                                #
##################################################
  0  :  0
  Controls: w/s = left paddle, o/l = right paddle, q = Quit
```

## Features

- `while` loop for the main game loop
- `sleep(0.1)` for frame timing
- `read_line()` for keyboard input
- Random number for ball direction on serve
- No heap allocation during the game (everything on the stack)
