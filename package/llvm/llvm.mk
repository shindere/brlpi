LLVM_VERSION = 5.0.0
LLVM_SOURCE = llvm-$(LLVM_VERSION).src.tar.xz
LLVM_CFE_SOURCE = cfe-$(LLVM_VERSION).src.tar.xz
LLVM_CLANG_TOOLS_EXTRA_SOURCE = clang-tools-extra-$(LLVM_VERSION).src.tar.xz
LLVM_SITE = http://releases.llvm.org/$(LLVM_VERSION)
LLVM_EXTRA_DOWNLOADS = $(LLVM_SITE)/$(LLVM_CFE_SOURCE) $(LLVM_SITE)/$(LLVM_CLANG_TOOLS_EXTRA_SOURCE)
LLVM_SUPPORTS_IN_SOURCE_BUILD = NO

LLVM_DEPENDENCIES = host-llvm

LLVM_CONF_OPTS = -DCMAKE_CROSSCOMPILING=On \
		 -DLLVM_TABLEGEN=$(HOST_LLVM_BUILDDIR)/bin/llvm-tblgen \
		 -DCLANG_TABLEGEN=$(HOST_LLVM_BUILDDIR)/bin/clang-tblgen \
		 -DLLVM_DEFAULT_TARGET_TRIPLE=$(ARCH)-$(TARGET_OS)-$(LIBC)$(ABI)

ifeq ($(BR2_arm),y)
LLVM_CONF_OPTS += -DLLVM_TARGET_ARCH=ARM -DLLVM_TARGETS_TO_BUILD=ARM
endif

define HOST_LLVM_BUILD_CMDS
	$(HOST_MAKE_ENV) $(MAKE) $(HOST_LLVM_MAKE_OPTS) -C $(HOST_LLVM_BUILDDIR) llvm-tblgen clang-tblgen
endef

define HOST_LLVM_INSTALL_CMDS
	# Skipped
endef

define LLVM_CFE_EXTRACT
	mkdir $(@D)/tools/clang
	$(call suitable-extractor,$(LLVM_CFE_SOURCE)) $(DL_DIR)/$(LLVM_CFE_SOURCE) | \
	$(TAR) --strip-components=1 -C $(@D)/tools/clang $(TAR_OPTIONS) -
endef

define LLVM_CLANG_TOOLS_EXTRA_EXTRACT
	mkdir $(@D)/tools/clang/tools/extra
	$(call suitable-extractor,$(LLVM_CLANG_TOOLS_EXTRA_SOURCE)) $(DL_DIR)/$(LLVM_CLANG_TOOLS_EXTRA_SOURCE) | \
	$(TAR) --strip-components=1 -C $(@D)/tools/clang/tools/extra $(TAR_OPTIONS) -
endef

HOST_LLVM_POST_EXTRACT_HOOKS += LLVM_CFE_EXTRACT
LLVM_POST_EXTRACT_HOOKS += LLVM_CFE_EXTRACT LLVM_CLANG_TOOLS_EXTRA_EXTRACT

$(eval $(host-cmake-package))
$(eval $(cmake-package))
