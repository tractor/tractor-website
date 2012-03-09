ECHO=/bin/echo
ECHO_N=/bin/echo -n

all: build

clean:
	@rm -f [^_]*.html

build:
	@$(MAKE) `ls -1 *.md | sort | sed 's/\.md$$/\.html/'` || exit 1

upload: build upload_timestamp

%.html: %.md _template.html build.rb
	@$(ECHO_N) "Building $@... "
	@./build.rb $< >$@
	@$(ECHO) "done"

upload_timestamp: [^_]*.html *.css *.js *.png .htaccess
	@./upload.rb $? && touch upload_timestamp
