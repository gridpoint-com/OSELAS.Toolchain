# -*-makefile-*-

#
# just quote removal
#
PTXCONF_TOOLCHAIN_CONFIG_SYSROOT		:= $(call remove_quotes, $(PTXCONF_TOOLCHAIN_CONFIG_SYSROOT))
PTXCONF_TOOLCHAIN_CONFIG_MULTILIB		:= $(call remove_quotes, $(PTXCONF_TOOLCHAIN_CONFIG_MULTILIB))

PTXCONF_GLIBC_HEADERS_FAKE_CROSS		:= $(call remove_quotes, $(PTXCONF_GLIBC_HEADERS_FAKE_CROSS))
PTXCONF_GLIBC_CONFIG_EXTRA			:= $(call remove_quotes, $(PTXCONF_GLIBC_CONFIG_EXTRA))

PTXCONF_CROSS_GCC_CONFIG_EXTRA			:= $(call remove_quotes, $(PTXCONF_CROSS_GCC_CONFIG_EXTRA))
PTXCONF_CROSS_GCC_CONFIG_LIBC			:= $(call remove_quotes, $(PTXCONF_CROSS_GCC_CONFIG_LIBC))
PTXCONF_CROSS_GCC_CONFIG_CXA_ATEXIT		:= $(call remove_quotes, $(PTXCONF_CROSS_GCC_CONFIG_CXA_ATEXIT))
PTXCONF_CROSS_GCC_CONFIG_SJLJ_EXCEPTIONS	:= $(call remove_quotes, $(PTXCONF_CROSS_GCC_CONFIG_SJLJ_EXCEPTIONS))
PTXCONF_CROSS_GCC_CONFIG_LIBSSP			:= $(call remove_quotes, $(PTXCONF_CROSS_GCC_CONFIG_LIBSSP))
PTXCONF_CROSS_GCC_CONFIG_SHARED			:= $(call remove_quotes, $(PTXCONF_CROSS_GCC_CONFIG_SHARED))

PTXCONF_ARCH					:= $(call remove_quotes, $(PTXCONF_ARCH))

#
# namespace cleanup
#
PTX_TOUPLE_TARGET				:= $(PTXCONF_GNU_TARGET)

#
# canadian cross support
#
ifdef PTX_CANADIAN_CROSS_HOST
PTX_HOST_AUTOCONF_HOST				:= --host=$(PTX_CANADIAN_CROSS_HOST)
PTX_HOST_CROSS_AUTOCONF_HOST			:= --host=$(PTX_CANADIAN_CROSS_HOST)
endif

PTX_HOST_CROSS_AUTOCONF_TARGET			:= --target=$(PTX_TOUPLE_TARGET)

PTX_HOST_AUTOCONF_PREFIX			:= --prefix=$(PTXCONF_SYSROOT_HOST)
PTX_HOST_CROSS_AUTOCONF_PREFIX			:= --prefix=$(PTXCONF_SYSROOT_CROSS)

PTX_HOST_AUTOCONF := \
	$(PTX_HOST_AUTOCONF_HOST) \
	$(PTX_HOST_AUTOCONF_PREFIX)

PTX_HOST_CROSS_AUTOCONF := \
	$(PTX_HOST_CROSS_AUTOCONF_HOST) \
	$(PTX_HOST_CROSS_AUTOCONF_TARGET) \
	$(PTX_HOST_CROSS_AUTOCONF_PREFIX)

# TODO:
PTX_HOST_ENV := \
	$(HOST_ENV_CPPFLAGS) \
	$(HOST_ENV_LDFLAGS) \
	$(HOST_ENV_PKG_CONFIG)

PTX_HOST_CROSS_ENV :=


#
# gcc-first
#
CROSS_GCC_FIRST_PREFIX	:= $(PTXCONF_SYSROOT_CROSS)/gcc-first
CROSS_PATH		:= $(PTXCONF_SYSROOT_CROSS)/bin:$(PTXCONF_SYSROOT_CROSS)/sbin:$(CROSS_GCC_FIRST_PREFIX)/bin:$$PATH

#
# debuggable gcc/glibc
#
ifdef PTXCONF_TOOLCHAIN_DEBUG
BUILDDIR_DEBUG		:= $(PTXCONF_SYSROOT_CROSS)/src/target
BUILDDIR_CROSS_DEBUG	:= $(PTXCONF_SYSROOT_CROSS)/src/cross
else
BUILDDIR_DEBUG		:= $(BUILDDIR)
BUILDDIR_CROSS_DEBUG	:= $(CROSS_BUILDDIR)
endif

# vim: syntax=make
