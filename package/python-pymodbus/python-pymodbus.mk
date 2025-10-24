################################################################################
#
# python-pymodbus
#
################################################################################

PYTHON_PYMODBUS_VERSION = 3.5.2
PYTHON_PYMODBUS_SOURCE = pymodbus-$(PYTHON_PYMODBUS_VERSION).tar.gz
PYTHON_PYMODBUS_SITE = https://files.pythonhosted.org/packages/cc/f4/0b001d0199203d5432d0347855fd666de129e248713e2479bbbb0f0788b6
PYTHON_PYMODBUS_SETUP_TYPE = setuptools
PYTHON_PYMODBUS_LICENSE = BSD-3-Clause
PYTHON_PYMODBUS_LICENSE_FILES = doc/LICENSE

ifeq ($(BR2_PACKAGE_PYTHON),y)
# only needed/valid for python 3.x
define PYTHON_PYMODBUS_RM_PY3_FILES
	rm -rf $(TARGET_DIR)/usr/lib/python*/site-packages/pymodbus/client/asynchronous/asyncio
endef

PYTHON_PYMODBUS_POST_INSTALL_TARGET_HOOKS += PYTHON_PYMODBUS_RM_PY3_FILES
endif

$(eval $(python-package))
