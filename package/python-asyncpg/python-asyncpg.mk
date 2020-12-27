################################################################################
#
# python-asyncpg
#
################################################################################

PYTHON_ASYNCPG_VERSION = 0.21.0
PYTHON_ASYNCPG_SOURCE = asyncpg-$(PYTHON_ASYNCPG_VERSION).tar.gz
PYTHON_ASYNCPG_SITE = https://files.pythonhosted.org/packages/08/4b/ae73e69c5ec9c45f6b07d3cb151ee8597ddb5c3f3b539cf4dfa4af13031d
PYTHON_ASYNCPG_LICENSE = MIT
PYTHON_ASYNCPG_LICENSE_FILES = LICENSE
PYTHON_ASYNCPG_SETUP_TYPE = setuptools

$(eval $(python-package))
