#!/bin/bash

if [ ! -d "old" ]; then
	mkdir old
fi

if [ ! -d "temp" ]; then
        mkdir temp
fi

stamp=`date '+%Y_%m_%d__%H_%M_%S'`;
cp $1.nasm old/$1$stamp.nasm

echo '[+] Assembling with Nasm ... '
nasm -f elf32 -o $1.o $1.nasm

echo '[+] Linking ...'
ld -o $1 $1.o

objdump -d ./$1|grep '[0-9a-f]:'|grep -v 'file'|cut -f2 -d:|cut -f1-7 -d' '|tr -s ' '|tr '\t' ' '|sed 's/ $//g'|sed 's/ /\\x/g'|paste -d '' -s |sed 's/^/"/'|sed 's/$/"/g' > temp/body
if grep -q x00 temp/body; then
  echo "WARNING !!!! Shellcode contains x00 value(s)"
  cat temp/body
fi
echo "#include<stdio.h>" >> temp/shellcode.c
echo "#include<string.h>" >> temp/shellcode.c
echo "unsigned char code[] = \\" >> temp/shellcode.c
cat temp/body >> temp/shellcode.c
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





