################################################################################
#
# brltty
#
################################################################################

BRLTTY_VERSION = 5.5
BRLTTY_SOURCE = brltty-$(BRLTTY_VERSION).tar.xz
BRLTTY_SITE = http://brltty.com/archive
BRLTTY_INSTALL_STAGING_OPTS = INSTALL_ROOT=$(STAGING_DIR) install
BRLTTY_INSTALL_TARGET_OPTS = INSTALL_ROOT=$(TARGET_DIR) install
BRLTTY_LICENSE_FILES = LICENSE-GPL LICENSE-LGPL

BRLTTY_DEPENDENCIES = $(TARGET_NLS_DEPENDENCIES)

BRLTTY_CONF_OPTS = --disable-java-bindings --disable-lisp-bindings --disable-ocaml-bindings --disable-python-bindings --disable-tcl-bindings

ifeq ($(BR2_PACKAGE_BLUEZ5_UTILS),y)
BRLTTY_DEPENDENCIES += bluez5_utils
BRLTTY_CONF_OPTS += --with-bluetooth-package
else
BRLTTY_CONF_OPTS += --without-bluetooth-package
endif

ifeq ($(BR2_PACKAGE_ESPEAK),y)
BRLTTY_DEPENDENCIES += espeak
BRLTTY_CONF_OPTS += --with-espeak=$(TARGET_DIR)/usr
else
BRLTTY_CONF_OPTS += --without-espeak
endif

ifeq ($(BR2_PACKAGE_FLITE),y)
BRLTTY_DEPENDENCIES += flite
BRLTTY_CONF_OPTS += --with-flite=$(TARGET_DIR)/usr
else
BRLTTY_CONF_OPTS += --without-flite
endif

ifeq ($(BR2_PACKAGE_SPEECH_DISPATCHER),y)
BRLTTY_DEPENDENCIES += speech-dispatcher
BRLTTY_CONF_OPTS += --with-speechd=$(TARGET_DIR)/usr
else
BRLTTY_CONF_OPTS += --without-speechd
endif

ifeq ($(BR2_PACKAGE_ICU),y)
BRLTTY_DEPENDENCIES += icu
BRLTTY_CONF_OPTS += --enable-icu
else
BRLTTY_CONF_OPTS += --disable-icu
endif

ifeq ($(BR2_PACKAGE_NCURSES),y)
BRLTTY_DEPENDENCIES += ncurses
BRLTTY_CONF_OPTS += --with-curses
else
BRLTTY_CONF_OPTS += --without-curses
endif

ifeq ($(BR2_PACKAGE_SYSTEMD),y)
BRLTTY_DEPENDENCIES += systemd
BRLTTY_CONF_OPTS += --with-service-package
else
BRLTTY_CONF_OPTS += --without-service-package
endif

ifeq ($(BR2_SYSTEM_ENABLE_NLS),y)
BRLTTY_CONF_OPTS += --enable-i18n
else
BRLTTY_CONF_OPTS += --disable-i18n
endif

ifneq ($(BR2_PACKAGE_BRLTTY_TEXT_TABLE),"")
BRLTTY_CONF_OPTS += --with-text-table=$(call qstrip,$(BR2_PACKAGE_BRLTTY_TEXT_TABLE))
endif

define BRLTTY_INSTALL_CONF
	$(INSTALL) -D -m 644 $(@D)/Documents/brltty.conf $(TARGET_DIR)/etc/brltty.conf
endef

BRLTTY_POST_INSTALL_TARGET_HOOKS += BRLTTY_INSTALL_CONF

define BRLTTY_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 $(BR2_EXTERNAL_BRLPI_PATH)/package/brltty/S10brltty \
		   $(TARGET_DIR)/etc/init.d/S10brltty
endef

ifeq ($(BR2_PACKAGE_HAS_UDEV),y)
# USB is handled by the Udev rules
BRLTTY_CONF_OPTS += --with-braille-device=bluetooth:
define BRLTTY_INSTALL_UDEV
	$(MAKE) -C $(@D)/Autostart/Udev $(BRLTTY_INSTALL_TARGET_OPTS) UDEV_RULES_TYPE=all install
endef
BRLTTY_POST_INSTALL_TARGET_HOOKS += BRLTTY_INSTALL_UDEV
endif

define BRLTTY_INSTALL_INIT_SYSTEMD
	$(MAKE) -C $(@D)/Autostart/Systemd $(BRLTTY_INSTALL_TARGET_OPTS) install
	mkdir -p $(TARGET_DIR)/etc/systemd/system/sysinit.target.wants
	ln -fs  ../../../../usr/lib/systemd/system/brltty.target \
		$(TARGET_DIR)/etc/systemd/system/sysinit.target.wants/brltty.target
endef

$(eval $(autotools-package))
