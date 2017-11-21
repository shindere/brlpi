brlpi0w/images/sdcard.img: brlpi0w/.config
	$(MAKE) -C brlpi0w

nconfig: brlpi0w/.config
	$(MAKE) -C brlpi0w nconfig

brlpi0w/.config: buildroot/Makefile
	$(MAKE) -C buildroot BR2_EXTERNAL=$(CURDIR) O=$(CURDIR)/brlpi0w brlpi0w_defconfig

buildroot/Makefile:
	git submodule update --init buildroot

clean:
	rm -rf brlpi0w
	git submodule deinit -f buildroot

