DEBUG=0
FINALPACKAGE=1
ARCHS = arm64
PACKAGE_VERSION = 0.3
TARGET := iphone:clang:16.5:13.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = YTMod
$(TWEAK_NAME)_FRAMEWORKS = UIKit Foundation Security
$(TWEAK_NAME)_CFLAGS = -fobjc-arc
$(TWEAK_NAME)_FILES = $(wildcard *.x)

include $(THEOS_MAKE_PATH)/tweak.mk
