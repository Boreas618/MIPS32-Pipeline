default: all

ROOT = $(abspath .)
CSRCS = $(shell find $(ROOT)/csrc -name "*.c" -o -name "*.cpp" -o -name "*.cc")
VSRCS = $(shell find $(ROOT)/vsrc -name "*.v")
TOPNAME = top
VERILATOR_FLAGS = -Wall --cc --exe --build --trace -O2 -Ivsrc
CFLAGS += -I$(ROOT)/csrc -I$(ROOT)/csrc/include
CFLAGS += $(shell llvm-config --cxxflags) -fPIE

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

run: $(BIN)
	$(BIN) $(ARGS) $(DIFF_ARGS) $(IMG)

clean:
	$(RM) -rf $(BUILD_DIR)
