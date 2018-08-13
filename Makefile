.DEFAULT_GOAL := build
.PHONY: dist

# Build everything
build:
	./pants test compile src::

dist:
	./pants bundle src::

# Preserves build cache
clean:
	@rm -rf airflow/
	@rm -rf dist/

# Requires long build
clean-all: clean
	@./pants clean-all
	@rm -rf .pants.d/ .cache/ .pids/
	@rm -f .pants.workdir.file_lock
