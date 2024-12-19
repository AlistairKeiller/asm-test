.data
star:
    .ascii "*"
star_len = . - star
space:
    .ascii " "
space_len = . - space
newline:
    .ascii "\n"
newline_len = . - newline
width = 60
height = 20

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
mandelbrot_loop:
    // if (x3 >= height) mandelbrot_done();
    cmp x3, height
    bge mandelbrot_done

    // if (x4 >= width) { mandelbrot_next_line() }
    cmp x4, width
    bge mandelbrot_next_line

    // x4 += 1
    add x4, x4, 1

    // render
    b mandelbrot_render
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
// putchar('*');
mandelbrot_render:
    mov     x0, #1
    ldr x1, =star
    ldr x2, =star_len
    mov     w8, #64
    svc     #0
    b mandelbrot_loop
// return;
mandelbrot_done:
    ret
