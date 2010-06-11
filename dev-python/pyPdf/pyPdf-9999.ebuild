# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyPdf/pyPdf-1.12.ebuild,v 1.7 2010/05/18 13:02:17 hwoarang Exp $

EAPI="2"
SUPPORT_PYTHON_ABIS="1"

EGIT_REPO_URI="git://github.com/mfenniak/${PN}.git"
EGIT_BRANCH="py3"
inherit distutils git

DESCRIPTION="Python library to work with pdf files"
HOMEPAGE="http://pybrary.net/pyPdf/ http://pypi.python.org/pypi/pyPdf"
#SRC_URI="http://pybrary.net/${PN}/${P}.tar.gz"
SRC_URI=""

LICENSE="BSD-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND=""
RESTRICT_PYTHON_ABIS="3.*"
