.data
msg:
    .ascii  "Hello, ARM64!\n"
len = . - msg

fib:
    mov x3, x0
    mov x0, 0
    mov x1, 1
    mov x2, 0
fib1:
    cmp x2, x3
    beq 1f
    mov x4, x0
    mov x0, x1
    add x1, x4, x1
    add x2, x2, 1
    b fib1
1:
    ret

.text
.global _start
_start:
    // write(1, &msg, len)
    mov     x0, #1    // stdout file descriptor
    ldr     x1, =msg  // address of "HELLO"
    ldr     x2, =len  // length of message
    mov     w8, #64   // syscall: write
    svc     #0        // make syscall

    // fib(10)
    mov     x0, #10
    bl      fib

    // _exit(0)
    mov     x0, #0    // status := 0
    mov     w8, #93   // exit is syscall #93
    svc     #0        // make syscall
