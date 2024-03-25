#!/bin/python3

import sys
import subprocess

GREEN = "\033[92m"
RED = "\033[91m"
NORMAL = "\033[0m"

if __name__ == "__main__":
    tests = ["./tests/dummy.bin"]
    good = True
    
    for i, t in enumerate(tests):
        cmd = sys.argv[1] + " " + t
        p = subprocess.Popen(cmd, shell=True)
        p.wait()
        if p.returncode != 0:
            print(RED + f"TEST{i} FAILED." + NORMAL)
            good = False
            break
        else:
            print(GREEN + f"TEST{i} OK." + NORMAL)

    if good:
        print(GREEN + "ACCEPTED." + NORMAL)