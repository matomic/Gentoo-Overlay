# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit git distutils

EGIT_REPO_URI="git://github.com/${PN}/${PN}.git"

DESCRIPTION="Platform independent MSN Messenger client written in Python+GTK"
HOMEPAGE="http://www.emesene.org http://emesene-msn.blogspot.com/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"

IUSE=""
KEYWORDS=""

DEPEND=">=dev-lang/python-2.5
>=x11-libs/gtk+-2.10.14
>=dev-python/pygtk-2.12"

RDEPEND="${DEPEND}
>=dev-python/papyon-0.5.4
dev-python/notify-python
dev-python/xmpppy"

## Do not support python-3:
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"
PYTHON_MODNAME="emesene"

src_install() {
	mydoexe() {
		exeinto "$(python_get_sitedir)/${PN}"
		doexe ${PN}/${PN} || die "doexe failed"
		dosym "$(python_get_sitedir)/${PN}/${PN}" "/usr/bin/${PN}"
	}
	python_execute_function mydoexe
	
	distutils_src_install
}

pkg_postinst() {
	ewarn "This is a live ebuild"
	ewarn "That means there are NO promises it will work."
	distutils_pkg_postinst
}
