.data
star: .ascii "*"
star_len = . - star
space:  .ascii " "
space_len = . - space
newline: .ascii "\n"
newline_len = . - newline
width = 40
height = 20
max_iter = 100
scale_x: .double 0.1
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
    // x3 = 0, x4 = 0
    mov x3, 0
    mov x4, 0

    // d4 = scale_x, d5 = scale_y, d6 = offset_x, d7 = offset_y
    fmov d4, #1.0// scale_x
    fmov d5, #1.0// scale_y
    fmov d6, #-2.0// =offset_x
    fmov d7, #-1.0// =offset_y

mandelbrot_loop:
    // if (x3 >= height) mandelbrot_done();
    cmp x3, height
    bge mandelbrot_done

    // if (x4 >= width) { mandelbrot_next_line() }
    cmp x4, width
    bge mandelbrot_next_line

    // d0 = (double)x4 * scale_x + offset_x
    // d1 = (double)x3 * scale_y + offset_y
    scvtf d0, x4
    scvtf d1, x3
    fmul d0, d0, d4
    fmul d1, d1, d5
    fadd d0, d0, d6
    fadd d1, d1, d7

    // d2 = 0.0, d3 = 0.0, w5=0
    fmov d2, xzr
    fmov d3, xzr
    mov w5, #0

mandelbrot_iter:
    cmp w5, max_iter
    bge mandelbrot_plot_space

    // (a+b*i)^2=(a^2-b^2)+2*a*b*i
    // d8 = d2*d2 - d3*d3 + d0
    fmul d8, d2, d2
    fmul d9, d3, d3
    fsub d8, d8, d9
    fadd d8, d8, d0
    // d9 = 2*d2*d3 + d1
    fmul d9, d2, d3
    fadd d9, d9, d9
    fadd d9, d9, d1

    // magnitude = d8*d8 + d9*d9
    fmul d10, d8, d8
    fmul d11, d9, d9
    fadd d10, d10, d11

    // if (magnitude > 4.0) { mandelbrot_plot_star(); }
    fmov d11, #4.0
    fcmp d10, d11
    bgt mandelbrot_plot_star

    // d2 = d8, d3 = d9
    fmov d2, d8
    fmov d3, d9

    // iter++
    add w5, w5, 1
    b mandelbrot_iter

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

mandelbrot_plot_star:
    mov     x0, #1
    ldr x1, =star
    ldr x2, =star_len
    mov     w8, #64
    svc     #0
    b mandelbrot_next_pixel

mandelbrot_plot_space:
    mov     x0, #1
    ldr x1, =space
    ldr x2, =space_len
    mov     w8, #64
    svc     #0

// x4 += 1
mandelbrot_next_pixel:
    add x4, x4, 1
    b mandelbrot_loop
