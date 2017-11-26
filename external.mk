include $(sort $(wildcard $(BR2_EXTERNAL_BRLPI_PATH)/package/*/*.mk))

ifeq ($(BR2_PACKAGE_LIBIDN),y)
LFTP_DEPENDENCIES += libidn
LFTP_CONF_OPTS += --with-libidn=$(STAGING_DIR)/usr
else
LFTP_CONF_OPTS += --without-libidn
endif
