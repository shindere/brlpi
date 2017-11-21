BLUEPAIRY_VERSION = e7a52804373543b03b4705c2dd543620c3262992
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
