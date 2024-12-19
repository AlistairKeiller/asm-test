.data
buffer: .space 12  // Buffer to store the Fibonacci result as a string

.text
.global _start
_start:
    // fib(10)
    mov     x0, #10        // Argument for fib(10)
    bl      fib            // Call fib
    mov     x1, x0         // Store result in x1 for printing

    // Convert result to string
    ldr     x0, =buffer    // Load buffer address
    bl      int_to_str     // Convert integer in x1 to string

    // write(1, &buffer, len)
    mov     x0, #1         // stdout file descriptor
    ldr     x1, =buffer    // Address of buffer
    mov     x2, #12        // Maximum length for result string
    mov     w8, #64        // syscall: write
    svc     #0             // make syscall

    // _exit(0)
    mov     x0, #0         // status := 0
    mov     w8, #93        // exit is syscall #93
    svc     #0             // make syscall

// fib function: Computes Fibonacci number
fib:
    mov     x3, x0         // Store n in x3
    mov     x0, 0          // F(0) = 0
    mov     x1, 1          // F(1) = 1
    mov     x2, 0          // Counter
fib1:
    cmp     x2, x3         // Compare counter with n
    beq     1f             // If equal, exit loop
    add     x4, x0, x1     // F(n) = F(n-1) + F(n-2)
    mov     x0, x1         // Shift F(n-1) to F(n-2)
    mov     x1, x4         // Shift F(n) to F(n-1)
    add     x2, x2, 1      // Increment counter
    b       fib1           // Repeat loop
1:
    ret                    // Return F(n) in x0

// int_to_str: Converts an integer in x1 to a null-terminated string in x0
int_to_str:
    mov     x2, x0         // Save start of buffer
    add     x0, x0, #12    // Point to end of buffer
    mov     x3, #0         // Null terminator flag
int_to_str_loop:
    mov     x4, #10        // Load divisor 10
    udiv    x5, x1, x4     // Divide x1 by 10 (x5 = x1 / 10)
    msub    x6, x5, x4, x1 // Remainder = x1 - (x5 * 10)
    add     x6, x6, #'0'   // Convert to ASCII
    sub     x0, x0, #1     // Move pointer backward
    strb    w6, [x0]       // Store character
    mov     x1, x5         // Update x1 with quotient
    cbz     x1, int_to_str_done // If quotient is 0, end loop
    b       int_to_str_loop

int_to_str_done:
    mov     x1, x2         // Restore start of buffer
    ret
