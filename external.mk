include $(sort $(wildcard $(BR2_EXTERNAL_BRLPI_PATH)/package/*/*.mk))

define BRLPI_CREATE_USER_OVERLAY
	mkdir -p $(HOME)/.config/brlpi/overlay
endef

TARGET_FINALIZE_HOOKS += BRLPI_CREATE_USER_OVERLAY
