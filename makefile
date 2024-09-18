# Compiler
CXX = g++

# Compiler flags
CXXFLAGS = -std=c++20

# Vulkan SDK path
VULKAN_SDK = /Users/hae/VulkanSDK/1.3.290.0

# Include paths
INCLUDES = -I"$(VULKAN_SDK)/macOS/include" \
           -I/opt/homebrew/Cellar/glfw/3.4/include \
           -I/opt/homebrew/Cellar/glm/1.0.1/include \
           -I./include
           
# Library paths and libraries
LIBS = -L"$(VULKAN_SDK)/macOS/lib" \
       -L/opt/homebrew/Cellar/glfw/3.4/lib \
       -lglfw -lvulkan \
       -framework Cocoa -framework OpenGL -framework IOKit -framework CoreVideo

# Source files
SRCS = ./src/main.cpp \
       ./src/HelloTriangleApplication.cpp \

OBJS = $(SRCS:.cpp=.o)

# Output executable name
TARGET = ./build/scop

# Shader files
VERT_SHADER = shader/shader.vert
FRAG_SHADER = shader/shader.frag
VERT_SPV = shader/vert.spv
FRAG_SPV = shader/frag.spv
GLSLC = $(VULKAN_SDK)/macOS/bin/glslc

# Debug flags
DEBUG_FLAGS = -g -DDEBUG

# Release flags
RELEASE_FLAGS = -O3 -DNDEBUG

# Default to release mode
MODE ?= release

ifeq ($(MODE),debug)
    CXXFLAGS += $(DEBUG_FLAGS)
    TARGET := $(TARGET)_debug
else
    CXXFLAGS += $(RELEASE_FLAGS)
endif

# Targets
all: compile_shaders $(TARGET)

# Create build directory if it doesn't exist and link objects
$(TARGET): $(OBJS)
	@mkdir -p $(@D)
	$(CXX) $^ -o $@ $(LIBS) -Wl,-rpath,$(VULKAN_SDK)/macOS/lib $(CXXFLAGS) $(INCLUDES)

# Compile source files into object files
%.o: %.cpp
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c $< -o $@

# Compile shaders
compile_shaders: $(VERT_SPV) $(FRAG_SPV)

$(VERT_SPV): $(VERT_SHADER)
	$(GLSLC) $< -o $@

$(FRAG_SPV): $(FRAG_SHADER)
	$(GLSLC) $< -o $@

# Debug and release targets
debug:
	$(MAKE) MODE=debug

release:
	$(MAKE) MODE=release

# Clean up
clean:
	rm -f $(OBJS) $(TARGET) $(TARGET)_debug shader/*.spv

# Rebuild
re: clean all

.PHONY: all debug release compile_shaders clean re
