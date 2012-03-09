ECHO=/bin/echo
ECHO_N=/bin/echo -n

all: build

clean:
	@rm -f `find . -name '*.html' -print`

build:
	@$(MAKE) `find . -name '*.md' -print | sort | sed 's/\.md$$/\.html/'` || exit 1

upload: build upload_timestamp

%.html: %.md _template.html build.rb
	@$(ECHO_N) "Building $@... "
	@./build.rb $< >$@
	@$(ECHO) "done"

upload_timestamp: [^_]*.html *.css *.js *.png .htaccess
	@scp $? `cat upload_target` && touch upload_timestamp
