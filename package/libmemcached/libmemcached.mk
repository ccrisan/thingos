################################################################################
#
# libmemcached
#
################################################################################

LIBMEMCACHED_VERSION = 1.1.4
LIBMEMCACHED_SITE = \
	$(call github,awesomized,libmemcached,$(LIBMEMCACHED_VERSION))
LIBMEMCACHED_CONF_OPTS = -DENABLE_DTRACE=OFF
LIBMEMCACHED_INSTALL_STAGING = YES
LIBMEMCACHED_DEPENDENCIES = host-bison host-flex
LIBMEMCACHED_LICENSE = BSD-3-Clause
LIBMEMCACHED_LICENSE_FILES = LICENSE
LIBMEMCACHED_CPE_ID_VENDOR = awesome

# Force Release otherwise libraries will be suffixed by -dbg which will raise
# unexpected build failures with packages that use libmemcached (e.g. c-icap)
LIBMEMCACHED_CONF_OPTS += -DCMAKE_BUILD_TYPE=Release

ifeq ($(BR2_PACKAGE_LIBEVENT),y)
LIBMEMCACHED_DEPENDENCIES += libevent
LIBMEMCACHED_CONF_OPTS += -DENABLE_MEMASLAP=ON
else
LIBMEMCACHED_CONF_OPTS += -DENABLE_MEMASLAP=OFF
endif

ifeq ($(BR2_PACKAGE_OPENSSL),y)
LIBMEMCACHED_DEPENDENCIES += openssl
LIBMEMCACHED_CONF_OPTS += -DENABLE_OPENSSL_CRYPTO=ON
else
LIBMEMCACHED_CONF_OPTS += -DENABLE_OPENSSL_CRYPTO=OFF
endif

$(eval $(cmake-package))
