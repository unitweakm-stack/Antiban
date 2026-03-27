include $(THEOS)/makefiles/common.mk
TWEAK_NAME = license-bypass
license-bypass_FILES = Tweak.xm
license-bypass_CFLAGS = -fobjc-arc
license-bypass_FRAMEWORKS = UIKit Security
include $(THEOS)/makefiles/tweak.mk
