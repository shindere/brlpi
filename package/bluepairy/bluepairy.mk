BLUEPAIRY_VERSION = 6305a6b7e368e0722fb9ede6353380deb9ccbc77
BLUEPAIRY_SITE = $(call github,mlang,bluepairy,$(BLUEPAIRY_VERSION))

BLUEPAIRY_DEPENDENCIES += boost dbus

define BLUEPAIRY_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 0644 $(@D)/bluepairy-active-star.service \
		   $(TARGET_DIR)/usr/lib/systemd/system/bluepairy-active-star.service
	mkdir -p $(TARGET_DIR)/etc/systemd/system/bluetooth.target.wants
	ln -fs  ../../../../usr/lib/systemd/system/bluepairy-active-star.service \
		$(TARGET_DIR)/etc/systemd/system/bluetooth.target.wants/bluepairy-active-star.service
endef

$(eval $(cmake-package))
