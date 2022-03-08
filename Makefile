uYouPlus_INJECT_DYLIBS = Tweaks/uYou.dylib .theos/obj/libcolorpicker.dylib .theos/obj/iSponsorBlock.dylib .theos/obj/YTUHD.dylib .theos/obj/YouPiP.dylib .theos/obj/YouTubeDislikesReturn.dylib 

uYouPlus_USE_FLEX = 0
ARCHS = arm64
MODULES = jailed
FINALPACKAGE = 1
CODESIGN_IPA = 0

TWEAK_NAME = uYouPlus
DISPLAY_NAME = YouTube
BUNDLE_ID = com.google.ios.youtube
 
uYouPlus_FILES = uYouPlus.x
uYouPlus_IPA = /path/to/your/decrypted/YouTube.ipa
### Important: edit the path to your decrypted YouTube IPA!!! 

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += Tweaks/Alderis Tweaks/iSponsorBlock Tweaks/YTUHD Tweaks/YouPiP Tweaks/Return-YouTube-Dislikes
include $(THEOS_MAKE_PATH)/aggregate.mk

before-package::
	@tput setaf 4 && echo -e "==> \033[1mMoving tweak's bundle to ./Resources/..."
	@mkdir -p Resources/Frameworks/Alderis.framework && find .theos/obj/install/Library/Frameworks/Alderis.framework -maxdepth 1 -type f -exec cp {} Resources/Frameworks/Alderis.framework/ \;
	@cp -R Tweaks/YouPiP/layout/Library/Application\ Support/YouPiP.bundle Resources/
	@cp -R Tweaks/iSponsorBlock/layout/Library/Application\ Support/iSponsorBlock.bundle Resources/
	@tput setaf 5 && echo -e "==> \033[1mChanging the installation path of dylibs..."
	@codesign --remove-signature .theos/obj/iSponsorBlock.dylib && install_name_tool -change /usr/lib/libcolorpicker.dylib @rpath/libcolorpicker.dylib .theos/obj/iSponsorBlock.dylib
	@codesign --remove-signature .theos/obj/libcolorpicker.dylib && install_name_tool -change /Library/Frameworks/Alderis.framework/Alderis @rpath/Alderis.framework/Alderis .theos/obj/libcolorpicker.dylib	

after-package::
	@tput setaf 1 && echo -e "==> \033[1mCleaning up..."
	@find ./Resources -mindepth 1 -name uYouBundle.bundle -prune -o -exec rm -rf {} +
	@rm -rf .theos/_/Payload