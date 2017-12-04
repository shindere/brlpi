################################################################################
#
# console-setup
#
################################################################################

CONSOLE_SETUP_VERSION = 1.164
CONSOLE_SETUP_SOURCE = console-setup_$(CONSOLE_SETUP_VERSION).tar.xz
CONSOLE_SETUP_SITE = http://http.debian.net/debian/pool/main/c/console-setup

define CONSOLE_SETUP_BUILD_CMDS
	$(MAKE) -C $(@D) build-linux
endef

define CONSOLE_SETUP_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 644 $(@D)/Fonts/*.psf.gz $(TARGET_DIR)/usr/share/consolefonts
	$(INSTALL) -D -m 644 $(@D)/acm/*.acm.gz $(TARGET_DIR)/usr/share/consoletrans
endef

$(eval $(generic-package))
