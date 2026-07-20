BUILD_DIR := ./build
SOURCES := ./src
EXEC := madlit

DEPS := $(foreach dir, $(SOURCES), $(wildcard $(dir)/*))

$(BUILD_DIR)/$(EXEC): $(DEPS)
	mkdir -p $(dir $@)
	echo "compiling! - 📚"
	madlib compile -i src/Cli.mad -t llvm -o $@
	echo "built! - 📗"

version.lock:
	madlib install

.PHONY: clean
clean:
	rm -r $(BUILD_DIR)
