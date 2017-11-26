LLVM_VERSION = 5.0.0
LLVM_SOURCE = llvm-$(LLVM_VERSION).src.tar.xz
LLVM_CFE_SOURCE = cfe-$(LLVM_VERSION).src.tar.xz
LLVM_SITE = http://releases.llvm.org/$(LLVM_VERSION)
LLVM_EXTRA_DOWNLOADS = $(LLVM_SITE)/$(LLVM_CFE_SOURCE)
LLVM_SUPPORTS_IN_SOURCE_BUILD = NO

LLVM_DEPENDENCIES = host-llvm

LLVM_CONF_OPTS = -DCMAKE_CROSSCOMPILING=On \
		 -DLLVM_TABLEGEN=$(HOST_DIR)/bin/llvm-tblgen \
		 -DCLANG_TABLEGEN=$(HOST_LLVM_BUILDDIR)/bin/clang-tblgen

define LLVM_CFE_EXTRACT
	mkdir $(@D)/tools/clang
	$(call suitable-extractor,$(LLVM_CFE_SOURCE)) $(DL_DIR)/$(LLVM_CFE_SOURCE) | \
	$(TAR) --strip-components=1 -C $(@D)/tools/clang $(TAR_OPTIONS) -
endef

HOST_LLVM_POST_EXTRACT_HOOKS += LLVM_CFE_EXTRACT
LLVM_POST_EXTRACT_HOOKS += LLVM_CFE_EXTRACT

$(eval $(host-cmake-package))
$(eval $(cmake-package))
