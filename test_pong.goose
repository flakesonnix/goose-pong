// test_pong.goose — Unit-Test für Pong-Spiel-Logik (vereinfacht)

fn ball_hits_paddle(ball_x: i32, ball_y: i32, ball_r: i32,
                    paddle_x: i32, paddle_y: i32,
                    paddle_w: i32, paddle_h: i32) -> bool {
    if ball_x - ball_r <= paddle_x + paddle_w &&
       ball_x + ball_r >= paddle_x &&
       ball_y + ball_r >= paddle_y &&
       ball_y - ball_r <= paddle_y + paddle_h {
        return true;
    }
    return false;
}

fn main() {
    // Einfache direkte Prüfung der Bedingungen
    let bx = 45;
    let by = 200;
    let br = 8;
    let px = 30;
    let py = 160;
    let pw = 15;
    let ph = 80;

    let c1 = bx - br <= px + pw;   // 37 <= 45
    let c2 = bx + br >= px;        // 53 >= 30
    let c3 = by + br >= py;        // 208 >= 160
    let c4 = by - br <= py + ph;   // 192 <= 240

    assert(c1);
    assert(c2);
    assert(c3);
    assert(c4);

    assert(ball_hits_paddle(45, 200, 8, 30, 160, 15, 80));
    assert(!ball_hits_paddle(10, 200, 8, 30, 160, 15, 80));
    assert(ball_hits_paddle(763, 200, 8, 755, 160, 15, 80));
    assert(!ball_hits_paddle(45, 50, 8, 30, 160, 15, 80));
    assert(!ball_hits_paddle(45, 400, 8, 30, 160, 15, 80));

    assert(5 >= 5);
    assert(4 < 5);

    print("pong unit tests passed");
}
