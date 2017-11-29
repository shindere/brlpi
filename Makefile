all: brlpi3/images/sdcard.img brlpi0w/images/sdcard.img

brlpi0w/images/sdcard.img: brlpi0w/.config
	$(MAKE) -C brlpi0w

brlpi3/images/sdcard.img: brlpi3/.config
	$(MAKE) -C brlpi3

brlpi0w/.config: configs/brlpi0w_defconfig buildroot/Makefile
	$(MAKE) -C buildroot BR2_EXTERNAL=$(CURDIR) O=$(CURDIR)/brlpi0w brlpi0w_defconfig

brlpi3/.config: configs/brlpi3_defconfig buildroot/Makefile
	$(MAKE) -C buildroot BR2_EXTERNAL=$(CURDIR) O=$(CURDIR)/brlpi3 brlpi3_defconfig

buildroot/Makefile:
	git submodule update --init buildroot

clean:
	rm -rf brlpi0w brlpi3
	git submodule deinit -f buildroot

