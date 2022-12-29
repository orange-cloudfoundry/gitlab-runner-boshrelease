.PHONY: all clean
export

ROOT := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
WGETRC := $(ROOT)/.wgetrc


all:
	@$(MAKE) -C src $@

create-release:
	bosh create-release --force --dir=.

clean:
	@$(MAKE) -C src $@
