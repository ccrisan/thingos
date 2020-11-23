################################################################################
#
# python-pymongo
#
################################################################################

PYTHON_PYMONGO_VERSION = 3.11.1
PYTHON_PYMONGO_SOURCE = pymongo-$(PYTHON_PYMONGO_VERSION).tar.gz
PYTHON_PYMONGO_SITE = https://files.pythonhosted.org/packages/15/dc/bc9f2692cd9ece34236950db1c27573ab28a2a5d1d651af57c67839aa593
PYTHON_PYMONGO_SETUP_TYPE = setuptools

$(eval $(python-package))
