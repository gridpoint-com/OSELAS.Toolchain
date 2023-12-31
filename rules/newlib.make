# -*-makefile-*-
#
# Copyright (C) 2007 by Sascha Hauer
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_NEWLIB) += newlib

#
# Paths and names
#
NEWLIB_VERSION	:= $(call remove_quotes,$(PTXCONF_NEWLIB_DL_VERSION))
NEWLIB_MD5	:= $(call remove_quotes,$(PTXCONF_NEWLIB_MD5))
NEWLIB		:= newlib-$(NEWLIB_VERSION)
NEWLIB_SUFFIX	:= tar.gz
NEWLIB_URL	:= https://sourceware.org/pub/newlib/$(NEWLIB).$(NEWLIB_SUFFIX)
NEWLIB_SOURCE	:= $(SRCDIR)/$(NEWLIB).$(NEWLIB_SUFFIX)
NEWLIB_DIR	:= $(BUILDDIR)/$(NEWLIB)
NEWLIB_BUILD_OOT:= YES

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

NEWLIB_PATH := PATH=$(CROSS_PATH)
NEWLIB_ENV := CC_FOR_BUILD=$(HOSTCC)

#
# autoconf
#
NEWLIB_CONF_TOOL	:= autoconf
NEWLIB_CONF_OPT		:= \
	--prefix= \
	--target=$(PTXCONF_GNU_TARGET) \
	--disable-shared \
	--disable-newlib-supplied-syscalls \
	--with-newlib

$(STATEDIR)/newlib.prepare:
	@$(call targetinfo)
#	# unknown options a propagated to newlib/configure
	@sed -i "s:^\(enable_option_checking\)=.*:\1=no:" \
		$(NEWLIB_DIR)/configure
	@$(call world/prepare, NEWLIB)
	@$(call touch)

# vim: syntax=make
