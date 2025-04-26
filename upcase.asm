;--------------------------------------------------------------------------------------------------
; Source code name		: upcase.asm
; Executable name		: upcase
; Version			: 1.0
; Created data 			: 04/25/2025
; Last update			: 04/26/2025
; Author			: José Isac "Rasq" Araújo Monção
; Architecture			: Linux x64
; Assembler 			: NASM v2.16.01
; Description			: A program that changes the case of characters from standard
;				  input and return them to standard output.  
; Input				: Characters from standard in.
; Output			: The same characters but with upper case.
; Variables			: Buffer     -> Used to hold the characters.
;				  BufferSize -> Size of the buffer(128 bytes).
;				  r9	     -> Copy of the number of bytes read from stdin
;				  r8	     -> Copy of Buffer address
;				  r10 	     -> Copy of the number of bytes read from stdin used
;						as character index of Buffer.
;				  rax, rbx,
;				  rsi, rdx   -> For sys_write and sys_read system calls.
;				  
;---------------------------------------------------------------------------------------------------
section .data			; Section containing initialized data
section .text			; Section containing instructions
global _start			; Necessary for the linker
_start:
	mov rbp, rsp		; For correct debugging


; Read from standard input
ReadStdin:
	mov rax, 0		; 0 = sys_read syscall 
	mov rdi, 0		; 0 = stdin file descriptor
	mov rsi, Buffer 	; Move buffer address to rsi
	mov rdx, BufferSize 	; Move number of bytes to read to rdx
	syscall

	cmp rax, 0		; If rax has 0 then it reached EOF(End of file)
	jz Exit			; So, jump to exit. Else:

	mov r9, rax		; Make a copy of the number of bytes read to r9 for later use
	mov r8, Buffer		; Make a copy of the buffer address to r8 for later use
	mov r10, rax		; Make a copy of the number of bytes read to r10 because r10
				; will be used as a counter.

	dec r10			; It'll start from the end of the buffer, so decrement by one
				; to prevent stepping in forbidden memory address.


; Scans the current char and if it's a lowercase character, convert it to uppercase.
ScanChar:
	cmp byte [r8 + r10], 'a'	; Compares the current character with 'a'.
	jb .NextChar			; If it's below, this means it's not a lowercase letter.
	cmp byte [r8 + r10], 'z'	; Compares the current character with 'z'.
	ja .NextChar			; If it's above, this means it's not a lowercase letter.
	
	sub byte [r8 + r10], 020h	; At this point it should have a lowercase letter, so convert
					; it to uppercase by subtracting its value for 020h. It's the
					; difference between an ASCII lowercase character and its
					; uppercase counterpart.


; Goes to the next character of the buffer.
.NextChar:
	cmp r10, 0			; If the counter's value is 0, then it's the last character.
	je WriteStdOut			; So, go to write it to stdout. Else:

	dec r10				; Decrements the counter by one to read the next character.
	jmp ScanChar			; Go back to scan it.


; Write the current buffer to standard out.
WriteStdOut:
	mov rax, 1 		; 1 = sys_write syscall.
	mov rdi, 1		; 1 = stdout file descriptor.
	mov rsi, Buffer		; Move the Buffer address to rsi.
	mov rdx, r9		; Move the number of bytes in the buffer to rdx.
	syscall
	jmp ReadStdin		; Go back to read another buffer with characters.


; Exits the program
Exit:
	mov rax, 60		; 60 = sys_exit syscall
	mov rdi, 0		; 0 = exit success return code
	syscall


section .bss			; Section containing unitialized data
	BufferSize: equ 128
	Buffer: resb BufferSize		; 128 bytes, then 128 characters
