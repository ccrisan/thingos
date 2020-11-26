################################################################################
#
# python-unqlite
#
################################################################################

PYTHON_UNQLITE_VERSION = 0.9.1
PYTHON_UNQLITE_SOURCE = unqlite-$(PYTHON_UNQLITE_VERSION).tar.gz
PYTHON_UNQLITE_SITE = https://files.pythonhosted.org/packages/a9/f8/2d1aa85426036b2582ed190e41dcdf3305d8f375778f9acea60a5bbcb0e0
PYTHON_UNQLITE_LICENSE = MIT
PYTHON_UNQLITE_LICENSE_FILES = LICENSE
PYTHON_UNQLITE_SETUP_TYPE = setuptools

$(eval $(python-package))
