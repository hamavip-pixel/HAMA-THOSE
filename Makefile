ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:14.0
THEOS_PACKAGE_SCHEME = rootless

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = HAMAOverlay
HAMAOverlay_FILES = main.xm
HAMAOverlay_FRAMEWORKS = UIKit Foundation
HAMAOverlay_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	@echo "HAMAOverlay installed. Respring/relaunch the target app to test."
