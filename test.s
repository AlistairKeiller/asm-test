.text
.global _start
_start:
    mov     x0, #1      /* stdout file descriptor */
    ldr     x1, =msg    /* address of "HELLO" */
    ldr     x2, =len    /* length of message */
    mov     w8, #64     /* syscall: write */
    svc     #0          /* make syscall */
    mov     x0, #0      /* status := 0 */
    mov     w8, #93     /* exit is syscall #93 */
    svc     #0          /* make syscall */

fib:
    cmp x0,1
    ble 1f
    stp x29,x30,[sp,-16]!
    sub x29,x0,2
    sub x0,x0,1
    bl fib
    mov x1,x29
    mov x29,x0
    mov x0,x1
    bl fib
    add x0,x0,x29
    ldp x29,x30,[sp],16
1:
    ret

.data
msg:
    .ascii  "Hello, ARM64!\n"
len = . - msg
