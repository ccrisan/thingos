################################################################################
#
# semver-sort
#
################################################################################

SEMVER_SORT_VERSION = 1.1.0
SEMVER_SORT_SITE = $(call github,ccrisan,semver-sort,version-$(SEMVER_SORT_VERSION))
SEMVER_SORT_LICENSE = MIT

define SEMVER_SORT_BUILD_CMDS
    make CC="$(TARGET_CC)" -C "$(@D)" semver-sort
endef

define SEMVER_SORT_INSTALL_TARGET_CMDS
    cp $(@D)/semver-sort $(TARGET_DIR)/usr/bin/
endef

$(eval $(generic-package))
