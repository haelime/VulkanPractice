# Detect operating system
UNAME := $(shell uname)

# Compiler
CXX = g++

# Compiler flags
CXXFLAGS = -std=c++20

# Vulkan SDK path (to be overridden per OS)
ifeq ($(UNAME), Darwin) # macOS
    VULKAN_SDK_PATH = /Users/hae/VulkanSDK/1.3.290.0
    INCLUDES = -I"$(VULKAN_SDK_PATH)/macOS/include" \
               -I/opt/homebrew/Cellar/glfw/3.4/include \
               -I/opt/homebrew/Cellar/glm/1.0.1/include \
               -I./include
    LIBS = -L"$(VULKAN_SDK_PATH)/macOS/lib" \
           -L/opt/homebrew/Cellar/glfw/3.4/lib \
           -lglfw -lvulkan \
           -framework Cocoa -framework OpenGL -framework IOKit -framework CoreVideo\
           -Wl,-rpath,$(VULKAN_SDK)/macOS/lib

    GLSLC = $(VULKAN_SDK_PATH)/macOS/bin/glslc

else ifeq ($(UNAME), Linux) # Linux
    VULKAN_SDK_PATH = $(VULKAN_SDK) # Ensure Vulkan SDK is in your environment
    INCLUDES = -I$(VULKAN_SDK_PATH)/include \
               -I/usr/include/glfw \
               -I./include
    LIBS = -L$(VULKAN_SDK_PATH)/lib \
           -lglfw -lvulkan -lX11 -lXxf86vm -lXrandr -lXi -ldl -lpthread -lXinerama -lXcursor
    GLSLC = $(VULKAN_SDK_PATH)/bin/glslc

else ifeq ($(UNAME), MINGW64_NT) # Windows (MinGW or MSYS)
    VULKAN_SDK_PATH = C:/VulkanSDK/1.3.290.0
    INCLUDES = -I"$(VULKAN_SDK_PATH)/Include" \
               -I"C:/msys64/mingw64/include" \
               -I./include
    LIBS = -L"$(VULKAN_SDK_PATH)/Lib" \
           -L"C:/msys64/mingw64/lib" \
           -lglfw3 -lvulkan-1 \
           -lgdi32 -luser32 -lkernel32 -lwinmm
    GLSLC = $(VULKAN_SDK_PATH)/Bin/glslc.exe

else
    $(error Unsupported OS: $(UNAME))
endif

# Source files
SRCS = ./src/main.cpp \
       ./src/FirstApp.cpp \
       ./src/VestaWindow.cpp \
       ./src/VestaPipeline.cpp \
       ./src/VestaDevice.cpp \
       ./src/VestaSwapChain.cpp \
       ./src/HelloTriangleApplication.cpp

OBJS = $(SRCS:.cpp=.o)

# Output executable name
TARGET = ./build/scop

# Shader files
VERT_SHADER = $(wildcard ./shader/*.vert)
FRAG_SHADER = $(wildcard ./shader/*.frag)
VERT_SPV = $(VERT_SHADER:.vert=.vert.spv)
FRAG_SPV = $(FRAG_SHADER:.frag=.frag.spv)

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
	$(CXX) $^ -o $@ $(LIBS) $(CXXFLAGS) $(INCLUDES)

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
