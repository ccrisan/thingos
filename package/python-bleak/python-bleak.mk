################################################################################
#
# python-bleak
#
################################################################################

PYTHON_BLEAK_VERSION = 0.19.0
PYTHON_BLEAK_SOURCE = bleak-$(PYTHON_BLEAK_VERSION).tar.gz
PYTHON_BLEAK_SITE = https://files.pythonhosted.org/packages/19/39/ce32196148fd57f3eccffd9d246e78956855abe3b0c5038cf6166c75b7d8
PYTHON_BLEAK_SETUP_TYPE = setuptools
PYTHON_BLEAK_LICENSE = MIT
PYTHON_BLEAK_LICENSE_FILES = LICENSE

$(eval $(python-package))
