ExitProcess PROTO
GetStdHandle PROTO
ReadConsoleA PROTO
WriteConsoleA PROTO

.data

std_out_handle QWORD ?
std_in_handle QWORD ?
prompt byte "Enter exit code: ",0
bytes_written QWORD ?
buffer byte 128 dup(?)
bytes_read QWORD ?

.code
main PROC
    sub rsp, 5 * 8             ; reserve shadow space

    ; Get std out handle
    mov rcx, -11
    call GetStdHandle

    mov std_out_handle, rax
    
    ; Write prompt to console
    mov rcx, rax
    lea rdx, prompt
    mov r8, LENGTHOF prompt - 1
    lea r9, bytes_written
    push 0
    call WriteConsoleA

    ; Get std in handle
    mov rcx, -10
    call GetStdHandle

    mov std_in_handle, rax

    ; Read input from console
    mov rcx, rax
    lea rdx, buffer
    mov r8, 128
    lea r9, bytes_read
    push 0
    call ReadConsoleA

    ; convert to int
    lea rsi, buffer
    mov rcx, bytes_read
    sub rcx, 2
    mov rax, 0      ; rax keeps track of the total sum
    mov rbx, 10     ; rbx is always 10, just used for multiplication
conv_loop:
    mul rbx         ; multiply the sum in rax by rbx (10) before adding the next digit
    add al, [rsi]   ; add the next digit to the lowest byte of rax
    sub al, '0'     ; subtract the value of '0' to get the int value of the digit
    inc rsi         ; point to the next digit
    dec rcx         ; decrease out counter
    jnz conv_loop   ; if the counter is not 0, continue looping

    mov rcx, rax                  ; uExitCode
    call ExitProcess

main ENDP
END
