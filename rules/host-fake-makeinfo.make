# -*-makefile-*-
#
# Copyright (C) 2013 by Michael Olbrich <m.olbrich@pengutronix.de>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
HOST_PACKAGES-$(PTXCONF_HOST_FAKE_MAKEINFO) += host-fake-makeinfo

#
# Paths and names
#
HOST_FAKE_MAKEINFO		:= fake-makeinfo
HOST_FAKE_MAKEINFO_LICENSE	:= ignore

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

$(STATEDIR)/host-fake-makeinfo.install:
	@$(call targetinfo)
	install -d $(HOST_FAKE_MAKEINFO_PKGDIR)/usr/bin
	echo 'if [ "$${1}" == "--version" ]; then  echo "makeinfo (GNU texinfo) 5.2"; fi' > $(HOST_FAKE_MAKEINFO_PKGDIR)/usr/bin/makeinfo
	chmod +x $(HOST_FAKE_MAKEINFO_PKGDIR)/usr/bin/makeinfo
	@$(call touch)

# vim: syntax=make
