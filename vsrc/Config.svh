`ifndef __CONFIG_SVH__
`define __CONFIG_SVH__

`define TEXT_BASE 32'h1000
`define EXIT_ADDR `TEXT_BASE + 32'h8080
`define MAGIC_NUM 32'h12345
`define STACK_BASE 32'h8000
`define MEM_LATENCY 10

`endif
