// pong.goose — Klassisches Pong-Spiel mit raylib (grafisch, wie DOS/Atari)
// Zwei Schläger, ein Ball, Punktestand, KI-Gegner.
// Benötigt installiertes raylib (libraylib + Header) zum Bauen und Ausführen.
//
// Build:
//   goose build pong.goose   # braucht c_libs = ["raylib"] in pong.build
//   ./pong
//
// Ohne installiertes raylib: `goose check pong.goose` typenprüft trotzdem.

const SCREEN_WIDTH: i32 = 800;
const SCREEN_HEIGHT: i32 = 450;
const TARGET_FPS: i32 = 60;

const KEY_W: i32 = 87;
const KEY_S: i32 = 83;
const KEY_UP: i32 = 265;
const KEY_DOWN: i32 = 264;
const KEY_ESCAPE: i32 = 256;
const KEY_Q: i32 = 81;

const BLACK = Color { 0, 0, 0, 255 };
const WHITE = Color { 255, 255, 255, 255 };
const RAYWHITE = Color { 245, 245, 245, 255 };
const LIGHTGRAY = Color { 200, 200, 200, 255 };

struct Vector2 { x: f32, y: f32 }
struct Color { r: u8, g: u8, b: u8, a: u8 }
struct Rectangle { x: f32, y: f32, width: f32, height: f32 }
struct Camera2D { offset: Vector2, target: Vector2, rotation: f32, zoom: f32 }

extern fn InitWindow(width: i32, height: i32, title: const u8[:]);
extern fn WindowShouldClose() -> bool;
extern fn CloseWindow();
extern fn SetTargetFPS(fps: i32);
extern fn BeginDrawing();
extern fn EndDrawing();
extern fn ClearBackground(color: Color);
extern fn DrawLine(startPosX: i32, startPosY: i32, endPosX: i32, endPosY: i32, color: Color);
extern fn DrawRectangleRec(rec: Rectangle, color: Color);
extern fn DrawRectangleLinesEx(rec: Rectangle, lineThick: i32, color: Color);
extern fn DrawCircle(centerX: i32, centerY: i32, radius: f32, color: Color);
extern fn DrawText(text: const u8[:], posX: i32, posY: i32, fontSize: i32, color: Color);
extern fn MeasureText(text: const u8[:], fontSize: i32) -> i32;
extern fn IsKeyDown(key: i32) -> bool;
extern fn IsKeyPressed(key: i32) -> bool;

