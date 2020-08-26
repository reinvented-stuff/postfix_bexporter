include version.sh

PROGNAME = postfix_bexporter
PROGNAME_VERSION = $(PROGNAME)-$(version)
TARGZ_FILENAME = $(PROGNAME)-$(version).tar.gz
TARGZ_CONTENTS = postfix_bexporter.sh README.md Makefile version.sh

DESTDIR = /opt/postfix_bexporter

.PHONY: all version build clean install

$(TARGZ_FILENAME):
	tar -zvcf "$(TARGZ_FILENAME)" "$(PROGNAME_VERSION)"


build:
	mkdir -v "$(PROGNAME_VERSION)"
	cp -v $(TARGZ_CONTENTS) "$(PROGNAME_VERSION)/"
	sed -i "" -e "s/VERSION=.*/VERSION='$(version)'/" "$(PROGNAME_VERSION)/postfix_bexporter.sh"

compress: $(TARGZ_FILENAME)

version:
	@echo "Version: $(version)"

clean:
	cd "$(PROGNAME_VERSION)"
	rm -fv $(TARGZ_CONTENTS)
	cd ..
	rm -vf "$(PROGNAME_VERSION)"

install:
	install -d $(DESTDIR)
	install -m 644 postfix_bexporter.sh $(DESTDIR)
	install -m 644 README.md $(DESTDIR)
	
