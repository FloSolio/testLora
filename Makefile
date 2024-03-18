# tool macros
CC := gcc
CCFLAGS := -Iincludes/ -I sx1302_hal/libloragw/inc/
DBGFLAGS := -g
LDFLAGS :=  -Lsx1302_hal/libloragw/
CCOBJFLAGS := $(CCFLAGS) -c
ARCH :=

# path macros
BIN_PATH := build-$(ARCH)/bin
OBJ_PATH := build-$(ARCH)/obj
SRC_PATH := src
DBG_PATH := build-$(ARCH)/debug

# compile macros
TARGET_NAME := LoraTest1
TARGET := $(BIN_PATH)/$(TARGET_NAME)
TARGET_DEBUG := $(DBG_PATH)/$(TARGET_NAME)

# src files & obj files
SRC := $(foreach x, $(SRC_PATH), $(wildcard $(addprefix $(x)/*,.c*)))
OBJ := $(addprefix $(OBJ_PATH)/, $(addsuffix .o, $(notdir $(basename $(SRC)))))
OBJ_DEBUG := $(addprefix $(DBG_PATH)/, $(addsuffix .o, $(notdir $(basename $(SRC)))))

# clean files list
DISTCLEAN_LIST := $(OBJ) \
					$(OBJ_DEBUG)

CLEAN_LIST := $(TARGET) \
				$(TARGET_DEBUG) \
				$(DISTCLEAN_LIST)

# default rule
default: makedir all

# non-phony targets
$(TARGET): $(OBJ)
	$(CC) $(CCFLAGS) -o $@ $(OBJ) $(LDFLAGS)

$(OBJ_PATH)/%.o: $(SRC_PATH)/%.c*
	$(CC) $(CCOBJFLAGS) -o $@ $<

$(DBG_PATH)/%.o: $(SRC_PATH)/%.c*
	$(CC) $(CCOBJFLAGS) $(DBGFLAGS) -o $@ $<

$(TARGET_DEBUG): $(OBJ_DEBUG)
	$(CC) $(CCFLAGS) -l src/sx1302_hal/libloragw/ $(DBGFLAGS) $(OBJ_DEBUG) -o $@ $(LDFLAGS)

# phony rules
.PHONY: makedir
makedir:
	@mkdir -p $(BIN_PATH) $(OBJ_PATH) $(DBG_PATH)

.PHONY: all
all: $(TARGET)

.PHONY: debug
debug: flo $(TARGET_DEBUG)

flo:
	$(MAKE) all -e -C src/sx1302_hal

.PHONY: clean
clean:
	@echo CLEAN $(CLEAN_LIST)
	@rm -f $(CLEAN_LIST)

.PHONY: distclean
distclean:
	@echo CLEAN $(CLEAN_LIST)
	@rm -f $(DISTCLEAN_LIST)
