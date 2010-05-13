# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/blueglass-xcursors/blueglass-xcursors-0.4.ebuild,v 1.22 2006/11/27 23:59:04 flameeyes Exp $

inherit x11-themes

APPID=27913

MY_PN="PolarCursorTheme"
DESCRIPTION="A smooth and simple cursor set created primarily in Inkscape"
HOMEPAGE="http://kde-look.org/content/show.php/Polar+Cursor+Themes?content=${APPID}"
SRC_URI="http://kde-look.org/CONTENT/content-files/${APPID}-${MY_PN}s.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	media-libs/libpng
	x11-libs/libX11
	x11-libs/libXcursor
"
DEPEND="${RDEPEND}
	x11-apps/xcursorgen"

src_install() {
	xcursors_ins ${MY_PN}
	xcursors_ins ${MY_PN}-Blue
	xcursors_ins ${MY_PN}-Green
}

pkg_postinst() {
	elog "To use this set of cursors, edit or create the file ~/.Xdefaults"
	elog "and add the following line:"
	elog "Xcursor.theme: ${MY_PN}"
	elog
	elog "You can change the size by adding a line like:"
	elog "Xcursor.size: 48"
	elog
	elog "Also, to globally use this set of	mouse cursors edit the file:"
	elog "/usr/share/cursors/xorg-x11/default/index.theme"
	elog "and change the line:"
	elog "    Inherits=[current	setting]"
	elog "to"
	elog "	Inherits=${MY_PN}"
	elog
	elog "Note this	will be overruled by a user's ~/.Xdefaults file."
	elog
	ewarn "If you experience flickering, try setting the following line in"
	ewarn "the Device section of your xorg.conf file:"
	ewarn "Option \"HWCursor\" \"false\""
}
