include $(THEOS)/makefiles/common.mk

# iOS 26.4 uchun
ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:14.0

TWEAK_NAME = AntiBanProject
AntiBanProject_FILES = Tweak.xm    # .x → .xm !
AntiBanProject_FRAMEWORKS = UIKit Foundation Security
AntiBanProject_CFLAGS = -fobjc-arc
AntiBanProject_LIBRARIES = substrate

include $(THEOS)/makefiles/tweak.mk

# O'rnatgandan keyin avto restart
after-install::
	install.exec "killall -9 SpringBoard"
