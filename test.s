.text
.global _start
_start:
    mov     x0, #1    // stdout file descriptor
    ldr     x1, =msg  // address of "HELLO"
    ldr     x2, =len  // length of message
    mov     w8, #64   // syscall: write
    svc     #0        // make syscall
    mov     x0, #0    // status := 0
    mov     w8, #93   // exit is syscall #93
    svc     #0        // make syscall

fib:
    cmp x0,1              // Compare x0 with 1
    ble 1f                // Branch to label 1 if x0 <= 1
    stp x29,x30,[sp,-16]! // Store x29 and x30 on the stack and update the stack pointer
    sub x29,x0,2          // Set x29 to x0 - 2 (prepare for the second recursive call)
    sub x0,x0,1           // Decrement x0 by 1 (prepare for the first recursive call)
    bl fib                // Branch with link to fib (first recursive call)
    mov x1,x29            // Move the value of x29 to x1 (save the result of the second call)
    mov x29,x0            // Move the result of the first call to x29
    mov x0,x1             // Move the saved value (x29) back to x0
    bl fib                // Branch with link to fib (second recursive call)
    add x0,x0,x29         // Add the results of the two recursive calls
    ldp x29,x30,[sp],16   // Load x29 and x30 from the stack and update the stack pointer
1:
    ret                   // Return from the function

.data
msg:
    .ascii  "Hello, ARM64!\n"
len = . - msg
