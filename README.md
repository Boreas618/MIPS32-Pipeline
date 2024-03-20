# Introduction
This project helps you to get started with Loongson Cup. 
However, this tutorial is **not as detailed as** the original software lab.
Most of the knowledge should be **learned by yourself**.

Please use **Linux** system. You can use either a virtual machine or docker.
The following tutorial is based on Ubuntu 22.04.

Install dependencies:
```bash
sudo apt update
sudo apt install build-essential verilator
```

Compile the project:
```bash
make
```

Run the project:
```bash
make run
```
Now you can see this:
```
  _____ ____
 |  ___|  _ \  ___ _ __  _   _
 | |_  | | | |/ __| '_ \| | | |
 |  _| | |_| | (__| |_) | |_| |
 |_|   |____/ \___| .__/ \__,_|
                  |_|
FDU debugger start...
(fdb)
```
You can try `n, r, b, p, q` to control the debugger, very similar to gdb.
We prepared a very simple CPU with a very simple self-defined ISA to show you how to use verilator, you can find it in `vsrc/top.v`.


To clean compiled files:
```bash
make clean
```

# Your mission
Build a 5-stage pipelined `MIPS32` or `LoongArch32` CPU, which support every unpreviledged instruction that the contest requires.
You can use `(system) verilog` or `chisel`.

What's more, every instruction should have its corresponding test. Integration tests are also needed.
You should load tests from `bin` or `elf` format files instead of putting them in the memory ahead of time, so that you can write some code to run tests one by one automatically.

An example in `tests` directory shows how to create `bin` format file on x86_64 systems. MIPS and LoongArch are similar. Your tests should not be linked to the standard libraries.

You may want to improve the debugger, Makefile or anything else in this process.

Good luck to you!

# Other things that may help
## How to ask questions
**You must read this before starting your lab:** 
https://lug.ustc.edu.cn/wiki/doc/smart-questions/

## MIPS
Install cross-compile toolchain for MIPS:
``` bash
sudo apt install gcc-mips-linux-gnu
sudo apt install binutils-mips-linux-gnu
```
MIPS specification: https://mips.com/products/architectures/mips32-2/

## LoongArch
Install cross-compile toolchain for LoongArch: https://github.com/loongson/build-tools/releases/tag/2023.08.08

LoongArch specification: https://loongson.github.io/LoongArch-Documentation/README-EN.html

## Verilator
Verilator user's guide: https://verilator.org/guide/latest/

## Learn Verilog
USTC Verilog OJ: https://verilogoj.ustc.edu.cn/oj/problempage/1