fn main() {
    InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "Pong (Goose + raylib)");

    // Spieler (rechts) und KI (links) Schläger
    let paddle_w: f32 = 15.0;
    let paddle_h: f32 = 80.0;
    let paddle_speed: f32 = 5.0;

    var left_x: f32 = 30.0;
    var left_y: f32 = (SCREEN_HEIGHT as f32 - paddle_h) / 2.0;
    var left_score: i32 = 0;

    var right_x: f32 = (SCREEN_WIDTH as f32) - 30.0 - paddle_w;
    var right_y: f32 = (SCREEN_HEIGHT as f32 - paddle_h) / 2.0;
    var right_score: i32 = 0;

    // Ball
    var ball_x: f32 = (SCREEN_WIDTH as f32) / 2.0;
    var ball_y: f32 = (SCREEN_HEIGHT as f32) / 2.0;
    var ball_r: f32 = 8.0;
    var ball_dx: f32 = 4.0;
    var ball_dy: f32 = 3.0;

    SetTargetFPS(TARGET_FPS);

    while !WindowShouldClose() {
        // --- Eingabe: rechter Schläger (Spieler) ---
        if IsKeyDown(KEY_W) { right_y = right_y - paddle_speed; }
        if IsKeyDown(KEY_S) { right_y = right_y + paddle_speed; }
        if IsKeyPressed(KEY_Q) || IsKeyPressed(KEY_ESCAPE) { break; }

        // Schläger in Grenzen halten
        if right_y < 0.0 { right_y = 0.0; }
        if right_y + paddle_h > (SCREEN_HEIGHT as f32) { right_y = (SCREEN_HEIGHT as f32) - paddle_h; }

        // --- KI: linker Schläger folgt dem Ball ---
        let ai_center = left_y + paddle_h / 2.0;
        if ball_y < ai_center - 5.0 {
            left_y = left_y - paddle_speed * 0.8;
        } else if ball_y > ai_center + 5.0 {
            left_y = left_y + paddle_speed * 0.8;
        }
        if left_y < 0.0 { left_y = 0.0; }
        if left_y + paddle_h > (SCREEN_HEIGHT as f32) { left_y = (SCREEN_HEIGHT as f32) - paddle_h; }

        // --- Ball bewegen ---
        ball_x = ball_x + ball_dx;
        ball_y = ball_y + ball_dy;

        // Oben/unten prallen
        if ball_y - ball_r <= 0.0 {
            ball_y = ball_r;
            ball_dy = -ball_dy;
        }
        if ball_y + ball_r >= (SCREEN_HEIGHT as f32) {
            ball_y = (SCREEN_HEIGHT as f32) - ball_r;
            ball_dy = -ball_dy;
        }

        // Kollision linker Schläger
        if ball_x - ball_r <= left_x + paddle_w &&
           ball_x + ball_r >= left_x &&
           ball_y + ball_r >= left_y &&
           ball_y - ball_r <= left_y + paddle_h &&
           ball_dx < 0.0 {
            ball_dx = -ball_dx * 1.05;
            ball_dy = ball_dy + ((ball_y - (left_y + paddle_h / 2.0)) / (paddle_h / 2.0)) * 2.0;
            ball_x = left_x + paddle_w + ball_r;
        }

        // Kollision rechter Schläger
        if ball_x + ball_r >= right_x &&
           ball_x - ball_r <= right_x + paddle_w &&
           ball_y + ball_r >= right_y &&
           ball_y - ball_r <= right_y + paddle_h &&
           ball_dx > 0.0 {
            ball_dx = -ball_dx * 1.05;
            ball_dy = ball_dy + ((ball_y - (right_y + paddle_h / 2.0)) / (paddle_h / 2.0)) * 2.0;
            ball_x = right_x - ball_r;
        }

        // Tore
        if ball_x < 0.0 {
            right_score = right_score + 1;
            ball_x = (SCREEN_WIDTH as f32) / 2.0;
            ball_y = (SCREEN_HEIGHT as f32) / 2.0;
            ball_dx = 4.0;
            ball_dy = 3.0;
        }
        if ball_x > (SCREEN_WIDTH as f32) {
            left_score = left_score + 1;
            ball_x = (SCREEN_WIDTH as f32) / 2.0;
            ball_y = (SCREEN_HEIGHT as f32) / 2.0;
            ball_dx = -4.0;
            ball_dy = -3.0;
        }

        // --- Rendern ---
        BeginDrawing();
        ClearBackground(BLACK);

        // Mittellinie
        var i: i32 = 0;
        while i < SCREEN_HEIGHT {
            DrawLine(SCREEN_WIDTH / 2, i, SCREEN_WIDTH / 2, i + 15, LIGHTGRAY);
            i = i + 30;
        }

        // Schläger
        DrawRectangleRec(Rectangle { left_x, left_y, paddle_w, paddle_h }, WHITE);
        DrawRectangleRec(Rectangle { right_x, right_y, paddle_w, paddle_h }, WHITE);

        // Ball
        DrawCircle(ball_x as i32, ball_y as i32, ball_r, WHITE);

        // Punkte
        DrawText("0", (SCREEN_WIDTH / 2 - 60), 30, 40, WHITE);
        DrawText("0", (SCREEN_WIDTH / 2 + 20), 30, 40, WHITE);

        EndDrawing();

        // Spielende bei 5 Punkten
        if left_score >= 5 || right_score >= 5 {
            break;
        }
    }

    CloseWindow();
}
