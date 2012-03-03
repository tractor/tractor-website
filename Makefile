ECHO=/bin/echo
ECHO_N=/bin/echo -n

all: build

clean:
	@rm -f `find . -name '*.html' -print`

build:
	@$(MAKE) `find . -name '*.md' -print | sort | sed 's/\.md$$/\.html/'` || exit 1

%.html: %.md
	@$(ECHO_N) "Building $@... "
	@./build.rb $< >$@
	@$(ECHO) "done"
