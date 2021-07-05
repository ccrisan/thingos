################################################################################
#
# python-base58
#
################################################################################

PYTHON_BASE58_VERSION = 2.1.0
PYTHON_BASE58_SOURCE = base58-$(PYTHON_BASE58_VERSION).tar.gz
PYTHON_BASE58_SITE = https://files.pythonhosted.org/packages/b5/c1/8e77d5389cf1ea2535049e5ffaeb241cce21bcc1c42624b3e8d0fb3bb607
PYTHON_BASE58_SETUP_TYPE = setuptools
PYTHON_BASE58_LICENSE_FILES = COPYING

$(eval $(python-package))
