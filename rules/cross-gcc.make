# -*-makefile-*-
#
# Copyright (C) 2006 by Robert Schwebel
#               2008, 2009 by Marc Kleine-Budde <mkl@pengutronix.de>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
CROSS_PACKAGES-$(PTXCONF_CROSS_GCC) += cross-gcc

#
# Paths and names
#
CROSS_GCC_VERSION	:= $(call remove_quotes,$(PTXCONF_CROSS_GCC_VERSION))
CROSS_GCC_DL_VERSION	:= $(call remove_quotes,$(PTXCONF_CROSS_GCC_DL_VERSION))
CROSS_GCC_MD5		:= $(call remove_quotes,$(PTXCONF_CROSS_GCC_MD5))
CROSS_GCC		:= gcc-$(CROSS_GCC_DL_VERSION)
CROSS_GCC_SUFFIX	:= tar.xz
CROSS_GCC_SOURCE	:= $(SRCDIR)/$(CROSS_GCC).$(CROSS_GCC_SUFFIX)
CROSS_GCC_DIR		:= $(CROSS_BUILDDIR)/$(CROSS_GCC)
CROSS_GCC_BUILD_OOT	:= YES
CROSS_GCC_LICENSE	:= $(call remove_quotes,$(PTXCONF_CROSS_GCC_LICENSE))
CROSS_GCC_LICENSE_FILES	:= $(call remove_quotes,$(PTXCONF_CROSS_GCC_LICENSE_FILES))

CROSS_GCC_URL		:= \
	$(call ptx/mirror, GNU, gcc/$(CROSS_GCC)/$(CROSS_GCC).$(CROSS_GCC_SUFFIX)) \
	https://sourceware.org/pub/gcc/snapshots/$(CROSS_GCC_DL_VERSION)/$(CROSS_GCC).$(CROSS_GCC_SUFFIX) \
	https://sourceware.org/pub/gcc/releases/$(CROSS_GCC)/$(CROSS_GCC).$(CROSS_GCC_SUFFIX)

ptx/abs2rel := $(PTXDIST_WORKSPACE)/scripts/ptxd_abs2rel.sh

# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------

$(STATEDIR)/cross-gcc.extract:
	@$(call targetinfo)
	@$(call clean, $(CROSS_GCC_DIR))
	@$(call extract, CROSS_GCC)
	@$(call patchin, CROSS_GCC, $(CROSS_GCC_DIR))
ifdef PTXCONF_CROSS_ECJ
	@cp $(CROSS_ECJ_SOURCE) $(CROSS_GCC_DIR)/ecj.jar
endif
	@$(call touch)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

CROSS_GCC_CONF_ENV	:= \
	$(HOST_CROSS_ENV) \
	CFLAGS="-ggdb3 -O2" \
	CXXFLAGS="-ggdb3 -O2" \
	ac_cv_path_SED=/bin/sed \
	MAKEINFO=:

#
# autoconf
#
CROSS_GCC_AUTOCONF_COMMON := \
	$(PTX_HOST_CROSS_AUTOCONF_BUILD) \
	$(PTX_HOST_CROSS_AUTOCONF_HOST) \
	$(PTX_HOST_CROSS_AUTOCONF_TARGET) \
	\
	$(PTXCONF_TOOLCHAIN_CONFIG_SYSROOT) \
	$(PTXCONF_TOOLCHAIN_CONFIG_MULTILIB) \
	\
	$(PTXCONF_CROSS_GCC_CONFIG_EXTRA) \
	$(PTXCONF_CROSS_GCC_CONFIG_LIBC) \
	$(PTXCONF_CROSS_GCC_CONFIG_CXA_ATEXIT) \
	$(PTXCONF_CROSS_GCC_CONFIG_SJLJ_EXCEPTIONS) \
	\
	--disable-nls \
	--disable-decimal-float \
	--disable-fixed-point \
	--disable-win32-registry \
	\
	--enable-symvers=gnu \
	\
	--with-pkgversion=$(PTXCONF_CROSS_GCC_PKGVERSION) \
	--enable-threads=$(PTXCONF_CROSS_GCC_THREADS) \
	--with-system-zlib \
	\
	$(call ptx/ifdef,PTXCONF_HOST_SYSTEM_GMP,--with-gmp) \
	$(call ptx/ifdef,PTXCONF_HOST_SYSTEM_MPFR,--with-mpfr) \
	$(call ptx/ifdef,PTXCONF_HOST_SYSTEM_MPC,--with-mpc) \
	$(call ptx/ifdef,PTXCONF_HOST_SYSTEM_ISL,--with-isl)

CROSS_GCC_AUTOCONF_COMMON += \
	--with-debug-prefix-map="$(call ptx/toolchain-cross-debug-map, CROSS_GCC)" \
	--enable-libstdcxx-debug-flags="-gdwarf-4 -O0 -D_GLIBCXX_ASSERTIONS $(call ptx/toolchain-cross-debug-flags, CROSS_GCC)"

CROSS_GCC_CONF_ENV += \
	CFLAGS_FOR_TARGET="$(call ptx/toolchain-cross-debug-flags, CROSS_GCC)" \
	CXXFLAGS_FOR_TARGET="$(call ptx/toolchain-cross-debug-flags, CROSS_GCC)"

#   --enable-tls            enable or disable generation of tls code
#                           overriding the assembler check for tls support
#   --enable-initfini-array       use .init_array/.fini_array sections
#   --enable-version-specific-runtime-libs
#                           specify that runtime libraries should be
#                           installed in a compiler-specific directory
#   --with-long-double-128  Use 128-bit long double by default.


