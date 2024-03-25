# Introduction
This project helps you to get started with Loongson Cup. 
However, this tutorial is **not as detailed as** the original software lab.
Most of the knowledge should be **learned by yourself**.

Please use the **Linux** system. You can use either a virtual machine (e.g., VMware) or docker.
The following tutorial is based on Ubuntu 22.04.

Install dependencies:
```bash
sudo apt update
sudo apt install build-essential verilator git python3
```

If you choose MIPS:
```bash
sudo apt install llvm-dev
```

If you choose LoongArch (MIPS chooser can also do this instead of using `apt` if you like):
```bash
sudo apt install cmake
git clone --depth 1 https://github.com/llvm/llvm-project.git
cd llvm-project
mkdir build
cd build
cmake ../llvm -DCMAKE_BUILD_TYPE=Release
cmake --build .
sudo cmake --build . --target install
```

Get the project:
```bash
# Please fork https://gitee.com/lsc2001/fdcpu.git first.
git clone https://gitee.com/your_gitee_account/fdcpu.git
cd fdcpu
# All your modifications should be made on branch "lab".
git checkout -b lab
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
You are using dummy ISA...
  _____ ____
 |  ___|  _ \  ___ _ __  _   _
 | |_  | | | |/ __| '_ \| | | |
 |  _| | |_| | (__| |_) | |_| |
 |_|   |____/ \___| .__/ \__,_|
                  |_|
Debug mode.
(fdb)
```

You can try `n, r, b, p, q` to control the debugger, very similar to gdb.
We prepared a very simple CPU with a very simple self-defined ISA to show you how to use verilator, you can find it in `vsrc/top.v`.

By default, it runs `tests/dummy.bin`. If you want to run with another image files, use `make run IMG=xxx` or change `IMG` in the Makefile.

To clean compiled files:
```bash
make clean
```

**Note:** After you convert the ISA to `MIPS32` or `LoongArch32`,
change `ARCH` to `mips` or `loongarch` in the Makefile.

# Your mission
Build a 5-stage pipelined `MIPS32` or `LoongArch32` **little-endian** CPU, which support every unpreviledged instruction that the contest requires. You can use `(system) verilog` or `chisel`.

You will use `verilator` to synthesize and simulate your RTL codes. However, in Loongson Cup you have to use vivado.
So it will take you some time to adapt your codes to vivado and the real FPGA before the competition.

Every instruction should have its corresponding test. Integration tests are also needed.
You should load tests from `bin` files instead of putting them in the memory ahead of time, so that you can write some code to run tests one by one automatically.

An example in `tests/demo` directory shows how to create `bin` format file on x86_64 systems. MIPS and LoongArch are similar.
Source codes of the tests should be included in your submission.

We don't distinguish lab1-labN and will judge your score based on what you've done according to the class PPT.
If you finish one of the extra tasks, you can get some bonus.

You may want to improve the debugger, Makefile or anything else in this process.

I am too lazy to do anything more, so welcome you to contribute to this project to help students of the next year.

Good luck to you!

# Submission
To submit your code, upload the url of your git branch on e-learning (https://gitee.com/your_gitee_account/fdcpu/tree/lab).
Your branch should also include a "your_student_number-your_name.md" (e.g., "12345-xxx.md"),
which describe how to run and test your lab, and the design and evaluation of your lab.

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
