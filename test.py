#!/bin/python3

import sys
import subprocess

GREEN = "\033[92m"
RED = "\033[91m"
NORMAL = "\033[0m"

if __name__ == "__main__":
    tests = [
        "./tests/jr/jr.bin",
        "./tests/bitwise/bitwise.bin",
        "./tests/addiu/addiu.bin",
        "./tests/addu/addu.bin",
        "./tests/load_store/load_store.bin",
        "./tests/branch/branch.bin",
        "./tests/lui/lui.bin"
    ]
    good = True
    
    for i, t in enumerate(tests):
        cmd = sys.argv[1] + " " + t
        p = subprocess.Popen(cmd, shell=True, stdout=subprocess.DEVNULL)
        p.wait()
        if p.returncode != 0:
            print(RED + f"TEST{i} FAILED." + NORMAL)
            good = False
            break
        else:
            print(GREEN + f"TEST{i} OK." + NORMAL)

    if good:
        print(GREEN + "ACCEPTED." + NORMAL)
