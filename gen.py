#!/usr/bin/env python3
import sys
from hashlib import sha3_512
from random import choice, seed
from string import ascii_letters

o=1
for i in sys.argv[1]:
    o=ord(i)*o
seed(int(sys.argv[2]) + o)
passwd=""
for i in range(200):
    passwd = passwd + choice(ascii_letters)
print(sha3_512(bytes(str(passwd+sys.argv[2]),"UTF-8")).hexdigest())
