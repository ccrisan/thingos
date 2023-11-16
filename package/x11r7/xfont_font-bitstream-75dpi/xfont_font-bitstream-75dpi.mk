################################################################################
#
# xfont_font-bitstream-75dpi
#
################################################################################

XFONT_FONT_BITSTREAM_75DPI_VERSION = 1.0.4
XFONT_FONT_BITSTREAM_75DPI_SOURCE = font-bitstream-75dpi-$(XFONT_FONT_BITSTREAM_75DPI_VERSION).tar.xz
XFONT_FONT_BITSTREAM_75DPI_SITE = https://xorg.freedesktop.org/archive/individual/font
XFONT_FONT_BITSTREAM_75DPI_LICENSE = MIT
XFONT_FONT_BITSTREAM_75DPI_LICENSE_FILES = COPYING

XFONT_FONT_BITSTREAM_75DPI_INSTALL_STAGING_OPTS = DESTDIR=$(STAGING_DIR) MKFONTSCALE=$(HOST_DIR)/bin/mkfontscale MKFONTDIR=$(HOST_DIR)/bin/mkfontdir install
XFONT_FONT_BITSTREAM_75DPI_INSTALL_TARGET_OPTS = DESTDIR=$(TARGET_DIR) MKFONTSCALE=$(HOST_DIR)/bin/mkfontscale MKFONTDIR=$(HOST_DIR)/bin/mkfontdir install-data
XFONT_FONT_BITSTREAM_75DPI_DEPENDENCIES = \
	xfont_font-util \
	host-xfont_font-util \
	host-xapp_mkfontscale \
	host-xapp_bdftopcf \
	host-gzip

$(eval $(autotools-package))
