## Copyright 2020 Marco Miretti <marco.miretti@gmail.com>
##
## Copying and distribution of this file, with or without modification,
## are permitted in any medium without royalty provided the copyright
## notice and this notice are preserved.  This file is offered as-is,
## without any warranty.

GREP ?= grep
CUT ?= cut
TR ?= tr

package := $(shell $(GREP) "^Name: " DESCRIPTION | $(CUT) -f2 -d" " | \
$(TR) '[:upper:]' '[:lower:]')
version := $(shell $(GREP) "^Version: " DESCRIPTION | $(CUT) -f2 -d" ")

target_dir       := target
version_dir      := $(package)-$(shell git rev-parse --short HEAD)
version_tarball  := $(target_dir)/$(package)-$(shell git rev-parse --short HEAD).tar.gz

.PHONY: version 

version:
	mkdir -p $(target_dir)
	git archive --format=tar --prefix=$(version_dir)/ HEAD | gzip >$(version_tarball)
