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

# Java bindings fail to cross compile
BRLTTY_CONF_OPTS = --disable-java-bindings

ifeq ($(BR2_PACKAGE_BLUEZ5_UTILS),y)
BRLTTY_DEPENDENCIES += bluez5_utils
endif

ifeq ($(BR2_PACKAGE_NCURSES),y)
BRLTTY_DEPENDENCIES += ncurses
ifeq ($(BR2_PACKAGE_NCURSES_WCHAR),y)
BRLTTY_CONF_OPTS += --with-curses=ncursesw
else
BRLTTY_CONF_OPTS += --with-curses=ncurses
endif
else
BRLTTY_CONF_OPTS += --without-curses
endif

ifeq ($(BR2_PACKAGE_ICU),y)
BRLTTY_DEPENDENCIES += icu
BRLTTY_CONF_OPTS += --enable-icu
else
BRLTTY_CONF_OPTS += --disable-icu
endif

ifeq ($(BR2_SYSTEM_ENABLE_NLS),y)
NLS_OPTS = --enable-i18n
else
NLS_OPTS = --disable-i18n
endif

define BRLTTY_INSTALL_CONF
	$(INSTALL) -D -m 644 $(@D)/Documents/brltty.conf $(TARGET_DIR)/etc/brltty.conf
endef

define BRLTTY_SET_TEXT_TABLE
	mkdir -p $(TARGET_DIR)/etc/xdg/brltty
	echo text-table $(BR2_PACKAGE_BRLTTY_TEXT_TABLE) >> $(TARGET_DIR)/etc/xdg/brltty/brltty.conf
endef

BRLTTY_POST_INSTALL_TARGET_HOOKS += BRLTTY_INSTALL_CONF
ifneq ($(BR2_PACKAGE_BRLTTY_TEXT_TABLE),"")
BRLTTY_POST_INSTALL_TARGET_HOOKS += BRLTTY_SET_TEXT_TABLE
endif

define BRLTTY_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 $(BR2_EXTERNAL_BRLPI_PATH)/package/brltty/S10brltty \
		   $(TARGET_DIR)/etc/init.d/S10brltty
endef

define BRLTTY_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 0644 $(BR2_EXTERNAL_BRLPI_PATH)/package/brltty/brltty.service \
		   $(TARGET_DIR)/usr/lib/systemd/system/brltty.service

	mkdir -p $(TARGET_DIR)/etc/systemd/system/sysinit.target.wants
	ln -fs  ../../../../usr/lib/systemd/system/brltty.service \
		$(TARGET_DIR)/etc/systemd/system/sysinit.target.wants/brltty.service
endef

$(eval $(autotools-package))
