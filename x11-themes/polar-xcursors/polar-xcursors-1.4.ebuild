# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/blueglass-xcursors/blueglass-xcursors-0.4.ebuild,v 1.22 2006/11/27 23:59:04 flameeyes Exp $


APPID=27913

PKGNAME="PolarCursorTheme"
DESCRIPTION="A smooth and simple cursor set created primarily in Inkscape"
HOMEPAGE="http://www.kde-look.org/content/show.php?content=${APPID}"
SRC_URI="http://gnome-look.org/CONTENT/content-files/${APPID}-${PKGNAME}s.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

src_unpack() {
	unpack ${A}
	rm ${WORKDIR}/${PKGNAME}/*~
	rm -rf ${WORKDIR}/${PKGNAME}/Source
}

src_install() {
	insinto /usr/share/cursors/xorg-x11/
	doins -r ${WORKDIR}/*  || die "Copy failed"
}

# pkg_postinst() {
# 	ewarn "If you experience flickering, try setting the following line in"
# 	ewarn "the Device section of your XF86Config:"
# 	ewarn "Option  \"HWCursor\"  \"false\""
# 	ewarn ""
# 	ewarn "the Device section of your xorg.conf file:"
# 	ewarn "    Option  \"HWCursor\"  \"false\""
# }
