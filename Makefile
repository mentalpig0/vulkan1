CXX := g++
CXXFLAGS := -std=c++17 -O2 -Wall -Wextra -Wpedantic -Wconversion
LDFLAGS := -lglfw -lvulkan -ldl -lpthread -lX11 -lXxf86vm -lXrandr -lXi

TARGET := main
BUILD_DIR := build
SRC_DIR := .
SHADER_DIR := shaders

SOURCES := $(wildcard $(SRC_DIR)/*.cpp)
OBJECTS := $(SOURCES:$(SRC_DIR)/%.cpp=$(BUILD_DIR)/%.o)
SHADER_SOURCES := $(wildcard $(SHADER_DIR)/*.vert) $(wildcard $(SHADER_DIR)/*.frag)
SHADER_SPV := $(SHADER_SOURCES:$(SHADER_DIR)/%.$(suffix %)=$(SHADER_DIR)/%.spv)

DEPFLAGS = -MT $@ -MMD -MP -MF $(BUILD_DIR)/$*.d
DEPS := $(OBJECTS:.o=.d)

all: $(TARGET)

$(TARGET): $(OBJECTS) | $(SHADER_SPV)
	$(CXX) $(OBJECTS) -o $@ $(LDFLAGS)
	@echo "Build complete: $(TARGET)"

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.cpp | $(BUILD_DIR)
	$(CXX) $(DEPFLAGS) $(CXXFLAGS) -c $< -o $@

$(SHADER_DIR)/%.spv: $(SHADER_DIR)/% | $(SHADER_DIR)
	glslc $< -o $@

$(BUILD_DIR):
	@mkdir -p $@

-include $(DEPS)

run: $(TARGET)
	@echo "Running $(TARGET)..."
	./$(TARGET)

debug: CXXFLAGS += -g -DDEBUG -O0
debug: $(TARGET)

release: CXXFLAGS += -O3 -DNDEBUG
release: $(TARGET)

shaders: $(SHADER_SPV)
	@echo "Shaders compiled!"

clean:
	rm -rf $(BUILD_DIR) $(TARGET)
	@echo "Clean complete!"

deps:
	@echo "Installing dependencies..."
	sudo apt update
	sudo apt install -y libglfw3-dev libvulkan-dev vulkan-tools glslang-tools

info:
	@echo "Sources: $(SOURCES)"
	@echo "Target: $(TARGET)"
	@echo "Flags: $(CXXFLAGS)"

.PHONY: all run debug release shaders clean deps info