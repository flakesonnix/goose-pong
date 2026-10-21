// pong.goose — Classic Pong game in the terminal (like DOS/Atari)
// Two paddles, one ball, score. Keyboard controlled.

import std;
import os;

// ---- Playfield -----------------------------------------------------------

let WIDTH: i64 = 50;
let HEIGHT: i64 = 20;
let PADDLE_H: i64 = 5;      // paddle height
let WIN_SCORE: i64 = 5;     // points to win

// ---- Game state ----------------------------------------------------------

var ball_x: i64 = WIDTH / 2;
var ball_y: i64 = HEIGHT / 2;
var ball_dx: i64 = 1;
var ball_dy: i64 = 1;

var left_y: i64 = HEIGHT / 2 - PADDLE_H / 2;
var right_y: i64 = HEIGHT / 2 - PADDLE_H / 2;

var left_score: i64 = 0;
var right_score: i64 = 0;

var running: bool = true;

// ---- Random number for ball direction ------------------------------------

var rng_state: u64 = 12345;

fn rand_next() -> u64 {
    rng_state = rng_state + 11400714819323198485;
    var z = rng_state;
    z = (z ^ (z >> 30)) * 13787848793156543929;
    z = (z ^ (z >> 27)) * 10723151780598845931;
    return z ^ (z >> 31);
}

fn rand_range(lo: i64, hi: i64) -> i64 {
    lo + (rand_next() % (hi - lo) as u64) as i64
}

// ---- Draw screen ---------------------------------------------------------

fn clear_screen() {
    print("\x1b[2J\x1b[H");
}

fn draw() {
    // Top border
    var row: u8[>..] = [];
    for x in WIDTH + 2 { row.push('#' as u8); }
    print(row);

    // Playfield rows
    for y in HEIGHT {
        row = [];
        row.push('#' as u8);  // left border
        for x in WIDTH {
            // Ball?
            if x == ball_x && y == ball_y {
                row.push('O' as u8);
            }
            // Left paddle?
            else if x == 1 && y >= left_y && y < left_y + PADDLE_H {
                row.push('|' as u8);
            }
            // Right paddle?
            else if x == WIDTH - 2 && y >= right_y && y < right_y + PADDLE_H {
                row.push('|' as u8);
            }
            // Center line (dotted)
            else if x == WIDTH / 2 && y % 2 == 0 {
                row.push(':' as u8);
            }
            else {
                row.push(' ' as u8);
            }
        }
        row.push('#' as u8);  // right border
        print(row);
    }

    // Bottom border
    row = [];
    for x in WIDTH + 2 { row.push('#' as u8); }
    print(row);

    // Score
    print("  ", left_score, "  :  ", right_score);
    print("  Controls: w/s = left paddle, o/l = right paddle, q = Quit");
}

// ---- Move ball -----------------------------------------------------------

fn move_ball() {
    ball_x = ball_x + ball_dx;
    ball_y = ball_y + ball_dy;

    // Top/bottom wall bounce
    if ball_y <= 0 {
        ball_y = 0;
        ball_dy = -ball_dy;
    }
    if ball_y >= HEIGHT - 1 {
        ball_y = HEIGHT - 1;
        ball_dy = -ball_dy;
    }

    // Hit left paddle
    if ball_x == 2 && ball_y >= left_y && ball_y < left_y + PADDLE_H {
        ball_dx = -ball_dx;
        ball_x = 2;
        // slight random Y variation
        let r = rand_range(-1, 2);
        ball_dy = ball_dy + r;
        if ball_dy == 0 { ball_dy = 1; }
    }

    // Hit right paddle
    if ball_x == WIDTH - 3 && ball_y >= right_y && ball_y < right_y + PADDLE_H {
        ball_dx = -ball_dx;
        ball_x = WIDTH - 3;
        let r = rand_range(-1, 2);
        ball_dy = ball_dy + r;
        if ball_dy == 0 { ball_dy = 1; }
    }

    // Goal left (right player scores)
    if ball_x <= 0 {
        right_score = right_score + 1;
        reset_ball();
    }

    // Goal right (left player scores)
    if ball_x >= WIDTH - 1 {
        left_score = left_score + 1;
        reset_ball();
    }
}

fn reset_ball() {
    ball_x = WIDTH / 2;
    ball_y = HEIGHT / 2;
    ball_dx = if rand_range(0, 2) == 0 { -1 } else { 1 };
    ball_dy = if rand_range(0, 2) == 0 { -1 } else { 1 };
    sleep(0.5);
}

// ---- Move paddles --------------------------------------------------------

fn move_left_paddle(dir: i64) {
    left_y = left_y + dir;
    if left_y < 0 { left_y = 0; }
    if left_y + PADDLE_H > HEIGHT { left_y = HEIGHT - PADDLE_H; }
}

fn move_right_paddle(dir: i64) {
    right_y = right_y + dir;
    if right_y < 0 { right_y = 0; }
    if right_y + PADDLE_H > HEIGHT { right_y = HEIGHT - PADDLE_H; }
}

// ---- Computer opponent (left paddle follows ball) ------------------------

fn ai_move_left() {
    let paddle_center = left_y + PADDLE_H / 2;
    if ball_y < paddle_center - 1 {
        move_left_paddle(-1);
    } else if ball_y > paddle_center + 1 {
        move_left_paddle(1);
    }
}

// ---- Read input ----------------------------------------------------------

fn process_input(input: u8[:]) {
    for c in input {
        if c == 'w' { move_left_paddle(-1); }
        else if c == 's' { move_left_paddle(1); }
        else if c == 'o' { move_right_paddle(-1); }
        else if c == 'l' { move_right_paddle(1); }
        else if c == 'q' { running = false; }
    }
}

// ---- Start screen --------------------------------------------------------

fn show_start() {
    clear_screen();
    print("  ==========================================");
    print("             P O N G   (Goose)             ");
    print("  ==========================================");
    print("");
    print("  Classic Pong game in the terminal");
    print("");
    print("  Controls:");
    print("    w/s  = left paddle up/down");
    print("    o/l  = right paddle up/down");
    print("    q    = quit game");
    print("");
    print("  The computer controls the left paddle.");
    print("  You play the right paddle.");
    print("");
    print("  First to 5 points wins.");
    print("");
    print("  Press Enter to start...");
    var dummy: u8[>..] = [];
    read_line(dummy);
}

// ---- Game over -----------------------------------------------------------

fn show_game_over(winner: u8[:]) {
    clear_screen();
    print("  ==========================================");
    print("           G A M E   O V E R               ");
    print("  ==========================================");
    print("");
    print("  ", winner, " wins!");
    print("");
    print("  Final score: ", left_score, " : ", right_score);
    print("");
    print("  Press Enter to exit...");
    var dummy: u8[>..] = [];
    read_line(dummy);
}

// ---- Main game loop ------------------------------------------------------

fn main() {
    show_start();

    while running {
        // Move ball
        move_ball();

        // Computer opponent
        ai_move_left();

        // Draw
        clear_screen();
        draw();

        // Check if someone won
        if left_score >= WIN_SCORE {
            running = false;
            show_game_over("Left player (computer)");
            break;
        }
        if right_score >= WIN_SCORE {
            running = false;
            show_game_over("Right player (you)");
            break;
        }

        // Short pause and read input
        sleep(0.1);
        var input: u8[>..] = [];
        if read_line(input) {
            process_input(input);
        }
    }
}
