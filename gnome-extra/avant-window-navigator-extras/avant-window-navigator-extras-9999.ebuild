# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
EBZR_REPO_URI="lp:awn-extras"
PYTHON_DEPEND="2:2.5"

inherit autotools bzr eutils gnome2 python

DESCRIPTION="Applets for Avant Window Navigator"
HOMEPAGE="https://launchpad.net/awn-extras"
SRC_URI=""
LICENSE="GPL-2 GPL-3 LGPL-2.1 BSD CCPL-Attribution-ShareAlike-3.0"

SLOT="0"
KEYWORDS=""
IUSE="gnome gstreamer webkit xulrunner"

COMMON_DEPEND="
	>=gnome-base/libgtop-2
	>=gnome-extra/avant-window-navigator-0.3.9
	x11-libs/libnotify
	|| (
		>=x11-libs/gtk-2.17.1
		x11-libs/libsexy
	)
	>=x11-libs/libwnck-2.22
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXrender
	x11-libs/vte
	gnome? (
		>=gnome-extra/avant-window-navigator-0.3.9[gconf]
		gnome-base/gconf:2
		gnome-base/gnome-menus
	)
	gstreamer? ( >=media-libs/gstreamer-0.10.15 )
	webkit? ( net-libs/webkit-gtk )
	xulrunner? ( net-libs/xulrunner:1.9 )
"
DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.35
	>=dev-util/pkgconfig-0.17
	dev-lang/vala:0.10
"
RDEPEND="${COMMON_DEPEND}
	dev-libs/libgweather[python]
	dev-python/feedparser
	dev-python/notify-python
	dev-python/python-dateutil
	games-misc/fortune-mod
	x11-misc/xdg-utils
	|| (
		>=dev-lang/python-2.6
		dev-python/simplejson
	)
	gnome? (
		dev-python/gconf-python
		dev-python/gdata
		dev-python/gnome-keyring-python
		dev-python/gnome-media-python
		dev-python/gnome-vfs-python
		dev-python/librsvg-python
		dev-python/libwnck-python
		dev-python/vobject
		gnome-base/gnome-applets
		gnome-base/gnome-menus[python]
	)
	gstreamer? ( dev-python/gst-python )
"

DOCS="AUTHORS README"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup

	if use gstreamer; then G2CONF="${G2CONF} --enable-sound=gstreamer"
	else G2CONF="${G2CONF} --enable-sound=no"
	fi

	G2CONF="${G2CONF}
		--disable-static
		--disable-pymod-checks
		$(use_enable gnome schemas-install) \
		$(use_with gnome gconf)
		$(use_with gnome)
		$(use_with xulrunner mozilla)
		$(use_with webkit)
	"
}

src_unpack() {
	bzr_src_unpack
	find ${S} -iname '*py' -exec sed -i 's,python$,python2,' {} \; || die
}

src_prepare() {
	# Prevent scrollkeeper access violations
	gnome2_omf_fix

	intltoolize --copy --force || die "intltoolize failed"
	AT_M4DIR=m4 eautoreconf || die "eautoreconf failed"
	# disable pyc compiling - from gnome-python-common.eclass
	if [[ -f py-compile ]]; then
		rm py-compile
		ln -s $(type -P true) py-compile
	fi
}

src_install() {
	gnome2_src_install
	python_convert_shebangs -r 2 "${D}"
}

pkg_postinst() {
	gnome2_pkg_postinst
	python_mod_optimize awn/extras
}

pkg_postrm() {
	gnome2_pkg_postrm
	python_mod_cleanup awn/extras
}
