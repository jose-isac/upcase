section .data
section .text
global _start
_start:
	mov rbp, rsp	; For correct debugging
	
ReadStdin:
	; Prepare to read from standard input
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

section .bss
	BufferSize: equ 128
	Buffer: resb BufferSize		; 128 bytes, then 128 characters
