ROOT = ../

include $(ROOT)tdp_build/gmake/uc/common.pri

# Bring in project wide config
include $(ROOT)project.inc
include $(ROOT)$(PROJECT_DIR)/project.conf

# Bring in the dependencies tree 
include dependencies.pri
include $(ROOT)tdp_build/gmake/parse_dependencies.pri

# Bring in the source files for this module
include vars.pri

#Sort to remove duplicates
BUILD_DIRS = $(sort $(addprefix $(ROOT)$(BUILD_DIR)$(TARGET)/,$(dir $(SOURCES))))

DEFINES  := $(foreach DEFINE,$(DEFINES),-D$(DEFINE))
INCLUDES += $(foreach INCLUDE,$(INCLUDEPATHS),-I../$(INCLUDE))

SOBJECTS = $(filter %.o,$(SOURCES:.S=.S.o))
CCOBJECTS = $(filter %.o,$(SOURCES:.c=.c.o))
CXXOBJECTS = $(filter %.o,$(SOURCES:.cpp=.cpp.o))

all: $(BUILD_DIRS) $(ROOT)$(BUILD_DIR)$(TARGET).a

$(ROOT)$(BUILD_DIR)$(TARGET).a: $(addprefix $(ROOT)$(BUILD_DIR)$(TARGET)/,$(SOBJECTS)) $(addprefix $(ROOT)$(BUILD_DIR)$(TARGET)/,$(CCOBJECTS)) $(addprefix $(ROOT)$(BUILD_DIR)$(TARGET)/,$(CXXOBJECTS))
	"$(AR)" rcs $@ $^
	"$(NM)" $@ > $@.txt

$(ROOT)$(BUILD_DIR)$(TARGET)/%.S.o: %.S $(ASM_PART)
	"$(CPP)" $(INCLUDES) $(DEFINES) $< > $@.s
	"$(CC)" -c $(CFLAGS) $(CCFLAGS) $(INCLUDES) $(DEFINES) $@.s -o $@

$(ROOT)$(BUILD_DIR)$(TARGET)/%.c.o: %.c
	"$(CC)" -c $(CFLAGS) $(CCFLAGS) $(INCLUDES) $(DEFINES) $< -o $@

$(ROOT)$(BUILD_DIR)$(TARGET)/%.cpp.o: %.cpp
	"$(CXX)" -c $(CFLAGS) $(CXXFLAGS) $(INCLUDES) $(DEFINES) $< -o $@

$(BUILD_DIRS):
	$(MKDIR) $@

