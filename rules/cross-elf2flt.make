# -*-makefile-*-
#
# Copyright (C) 2012 by Michael Olbrich <m.olbrich@pengutronix.de>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
CROSS_PACKAGES-$(PTXCONF_CROSS_ELF2FLT) += cross-elf2flt

#
# Paths and names
#
CROSS_ELF2FLT_VERSION	:= 2020.09
CROSS_ELF2FLT_MD5	:= a3a688720de19f2d0883583729b7e093
CROSS_ELF2FLT		:= elf2flt-$(CROSS_ELF2FLT_VERSION)
CROSS_ELF2FLT_SUFFIX	:= tar.gz
CROSS_ELF2FLT_URL	:= https://github.com/uclinux-dev/elf2flt/archive/v$(CROSS_ELF2FLT_VERSION).$(CROSS_ELF2FLT_SUFFIX)
CROSS_ELF2FLT_SOURCE	:= $(SRCDIR)/$(CROSS_ELF2FLT).$(CROSS_ELF2FLT_SUFFIX)
CROSS_ELF2FLT_DIR	:= $(CROSS_BUILDDIR)/$(CROSS_ELF2FLT)
CROSS_ELF2FLT_LICENSE	:= GPL-2.0-or-later
CROSS_ELF2FLT_LICENSE_FILES := \
	file://LICENSE.TXT;md5=70b24024535d82748f378e597d52b84a

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#
# autoconf
#
CROSS_ELF2FLT_CONF_TOOL	:= autoconf
# HACK: add '-lz' because libbfd.a needs it and the Makefile adds it in the wrong order
CROSS_ELF2FLT_CONF_OPT	:= \
	$(PTX_HOST_CROSS_AUTOCONF) \
	--disable-werror \
	--with-binutils-include-dir=$(CROSS_BINUTILS_DIR)/include \
	--with-binutils-build-dir=$(CROSS_BINUTILS_BUILDDIR) \
	--with-libbfd="$(CROSS_BINUTILS_BUILDDIR)/bfd/libbfd.a -lz -ldl"

$(STATEDIR)/cross-elf2flt.install:
	@$(call targetinfo)
	@$(call world/install, CROSS_ELF2FLT)
	@for bin in $(CROSS_ELF2FLT_PKGDIR)$(PTXCONF_PREFIX_CROSS)/$(PTXCONF_GNU_TARGET)/bin/*; do \
		ln -vsf ../../bin/$(COMPILER_PREFIX)$$(basename $${bin}) $${bin} || break; \
	done
	@$(call touch)

# vim: syntax=make
