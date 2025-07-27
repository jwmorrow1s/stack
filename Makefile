## All targets are expected to depend upon a .scm file in the root directory of the project
TARGETS = hello hello-test
CC = gcc
## The build artifacts directory
ARTIFACTS_DIR=$(PWD)/artifacts
## The location of all byte-compiled .scm (.go or Guile Object) files
COMPILED_DIR=$(ARTIFACTS_DIR)/compiled
## The location of created executables
EXE_DIR=$(ARTIFACTS_DIR)/exe
## this variable is necessary for guile to know where to look for .go (guile object) files
export GUILE_LOAD_COMPILED_PATH := $(COMPILED_DIR)
## this variable is necessary for guile to know where to look for .scm files
export GUILE_LOAD_PATH := $(ARTIFACTS_DIR)

## this meta-recipe builds a target for each target that creates an executable of the name of the target
##   it does this by compiling a c file (generated below) that links libguile and initializes scheme with the contents 
##   of the $target .scm file
$(foreach t,$(TARGETS),\
	$(eval $(t):make-exe-dir make-artifacts-dir $(ARTIFACTS_DIR)/$(t).c $(COMPILED_DIR)/$(t).go $(t).scm; @$(CC) -o $(EXE_DIR)/$(t) $(ARTIFACTS_DIR)/$(t).c $(shell guile-config compile) $(shell guile-config link))\
)

# TODO: do a build-%:

all: $(TARGETS)

# TODO: add build-%
.PHONY: all clean run-% make-artifacts-dir make-exe-dir

make-artifacts-dir:
	@test -d $(ARTIFACTS_DIR) || mkdir $(ARTIFACTS_DIR)
make-exe-dir: make-artifacts-dir
	@test -d $(EXE_DIR) || mkdir $(EXE_DIR)

## This recipe creates a .go (Guile Object) bytecode file for any target
$(COMPILED_DIR)/%.go: %.scm | make-artifacts-dir
	@guild compile -o $@ $< 

## This recipe creates a wrapper .c file for initializing the accompanying .scm file
##   the file generated here is considered a build artifiact
%.c: 
	@echo "#include<libguile.h>" > $@
	@echo "static void inner_main(void *data, int _argc, char **_argv) {" >> $@
	@echo "  (void) _argc;" >> $@
	@echo "  (void) _argv;" >> $@
	@echo '  scm_c_use_module("$(notdir $(basename $@))");' >> $@
	@echo "}" >> $@
	@echo "int main(int argc, char **argv) {" >> $@
	@echo "  scm_boot_guile(argc, argv, inner_main, NULL);" >> $@
	@echo "  return 0;" >> $@
	@echo "}" >> $@

## This utility recipe just invokes the build executable designated by the target
##   it brings in the GUILE_LOAD_PATH and GUILE_LOAD_COMPILED_PATH
run-%:
	@GUILE_LOAD_PATH=$(GUILE_LOAD_PATH) GUILE_LOAD_COMPILED_PATH=$(GUILE_LOAD_COMPILED_PATH) $(EXE_DIR)/$*

## This utility recipe cleans up anything made by the build commands
clean:
	@rm -rf $(ARTIFACTS_DIR)
