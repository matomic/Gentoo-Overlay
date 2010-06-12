# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/gdm-themes-livecd/gdm-themes-livecd-2007.0.ebuild,v 1.1 2007/05/07 18:57:59 wolf31o2 Exp $

DESCRIPTION="Arc-Colors GDM theme"
HOMEPAGE="http://gnome-look.org/content/show.php/Arc-Colors+GDM-Walls?content=88305"
SRC_URI="http://gnome-colors.googlecode.com/files/${P}.tar.gz"

RDEPEND="gnome-base/gdm"

SLOT="0"
LICENSE="as-is"
KEYWORDS="alpha amd64 ia64 ppc sparc x86"
IUSE=""

S=${WORKDIR}/${P}

src_install() {
	DESTDIR=${D} emake install
	#	insinto /usr/share/gdm/themes
	#	doins -r *
}
