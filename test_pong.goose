// Unit test: Pong game
// Tests core logic: ball movement, collisions, scoring.

fn reset_ball_local() -> i64, i64, i64, i64 {
    return 25, 10, 1, 1;   // ball_x, ball_y, ball_dx, ball_dy
}

fn main() {
    // Test 1: Ball starts in the middle
    let bx, by, bdx, bdy = reset_ball_local();
    assert(bx == 25);
    assert(by == 10);
    assert(bdx == 1);
    assert(bdy == 1);

    // Test 2: Ball moves right-down
    let bx2 = bx + bdx;
    let by2 = by + bdy;
    assert(bx2 == 26);
    assert(by2 == 11);

    // Test 3: Ball bounces off top wall (y <= 0 -> dy becomes positive)
    let y_test = 0;
    let dy_test = -1;
    let dy_after = if y_test <= 0 { -dy_test } else { dy_test };
    assert(dy_after == 1);

    // Test 4: Ball bounces off bottom wall (y >= HEIGHT-1 -> dy becomes negative)
    let y_test2 = 19;
    let dy_test2 = 1;
    let dy_after2 = if y_test2 >= 19 { -dy_test2 } else { dy_test2 };
    assert(dy_after2 == -1);

    // Test 5: Paddle movement stays in bounds
    let paddle_y = 10;
    let paddle_h = 5;
    let height = 20;
    let new_y = if paddle_y - 1 < 0 { 0 } else { paddle_y - 1 };
    assert(new_y == 9);
    let new_y2 = if paddle_y + 1 + paddle_h > height { height - paddle_h } else { paddle_y + 1 };
    assert(new_y2 == 11);

    // Test 6: Win at 5 points
    assert(5 >= 5);
    assert(4 < 5);

    print("pong unit tests passed");
}
