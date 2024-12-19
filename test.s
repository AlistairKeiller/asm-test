.data
msg:
    .ascii  "Hello, ARM64!\n"
len = . - msg


.text
.global _start
_start:
    // write(1, &msg, len)
    mov     x0, #1    // stdout file descriptor
    ldr     x1, =msg  // address of "HELLO"
    ldr     x2, =len  // length of message
    mov     w8, #64   // syscall: write
    svc     #0        // make syscall

    // exit(0)
    mov     x0, #0    // status := 0
    mov     w8, #93   // exit is syscall #93
    svc     #0        // make syscall
