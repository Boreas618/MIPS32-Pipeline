#!/bin/python3

import sys
import subprocess

GREEN = "\033[92m"
RED = "\033[91m"
NORMAL = "\033[0m"

if __name__ == "__main__":
    tests = [
        ("./tests/jr/jr.bin", 'JUMP'),
        ("./tests/bitwise/bitwise.bin", 'BITWISE'),
        ("./tests/addiu/addiu.bin", 'IMM'),
        ("./tests/addu/addu.bin", 'OPs'),
        ("./tests/load_store/load_store.bin", 'LOAD_STORE'),
        ("./tests/branch/branch.bin", 'BRANCH'),
        ("./tests/lui/lui.bin", 'LUI'),
        ("./tests/quick_sort/quick_sort.bin", 'QSORT')
    ]
    good = True
    
    for i, (t, n) in enumerate(tests):
        cmd = sys.argv[1] + " " + t
        p = subprocess.Popen(cmd, shell=True, stdout=subprocess.DEVNULL)
        p.wait()
        if p.returncode != 0:
            print(RED + f"[FAILED]\tTEST{i+1}-{n} ." + NORMAL)
            good = False
            break
        else:
            print(GREEN + f"[OK]    \tTEST{i+1}-{n}." + NORMAL)

    if good:
        print(GREEN + "ACCEPTED." + NORMAL)
