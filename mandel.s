.data
star: .ascii "*"
star_len = . - star
space:  .ascii " "
space_len = . - space
newline: .ascii "\n"
newline_len = . - newline
width = 60
height = 20
scale_x: .double 0.03
scale_y: .double 0.1
offset_x: .double -2.0
offset_y: .double -1.0

.text
.global _start
_start:
    // mandelbrot()
    bl mandelbrot

    // _exit(0)
    mov     x0, #0
    mov     w8, #93
    svc     #0

mandelbrot:
    mov x3, 0 // current_height
    mov x4, 0 // current_width
    ldr d4, =scale_x            // Load scale_x into d4
    ldr d5, =scale_y            // Load scale_y into d5
    ldr d6, =offset_x           // Load offset_x into d6
    ldr d7, =offset_y           // Load offset_y into d7
mandelbrot_loop:
    // if (x3 >= height) mandelbrot_done();
    cmp x3, height
    bge mandelbrot_done

    // if (x4 >= width) { mandelbrot_next_line() }
    cmp x4, width
    bge mandelbrot_next_line

    // render
    b mandelbrot_render
mandelbrot_render:
    // d0 = (double)x4 * scale_x + offset_x
    // d1 = (double)x3 * scale_y + offset_y
    scvtf d0, x4
    scvtf d1, x3
    fdiv d0, d0, d4
    fdiv d1, d1, d5
    fadd d0, d0, d6
    fadd d1, d1, d7

    mov     x0, #1
    ldr x1, =star
    ldr x2, =star_len
    mov     w8, #64
    svc     #0

    // x4 += 1
    add x4, x4, 1
    b mandelbrot_loop
// return;
mandelbrot_done:
    ret
// x4 = 0; x3++; putchar('\n');
mandelbrot_next_line:
    mov x4, 0
    add x3, x3, 1

    mov     x0, #1
    ldr x1, =newline
    ldr x2, =newline_len
    mov     w8, #64
    svc     #0

    b mandelbrot_loop