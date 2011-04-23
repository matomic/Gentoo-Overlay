# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/gtk-engines-aurora/gtk-engines-aurora-1.5.1.ebuild,v 1.4 2010/01/06 19:39:50 fauli Exp $

EAPI=2
inherit versionator

APPID="121881"
MYNAME="equinox"

DESCRIPTION="Equinox GTK Engine and themes"
HOMEPAGE="http://www.gnome-look.org/content/show.php?content=${APPID}"
SRC_URI="http://gnome-look.org/CONTENT/content-files/${APPID}-${MYNAME}-${PV}.tar.gz
http://gnome-look.org/CONTENT/content-files/140448-${MYNAME}-themes-1.30.tar.gz
http://gnome-look.org/CONTENT/content-files/140449-${MYNAME}-themes-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86 ~x86-interix ~amd64-linux ~x86-linux ~x86-macos"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.10:2"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

S=${WORKDIR}/${MYNAME}-${PV}

src_unpack() {
	unpack ${A}
	cd "${WORKDIR}"
	mkdir themes
	mv Equinox* themes
}

src_configure() {
	econf --enable-animation
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog NEWS README
	insinto /usr/share/themes/
	doins -r ../themes/* || die "doins failed"
}
