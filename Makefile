ECHO=/bin/echo
ECHO_N=/bin/echo -n
GIT=/usr/local/bin/git

all: build

clean:
	@rm -f [^_]*.html

build:
	@$(MAKE) `ls -1 *.md | sort | sed 's/\.md$$/\.html/'` || exit 1

upload: build upload_timestamp

docs: build docs_timestamp

archives:
	@loc=`cat repo_loc`; tag=`$(GIT) --git-dir="$$loc" tag -l | grep '^v2' | sort | tail -n 1`; \
	$(GIT) --git-dir="$$loc" archive --format=tar --prefix=tractor/ "$$tag" | gzip >tractor.tar.gz; \
	$(GIT) --git-dir="$$loc" archive --format=zip --prefix=tractor/ "$$tag" >tractor.zip; \
	echo "$$tag" >latest.txt

%.html: %.md _template.html build.rb
	@$(ECHO_N) "Building $@... "
	@./build.rb $< >$@ || ( rm -f $@; exit 1 )
	@$(ECHO) "done"

upload_timestamp: [^_]*.html *.css *.js *.png .htaccess tractor.tar.gz tractor.zip latest.txt
	@./upload.rb $? && touch upload_timestamp

docs_timestamp: [^_]*.html *.css *.js *.png
	@cp -v $? "`cat docs_target`/" && touch docs_timestamp
