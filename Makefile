VERSION := $(shell cat .version )

PROGNAME = postfix_bexporter
PROGNAME_VERSION = $(PROGNAME)-$(VERSION)
TARGZ_FILENAME = $(PROGNAME)-$(VERSION).tar.gz
TARGZ_CONTENTS = postfix_bexporter.sh README.md Makefile version.sh

PREFIX = /opt/postfix_bexporter

.PHONY: all version build clean install

$(TARGZ_FILENAME):
	tar -zvcf "$(TARGZ_FILENAME)" "$(PROGNAME_VERSION)"


build:
	mkdir -vp "$(PROGNAME_VERSION)"
	cp -v $(TARGZ_CONTENTS) "$(PROGNAME_VERSION)/"
	sed -i "" -e "s/VERSION=.*/VERSION='$(VERSION)'/" "$(PROGNAME_VERSION)/postfix_bexporter.sh"

compress: $(TARGZ_FILENAME)

version:
	@echo "Version: $(VERSION)"

clean:
	rm -vfr "$(PROGNAME_VERSION)"
	rm -vf "$(TARGZ_FILENAME)"

install:
	install -d $(DESTDIR)$(PREFIX)
	install -m 644 postfix_bexporter.sh $(DESTDIR)$(PREFIX)
	install -m 644 README.md $(DESTDIR)$(PREFIX)
	
