# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

EBZR_REPO_URI="lp:awn"
PYTHON_DEPEND="2:2.5"

inherit autotools bzr gnome2 python

DESCRIPTION="Fully customizable dock for the Free desktop"
HOMEPAGE="https://launchpad.net/awn"
SRC_URI=""
LICENSE="GPL-2 LGPL-2.1 CCPL-Attribution-ShareAlike-3.0"

SLOT="0"
KEYWORDS=""
IUSE="doc gconf"

COMMON_DEPEND="
	dev-libs/dbus-glib
	>=dev-libs/glib-2.16.0
	dev-python/pycairo
	dev-python/pygtk:2
	gnome-base/libgtop
	>=x11-libs/gtk+-2.12.0
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXext
	x11-libs/libXrender
	x11-libs/libdesktop-agnostic[gconf?]
	>=x11-libs/libwnck-2.22
"

RDEPEND="${COMMON_DEPEND}
	dev-python/pyxdg
"
DEPEND="${COMMON_DEPEND}
	>=dev-util/gtk-doc-1.4
	>=dev-util/intltool-0.35.5
	dev-util/pkgconfig
	x11-proto/compositeproto
	x11-proto/renderproto
	x11-proto/xextproto
	x11-proto/xproto
	gconf? ( gnome-base/gconf:2 )
	>=dev-lang/vala-0.9.1
"

DOCS="AUTHORS ChangeLog NEWS README TODO"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_unpack() {
	bzr_src_unpack
}

src_prepare() {
	gtkdocize || die "gtkdocize failed"
	intltoolize --copy --force || die "intltoolize failed"
	eautoreconf || die "eautoreconf failed"
	# disable pyc compiling - from gnome-python-common.eclass
	if [[ -f py-compile ]]; then
		rm py-compile
		ln -s $(type -P true) py-compile
	fi
}

src_configure() {
	econf $(use_enable doc gtk-doc) \
		$(use_enable gconf schemas-install) \
		--disable-static \
		--disable-pymod-checks \
		--enable-extra-version=-gentoo-desktop-effects
}

src_install() {
	gnome2_src_install
	python_convert_shebangs -r 2 "${D}"
}

pkg_postinst() {
	gnome2_pkg_postinst

	ewarn
	ewarn "AWN will be of no use if you do not have a compositing manager."

	python_mod_optimize awn
}

pkg_postrm() {
	gnome2_pkg_postrm
	python_mod_cleanup  awn
}
