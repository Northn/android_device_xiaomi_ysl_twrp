#
#	This file is part of the OrangeFox Recovery Project
# 	Copyright (C) 2020-2021 The OrangeFox Recovery Project
#
#	OrangeFox is free software: you can redistribute it and/or modify
#	it under the terms of the GNU General Public License as published by
#	the Free Software Foundation, either version 3 of the License, or
#	any later version.
#
#	OrangeFox is distributed in the hope that it will be useful,
#	but WITHOUT ANY WARRANTY; without even the implied warranty of
#	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#	GNU General Public License for more details.
#
#	This software is released under GPL version 3 or any later version.
#	See <http://www.gnu.org/licenses/>.
#
# 	Please maintain this if you use this script or any part of it
#

FDEVICE="ysl"

add_lunch_combo omni_ysl-userdebug
add_lunch_combo omni_ysl-eng
 
fox_get_target_device() {
    local chkdev=$(echo "$BASH_SOURCE" | grep -w $FDEVICE)
    if [ -n "$chkdev" ]; then 
        FOX_BUILD_DEVICE="$FDEVICE"
    else
        chkdev=$(set | grep BASH_ARGV | grep -w $FDEVICE)
        [ -n "$chkdev" ] && FOX_BUILD_DEVICE="$FDEVICE"
    fi
}

if [ -z "$1" -a -z "$FOX_BUILD_DEVICE" ]; then
   fox_get_target_device
fi

if [ "$1" = "$FDEVICE" -o "$FOX_BUILD_DEVICE" = "$FDEVICE" ]; then
    # Note: Don't forget to export FOX_VERSION="R11.1_*" where * is a ID of release.
    
    # Maintainership compliance guideline flags
    export LC_ALL="C"
    export ALLOW_MISSING_DEPENDENCIES=true
    export FOX_USE_TWRP_RECOVERY_IMAGE_BUILDER=1

    # Magisk
    export OF_USE_MAGISKBOOT=1
    export OF_USE_MAGISKBOOT_FOR_ALL_PATCHES=1

    # MIUI
    export OF_NO_MIUI_OTA_VENDOR_BACKUP=1
    export OF_DISABLE_MIUI_OTA_BY_DEFAULT=1

    # OTA for Custom ROMs
    export OF_SUPPORT_ALL_BLOCK_OTA_UPDATES=1
    export OF_FIX_OTA_UPDATE_MANUAL_FLASH_ERROR=1

    # MTP & adb enabled only after passing the correct password
    export FOX_ADVANCED_SECURITY=1

    # 18:9, so 18 * 120 = 2160
    export OF_SCREEN_H=2160

    # Maintainer
    export OF_MAINTAINER="Andrey Norton"

    # Old and useless
    export FOX_DELETE_AROMAFM=1

    # Some binaries
    export FOX_USE_NANO_EDITOR=1
    export FOX_REPLACE_BUSYBOX_PS=1
    export FOX_USE_BASH_SHELL=1
    export FOX_ASH_IS_BASH=1
    export FOX_USE_SED_BINARY=1
    export FOX_USE_XZ_UTILS=1

    # Check for attempt to overwrite recovery
    export OF_CHECK_OVERWRITE_ATTEMPTS=1

    # Not exists on ysl
    export OF_USE_GREEN_LED=0

    # We don't have hardware buttons
    export OF_ALLOW_DISABLE_NAVBAR=0

    # Quick backup partitions
    export OF_QUICK_BACKUP_LIST="/boot;/system_image;/vendor_image;"

    # To not loose OFRP on official MIUI
    export OF_PATCH_AVB20=1

    # Official latest stable Magisk module
    export FOX_USE_SPECIFIC_MAGISK_ZIP="~/Magisk/Magisk-v23.0.zip"

    # FBE
    export OF_KEEP_DM_VERITY_FORCED_ENCRYPTION=1
    export OF_SKIP_MULTIUSER_FOLDERS_BACKUP=1
    export OF_DONT_PATCH_ENCRYPTED_DEVICE=1
    export FOX_VARIANT="FBE"

    if [ -n "$FOX_BUILD_LOG_FILE" -a -f "$FOX_BUILD_LOG_FILE" ]; then
        export | grep "FOX" >> $FOX_BUILD_LOG_FILE
        export | grep "OF_" >> $FOX_BUILD_LOG_FILE
        export | grep "TARGET_" >> $FOX_BUILD_LOG_FILE
        export | grep "TW_" >> $FOX_BUILD_LOG_FILE
    fi
fi
