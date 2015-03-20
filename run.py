#!/usr/bin/env python

import sys, os

if len(sys.argv) == 1:
    os.system("qemu-system-i386 pong.img")
    exit(0)

if sys.argv[1] == "log":
    os.system("qemu-system-i386 -D log -d in_asm pong.img")
    exit(0)

if sys.argv[1] == "gdb":
    os.system("qemu-system-i386 -S -s pong.img")
    exit(0)

os.system("qemu-system-i386 pong.img")
