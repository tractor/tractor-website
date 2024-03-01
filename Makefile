ECHO=/bin/echo
ECHO_N=/bin/echo -n
GIT=git
GIT_ARCHIVE=git-archive-all

all: build

clean:
	@rm -f [^_]*.html

build:
	@$(MAKE) `ls -1 *.md | sort | sed 's/\.md$$/\.html/'` || exit 1

upload: build upload_timestamp

docs: build docs_timestamp

archives:
	@wd=`pwd`; cd `cat repo_loc` || exit 1; \
	tag=`$(GIT) tag -l | grep '^v3' | sort | tail -n 1`; \
	branch=`$(GIT) rev-parse --abbrev-ref HEAD`; \
	$(GIT) checkout -q $$tag; \
	$(GIT) submodule update --init; \
	$(GIT_ARCHIVE) --prefix=tractor/ tractor.tar.gz && mv tractor.tar.gz "$$wd/"; \
	$(GIT_ARCHIVE) --prefix=tractor/ tractor.zip && mv tractor.zip "$$wd/"; \
	$(GIT) checkout -q $$branch; \
	echo "$$tag" >"$$wd/latest.txt"

install.html: install.md _template.html build.rb latest.txt
	@$(ECHO_N) "Building $@... "
	@./build.rb $< >$@ || ( rm -f $@; exit 1 )
	@$(ECHO) "done"

%.html: %.md _template.html build.rb
	@$(ECHO_N) "Building $@... "
	@./build.rb $< >$@ || ( rm -f $@; exit 1 )
	@$(ECHO) "done"

upload_timestamp: [^_]*.html *.png tractor.tar.gz tractor.zip latest.txt paper/* assets/*
	@./upload.rb $? && touch upload_timestamp

docs_timestamp: [^_]*.html *.png paper/* assets/*
	@./upload.rb -d $? && touch docs_timestamp
