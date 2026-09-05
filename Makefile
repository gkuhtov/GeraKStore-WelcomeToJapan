TARGET := iphone:clang:latest:15.0
ARCHS := arm64 arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = WelcomeToJapan

WelcomeToJapan_FILES = src/Tweak.xm src/WelcomeViewController.m src/WelcomeConfig.m src/WelcomeManager.m src/WelcomeAssets.m
WelcomeToJapan_FRAMEWORKS = UIKit QuartzCore CoreGraphics
WelcomeToJapan_CFLAGS = -fobjc-arc -Wno-deprecated-declarations

include $(THEOS_MAKE_PATH)/tweak.mk
