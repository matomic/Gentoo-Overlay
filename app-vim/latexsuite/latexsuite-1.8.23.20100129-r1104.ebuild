# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/latexsuite/latexsuite-9999.ebuild,v 1.9 2008/09/12 22:23:44 maekke Exp $

inherit vim-plugin versionator

DESCRIPTION="vim plugin: a comprehensive set of tools to view, edit and compile LaTeX documents"
HOMEPAGE="http://vim-latex.sourceforge.net/"

LICENSE="vim"
KEYWORDS="alpha amd64 ia64 ppc ~ppc64 sparc x86"
IUSE=""

# In order to have proper PORTAGE tree structure:
MY_PF="vim-latex-${PV/.2010/-2010}-${PR}"
SRC_URI="http://sourceforge.net/projects/vim-latex/files/snapshots/${MY_PF}.tar.gz"

# without this line, ebuild attempts to compile this package, which requires no
# compilation:
#S="${WORKDIR}"
S="${WORKDIR}/${MY_PF}"

RDEPEND="virtual/latex-base"

VIM_PLUGIN_HELPFILES="latex-suite.txt latex-suite-quickstart.txt latexhelp.txt imaps.txt"

src_unpack() {
	unpack ${A}

	# Don't need to install these
	rm ${S}/Makefile*
	rm ${S}/doc/Makefile*
}

src_install() {
	into /usr

	dobin ${S}/ltags
	rm ${S}/ltags
	vim-plugin_src_install
}

pkg_postinst() {
	vim-plugin_pkg_postinst
	elog
	elog "To use the latexSuite plugin add:"
	elog "   filetype plugin on"
	elog '   set grepprg=grep\ -nH\ $*'
	elog "to your ~/.vimrc-file"
	elog
}
