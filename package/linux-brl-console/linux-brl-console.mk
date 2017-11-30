LINUX_BRL_CONSOLE_SOURCE = linux-brl-console.tgz
LINUX_BRL_CONSOLE_SITE = http://brl.thefreecat.org

LINUX_BRL_CONSOLE_DEPENDENCIES = host-linux-brl-console

define HOST_LINUX_BRL_CONSOLE_BUILD_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D) CFLAGS="$(HOST_CFLAGS)"
endef

define LINUX_BRL_CONSOLE_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 644 $(HOST_LINUX_BRL_CONSOLE_BUILDDIR)/*.psf \
		$(TARGET_DIR)/usr/share/consolefonts
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
