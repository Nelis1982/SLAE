#!/bin/bash

if [ ! -d "temp" ]; then
        mkdir temp
fi

if grep -q x00 body; then
  echo "WARNING !!!! Shellcode contains x00 value(s)"
  cat body
fi
echo "#include<stdio.h>" >> temp/shellcode.c
echo "#include<string.h>" >> temp/shellcode.c
echo "unsigned char code[] = \\" >> temp/shellcode.c
cat bodydec >> temp/shellcode.c
echo ";" >> temp/shellcode.c
echo "main()" >> temp/shellcode.c
echo "{" >> temp/shellcode.c
echo "	printf(\"Press ENTER key to Continue\n\");" >> temp/shellcode.c
echo "	getchar();" >> temp/shellcode.c
echo "	printf(\"Payload shellcode Lenght: %d\\n\", strlen(code));" >> temp/shellcode.c
echo "	int (*ret)() = (int(*)())code;" >> temp/shellcode.c
echo "" >> temp/shellcode.c
echo "	ret();" >> temp/shellcode.c
echo "" >> temp/shellcode.c
echo "}" >> temp/shellcode.c

mv temp/shellcode.c .
gcc -fno-stack-protector -z execstack shellcode.c -o shellcode

#rm -rf temp/*

echo '[+] Done!'






