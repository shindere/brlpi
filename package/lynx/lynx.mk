#############################################################
#
# lynx
#
#############################################################

LYNX_VERSION = 2.8.9dev.16
LYNX_SOURCE = lynx$(LYNX_VERSION).tar.bz2
LYNX_SITE = ftp://ftp.invisible-island.net/lynx/tarballs

LYNX_DEPENDENCIES = $(TARGET_NLS_DEPENDENCIES) ncurses
LYNX_CONF_OPTS = --with-screen=ncurses --with-curses-dir=$(TARGET_DIR)/usr

ifeq ($(BR2_PACKAGE_OPENSSL),y)
LYNX_DEPENDENCIES += openssl
LYNX_CONF_OPTS += --with-ssl
else ifeq ($(BR2_PACKAGE_GNUTLS),y)
LYNX_DEPENDENCIES += gnutls
LYNX_CONF_OPTS += --with-gnutls
endif

$(eval $(autotools-package))