#
# language selection
#
CROSS_GCC_LANG-$(PTXCONF_CROSS_GCC_LANG_C)		+= c
CROSS_GCC_LANG-$(PTXCONF_CROSS_GCC_LANG_CXX)		+= c++
CROSS_GCC_LANG-$(PTXCONF_CROSS_GCC_LANG_JAVA)		+= java
CROSS_GCC_LANG-$(PTXCONF_CROSS_GCC_LANG_FORTRAN)	+= fortran
CROSS_GCC_LANG-$(PTXCONF_CROSS_GCC_LANG_OBJC)		+= objc
CROSS_GCC_LANG-$(PTXCONF_CROSS_GCC_LANG_OBJCXX)		+= obj-c++

CROSS_GCC_CONF_TOOL	:= autoconf
CROSS_GCC_CONF_OPT	:= \
	$(CROSS_GCC_AUTOCONF_COMMON) \
	$(PTX_HOST_CROSS_AUTOCONF_PREFIX) \
	\
	--enable-languages=$(subst $(space),$(comma),$(CROSS_GCC_LANG-y)) \
	--enable-c99 \
	--enable-long-long \
	--enable-libstdcxx-debug \
	--enable-profile \
	\
	$(PTXCONF_CROSS_GCC_CONFIG_SHARED) \
	$(PTXCONF_CROSS_GCC_CONFIG_LIBSSP) \
	\
	$(if $(filter 3.%,$(CROSS_GCC_VERSION)),,--enable-checking=release)

$(STATEDIR)/cross-gcc.prepare:
	@$(call targetinfo)
	@$(call world/prepare, CROSS_GCC)
	sed -i -e '/TOPLEVEL_CONFIGURE_ARGUMENTS/s;$(PTXDIST_WORKSPACE);$(PTXCONF_PROJECT);g' \
		-e '/TOPLEVEL_CONFIGURE_ARGUMENTS/s;$(call ptx/sh, realpath $(PTXDIST_WORKSPACE));$(PTXCONF_PROJECT);g' \
		$(CROSS_GCC_DIR)-build/Makefile
	@$(call touch)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

CROSS_GCC_MAKE_ENV := \
	with_zstd=no

ifdef PTXDIST_ICECC
CROSS_GCC_MAKE_ENV += \
	STAGE_CC_WRAPPER=$(PTXDIST_ICERUN)
endif

CROSS_GCC_MAKE_OPT := \
	build_tooldir=$(PTXDIST_SYSROOT_CROSS)$(PTXCONF_PREFIX_CROSS)/$(PTXCONF_GNU_TARGET) \
	all

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

$(STATEDIR)/cross-gcc.install: $(STATEDIR)/cross-gcc.report
	@$(call targetinfo)
	@$(call world/install, CROSS_GCC)
ifdef PTXCONF_CROSS_GCC_LANG_CXX
	@test -e $(CROSS_GCC_PKGDIR)$(PTXCONF_PREFIX_CROSS)/$(PTXCONF_GNU_TARGET)/$(CROSS_BINUTILS_LIBDIR)/libstdc++.so.6 || \
		ptxd_bailout "CROSS_BINUTILS_LIBDIR incorrect!"
endif

	@$(call world/env, CROSS_GCC) \
		pkg_license_target=gcclibs \
		pkg_license_target_license=$(PTXCONF_CROSS_GCC_GCCLIBS_LICENSE) \
		pkg_license_target_pattern=$(PTXCONF_CROSS_GCC_GCCLIBS_LICENSES) \
		ptxd_make_world_copy_license

	@ln -vsf $(COMPILER_PREFIX)c++ \
		$(CROSS_GCC_PKGDIR)$(PTXCONF_PREFIX_CROSS)/bin/$(COMPILER_PREFIX)g++
	@ln -vsf $(COMPILER_PREFIX)gcc-$(CROSS_GCC_VERSION) \
		$(CROSS_GCC_PKGDIR)$(PTXCONF_PREFIX_CROSS)/bin/$(COMPILER_PREFIX)gcc

	@find $(CROSS_GCC_PKGDIR) -name "*.la" -print0 | xargs -0 rm -v -f
ifneq ($(call remove_quotes,$(PTXDIST_SYSROOT_CROSS)),)
	sed -i -e 's;$(call remove_quotes,$(PTXDIST_SYSROOT_CROSS));;' \
		$(CROSS_GCC_PKGDIR)$(PTXCONF_PREFIX_CROSS)/lib/gcc/$(PTXCONF_GNU_TARGET)/$(CROSS_GCC_VERSION)/install-tools/mkheaders.conf
	if [ -e $(CROSS_GCC_PKGDIR)$(PTXCONF_PREFIX_CROSS)/lib/gcc/$(PTXCONF_GNU_TARGET)/$(CROSS_GCC_VERSION)/include-fixed/pthread.h ]; then \
		sed -i -e 's;$(call remove_quotes,$(PTXDIST_SYSROOT_CROSS));;' \
			$(CROSS_GCC_PKGDIR)$(PTXCONF_PREFIX_CROSS)/lib/gcc/$(PTXCONF_GNU_TARGET)/$(CROSS_GCC_VERSION)/include-fixed/pthread.h; \
	fi
endif
	@$(call touch)

$(STATEDIR)/cross-gcc.install.post:
	@$(call targetinfo)
	@$(call world/install.post, CROSS_GCC)
	@$(call world/install-src, CROSS_GCC)
	@ptxd_make_setup_target_compiler $(PTXDIST_SYSROOT_CROSS)$(PTXCONF_PREFIX_CROSS)/bin
	@$(call touch)

# vim: syntax=make
