# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/faenza-icon-theme/faenza-icon-theme-1.1.ebuild,v 1.2 2011/10/30 10:05:07 hwoarang Exp $

EAPI=4
inherit gnome2-utils

DESCRIPTION="A scalable icon theme called Faenza"
HOMEPAGE="http://code.google.com/p/faenza-icon-theme/"
SRC_URI="http://www.deviantart.com/download/173323228/faenza_icons_by_tiheum-d2v6x24.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="minimal +emesene"

RDEPEND="!minimal? ( x11-themes/gnome-icon-theme )
	x11-themes/hicolor-icon-theme
	emesene? ( net-im/emesene:2 )"

RESTRICT="binchecks strip"

S=${WORKDIR}

THEMES="Faenza
Faenza-Ambiance
Faenza-Dark
Faenza-Darker
Faenza-Darkest
Faenza-Radiance"

src_prepare() {
	local res x
	for x in ${THEMES}; do
		tar xzf ${x}.tar.gz || die "Cannot extract ${x}"
	done
	if use emesene ; then
		tar xzf emesene-faenza-theme.tar.gz || die "Cannot extract ${x}"
	fi

	einfo "Updating distribution and start-here icons"
	for x in Faenza Faenza-Dark; do
		for res in 22 24 32 48; do
			ln -sf start-here-gentoo.png \
				"${x}"/places/${res}/start-here.png || die
		done
		ln -sf start-here-gentoo.svg \
			"${x}"/places/scalable/start-here.svg || die
	done
	for res in 22 24 32 48; do
		ln -sf distributor-logo-gentoo.png \
			Faenza/places/${res}/distributor-logo.png ||die
	done
	ln -sf distributor-logo-gentoo.svg \
		Faenza/places/scalable/distributor-logo.svg ||die
}

src_install() {
	insinto /usr/share/icons
	doins -r ${THEMES}

	if use emesene ; then
		insinto /usr/lib64/python2.7/site-packages/emesene/themes/images
		doins -r emesene/themes/Faenza{,-Dark,-Darkest}
	fi

	dodoc AUTHORS ChangeLog README
}

pkg_preinst() { gnome2_icon_savelist; }
pkg_postinst() { gnome2_icon_cache_update; }
pkg_postrm() { gnome2_icon_cache_update; }
