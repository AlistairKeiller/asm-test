.data
msg:
    .ascii  "HELLO"
.text
.global _start
_start:
    mov     x0, #1      /* stdout file descriptor */
    ldr     x1, =msg    /* address of "HELLO" */
    mov     x2, #5      /* length of message */
    mov     w8, #64     /* syscall: write */
    svc     #0          /* make syscall */
    mov     x0, #0      /* status := 0 */
    mov     w8, #93     /* exit is syscall #93 */
    svc     #0