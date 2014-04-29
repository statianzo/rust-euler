DEFAULT = make lib

SOURCE_FILES = $(shell test -e src/ && find src -type f)

COMPILER = rustc

# For release:
# COMPILER_FLAGS = -O
# For debugging:
# COMPILER_FLAGS = -g

RUSTDOC = rustdoc 

TARGET = $(shell rustc --version | awk "/host:/ { print \$$2 }")
# TARGET = x86_64-unknown-linux-gnu
# TARGET = x86_64-apple-darwin 

TARGET_LIB_DIR = target/$(TARGET)/lib/

# Ask 'rustc' the file name of the library and use a dummy name if the source has not been created yet.
# The dummy file name is used to trigger the creation of the source first time.
# Next time 'rustc' will return the right file name.
RLIB_FILE = $(shell (rustc --crate-type=rlib --crate-file-name "src/lib.rs" 2> /dev/null) || (echo "dummy.rlib"))
# You can't have quotes around paths because 'make' doesn't see it exists.
RLIB = target/$(TARGET)/lib/$(RLIB_FILE)
DYLIB_FILE = $(shell (rustc --crate-type=dylib --crate-file-name "src/lib.rs" 2> /dev/null) || (echo "dummy.dylib"))
DYLIB = target/$(TARGET)/lib/$(DYLIB_FILE)

all:
	$(DEFAULT)

.PHONY: \
		clean \
		test

doc: $(SOURCE_FILES) | src/
	$(RUSTDOC) src/lib.rs -L "target/$(TARGET)/lib" \

bin:
	mkdir -p bin

test: test-internal

test-external: bin/test-external
	bin/test-external

bin/test-external: $(SOURCE_FILES) | rlib bin src/test.rs
	$(COMPILER) --target "$(TARGET)" $(COMPILER_FLAGS) --test src/test.rs -o bin/test-external -L "target/$(TARGET)/lib" \

test-internal: bin/test-internal
	bin/test-internal

bin/test-internal: $(SOURCE_FILES) | rlib src bin
	$(COMPILER) --target "$(TARGET)" $(COMPILER_FLAGS) --test src/lib.rs -o bin/test-internal -L "target/$(TARGET)/lib" \

lib: rlib dylib

rlib: $(RLIB)

$(RLIB): $(SOURCE_FILES) | src/lib.rs $(TARGET_LIB_DIR)
	$(COMPILER) --target "$(TARGET)" $(COMPILER_FLAGS) --crate-type=rlib src/lib.rs -L "target/$(TARGET)/lib" --out-dir "target/$(TARGET)/lib/" \

dylib: $(DYLIB)

$(DYLIB): $(SOURCE_FILES) | src/lib.rs $(TARGET_LIB_DIR)
	$(COMPILER) --target "$(TARGET)" $(COMPILER_FLAGS) --crate-type=dylib src/lib.rs -L "target/$(TARGET)/lib" --out-dir "target/$(TARGET)/lib/" \

$(TARGET_LIB_DIR):
	mkdir -p $(TARGET_LIB_DIR)

clean:
	rm -f "$(RLIB)"
	rm -f "$(DYLIB)"
	rm -rf "doc/"
	rm -f "bin/*"
