#############################################################
#
# lynx
#
#############################################################

LYNX_VERSION = cur
LYNX_SOURCE = lynx-$(LYNX_VERSION).tar.bz2
LYNX_SITE = http://invisible-island.net/datafiles/release

LYNX_DEPENDENCIES = ncurses

LYNX_CONF_OPTS = --with-screen=ncurses --with-curses-dir=$(TARGET_DIR)/usr

$(eval $(autotools-package))
