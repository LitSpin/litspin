SHELL := /bin/bash

.PHONY = all yocto

all: yocto

yocto: dev apply-patches
	source poky/oe-init-build-env litbuild && bitbake litspin-image

dev:
	if ! [ -d "meta-aries" ]; then git clone https://github.com/ARIES-Embedded/meta-aries.git; fi
	if ! [ -d "poky" ]; then git clone -b thud git://git.yoctoproject.org/poky.git; fi
	if ! [ -d "meta-openembedded" ]; then git clone -b thud https://github.com/openembedded/meta-openembedded.git; fi


apply-patches: patch-aries


patch-aries: dev
	@if ! (grep -q litspin "meta-aries/conf/machine/mcvevk.conf"); then \
		cd meta-aries && git apply ../prebuild-patches/meta-aries/* && echo "Patches applied for meta-aries"; \
		else echo "Patches already applied for meta-aries"; \
	fi

clean:
	rm -rf meta-aries poky meta-openembedded litbuild/bitbake-cookerdaemon.log litbuild/cache litbuild/downloads litbuild/sstate-cache litbuild/tmp litbuild/conf/sanity_info litbuild/conf/templateconf.cfg

PHONY: clean
