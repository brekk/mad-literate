BUILD_DIR := ./build
EXEC := madlit

$(BUILD_DIR)/$(EXEC):
	mkdir -p $(dir $@)
	echo "compiling! - 📚"
	madlib compile -i src/Cli.mad -t llvm -o $@
	echo "built! - 📗"

version.lock:
	madlib install

.PHONY: clean
clean:
	rm -r $(BUILD_DIR)
