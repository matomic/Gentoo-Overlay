# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

#
# Original Author: Mathieu Zhang
# Purpose: Helper funcs for various x11-theme installation, many of which
#          taken from gnome-look.org
# Date: Thu May 13 00:45:43 PDT 2010
#

xcursors_ins() {
	cd ${WORKDIR}/${1}
	insinto /usr/share/cursors/xorg-x11/${1}
	doins -r cursors  || die "doins failed"
	doins -r index.theme || die "doins failed"
}
