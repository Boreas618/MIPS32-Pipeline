default: all

# ARCH can be dummy, mips or loongarch
ARCH = mips
IMG = $(abspath ./tests/beq/beq.bin)

ROOT = $(abspath .)
CSRCS = $(shell find $(ROOT)/csrc -name "*.c" -o -name "*.cpp" -o -name "*.cc")
VSRCS = $(shell find $(ROOT)/vsrc -name "*.v" -o -name "*.sv")
TOPNAME = Top
VERILATOR_FLAGS = -Wall --cc --exe --build --trace -O2 -Ivsrc
CFLAGS += -I$(ROOT)/csrc -I$(ROOT)/csrc/include
CFLAGS += -I$(shell llvm-config --includedir)
LDFLAGS += $(shell llvm-config --libs)

BUILD_DIR = $(ROOT)/build
OBJ_DIR = $(BUILD_DIR)/obj_dir
BIN = $(BUILD_DIR)/V$(TOPNAME)
$(shell mkdir -p $(BUILD_DIR))

all: $(BIN)

$(BIN): $(CSRCS) $(VSRCS)
	@verilator $(VERILATOR_FLAGS) \
		--top-module $(TOPNAME) $^ \
		$(addprefix -CFLAGS , $(CFLAGS)) \
		$(addprefix -LDFLAGS , $(LDFLAGS)) \
		-o $(abspath $(BIN)) --Mdir $(OBJ_DIR)

run: $(BIN) $(IMG)
	@ARCH=$(ARCH) $(BIN) --debug $(IMG)

test: $(BIN)
	@ARCH=$(ARCH) python3 ./test.py $(BIN)

clean:
	@$(RM) -rf $(BUILD_DIR)
