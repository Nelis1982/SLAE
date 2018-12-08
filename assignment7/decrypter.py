#!/usr/bin/env python

import pyaes


key = "b33rb44rb55rb66rb77rb88rb99rb00r"
aes = pyaes.AESModeOfOperationCTR(key)
with open("body") as file:
 shellcode = eval('str("' + file.read().strip() + '")')
#shellcode = "\xa6\x75\x5f\x46\x11\xe7\x61\x55\x1a\x04\xeb\xd3\x7b\x1d\xa4\x45\x4f\xca\xcc\x55\xe3\xff\xaa\xef\xcf\x57\x98\x38\xe3\x5b\x51\x78\x11\xbb\x37\x33\x7d"

shellcodedec = aes.decrypt(shellcode)
shellcodedec2 = ""
for x in bytearray(shellcodedec) :
	shellcodedec2 += '\\x'
        shellcodedec2 += '%02x' % x
print "Decrypted Shellcode: "+ shellcodedec2
f = open("bodydec","w")
f.write("\"" + shellcodedec2 + "\"")
f.close



