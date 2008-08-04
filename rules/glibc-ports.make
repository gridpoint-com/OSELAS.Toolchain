# -*-makefile-*-
# $Id$
#
# Copyright (C) 2006 by Robert Schwebel
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_GLIBC_PORTS) += glibc-ports

#
# Paths and names
#
GLIBC_PORTS_VERSION	:= $(call remove_quotes,$(PTXCONF_GLIBC_PORTS_VERSION))
GLIBC_PORTS		:= glibc-ports-$(GLIBC_PORTS_VERSION)
GLIBC_PORTS_SUFFIX	:= tar.bz2
GLIBC_PORTS_URL		:= $(PTXCONF_SETUP_GNUMIRROR)/glibc/$(GLIBC_PORTS).$(GLIBC_PORTS_SUFFIX)
GLIBC_PORTS_SOURCE	:= $(SRCDIR)/$(GLIBC_PORTS).$(GLIBC_PORTS_SUFFIX)
GLIBC_PORTS_DIR		:= $(BUILDDIR)/$(GLIBC_PORTS)

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

$(GLIBC_PORTS_SOURCE):
	@$(call targetinfo)
	@$(call get, GLIBC_PORTS)

# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------

ifdef PTXCONF_GLIBC_PORTS
$(STATEDIR)/glibc.extract: $(STATEDIR)/glibc-ports.extract
endif

$(STATEDIR)/glibc-ports.extract:
	@$(call targetinfo)
	@$(call clean, $(GLIBC_PORTS_DIR))
	@$(call extract, GLIBC_PORTS, $(BUILDDIR))
	@$(call patchin, GLIBC_PORTS, $(GLIBC_PORTS_DIR))
	@$(call touch)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

$(STATEDIR)/glibc-ports.prepare:
	@$(call targetinfo)
	@$(call touch)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

$(STATEDIR)/glibc-ports.compile:
	@$(call targetinfo)
	@$(call touch)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

$(STATEDIR)/glibc-ports.install:
	@$(call targetinfo)
	@$(call touch)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/glibc-ports.targetinstall:
	@$(call targetinfo)
	@$(call touch)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

glibc-ports_clean:
	rm -rf $(STATEDIR)/glibc-ports.*
	rm -rf $(IMAGEDIR)/glibc_ports_*
	rm -rf $(GLIBC_PORTS_DIR)

# vim: syntax=make
