EAPI=2

inherit autotools eutils flag-o-matic linux-info mono multilib nsplugins pax-utils

DESCRIPTION="Moonlight is an open source implementation of Silverlight"
HOMEPAGE="http://www.go-mono.com/moonlight/"

LIBGDIPLUS="libgdiplus-2.8.1"
GTKSHARP="gtk-sharp-2.12.10"

SRC_URI="https://github.com/mono/moon/tarball/moon-3-99-0-2 -> ${P}.tar.gz
	http://ftp.novell.com/pub/mono/sources/libgdiplus/${LIBGDIPLUS}.tar.bz2
	http://ftp.novell.com/pub/mono/sources/gtk-sharp212/${GTKSHARP}.tar.bz2"
LICENSE="BSD-4 GPL-2 GPL-2-with-linking-exception IDPL LGPL-2 MIT Ms-PL NPL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa +curl +debug hardened +nsplugin pulseaudio sdk test"
RESTRICT="mirror"

RDEPEND="
	alsa? ( >=media-libs/alsa-lib-1.0.18 )
	curl? ( net-misc/curl )
	pulseaudio? ( >=media-sound/pulseaudio-0.9.14 )
	>=dev-dotnet/gtk-sharp-2.12.9
	dev-dotnet/rsvg-sharp
	dev-dotnet/wnck-sharp
	>=dev-lang/mono-2.8
	>=dev-libs/boehm-gc-7.1
	>=dev-libs/glib-2.18
	>=media-libs/fontconfig-2.6.0
	>=media-libs/freetype-2.3.7
	>=media-video/ffmpeg-0.6
	>=net-libs/xulrunner-1.9.1:1.9
	>=x11-libs/cairo-1.8.4
	>=x11-libs/gtk+-2.14
	x11-libs/libXrandr
	"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.23
	dev-libs/expat
	"

pkg_setup() {
	if use kernel_linux; then
		get_version
		if linux_config_exists; then
			if linux_chkconfig_present SYSVIPC; then
				einfo "CONFIG_SYSVIPC is set, looking good."
			else
				eerror "If CONFIG_SYSVIPC is not set in your kernel .config, mono compilation will hang."
				eerror "See http://bugs.gentoo.org/261869 for more info."
				die "Please set CONFIG_SYSVIPC in your kernel .config"
			fi
		else
			ewarn "Was unable to determine your kernel .config"
			ewarn "Please note that if CONFIG_SYSVIPC is not set in your kernel .config, mono compilation will hang."
			ewarn "See http://bugs.gentoo.org/261869 for more info."
		fi
	fi
}

src_unpack() {
	unpack ${A}
	cd "${WORKDIR}"
	mv mono-moon* ${P}
	epatch "${FILESDIR}/${P}_buildfixes.diff"
	epatch "${FILESDIR}/${P}_firefox4.diff"

	# Pull mono source to the right revision #
	git clone git://github.com/mono/mono.git mono
	cd mono && git reset --hard 32b3b31f && cd ..

	# Pull mesa source for pixel shader support #
	git clone git://anongit.freedesktop.org/mesa/mesa
	cd mesa && git reset --hard 3ed0a099c && cd ..

	# Pull mono-basic source to the right revision #
	git clone git://github.com/mono/mono-basic.git mono-basic
	cd mono-basic && git reset --hard 2e6038e
}

src_prepare() {
	# we need to sed in the paxctl -m in the runtime/mono-wrapper.in so it don't
	# get killed in the build proces when MPROTEC is enable. #286280
	if use hardened ; then
		ewarn "We are disabling MPROTECT on the mono binary."
		sed '/exec/ i\paxctl -m "$r/@mono_runtime@"' -i "${S}"/runtime/mono-wrapper.in
	fi

	# >=moonlight-3 must be built using a specific mono source tree revision #
	# That same mono source tree requires itself to be built using a system mono that is of the same version #
	# To do this we create a temporary base system mono built '--with-moonlight=no' #
	# Then use that system mono to build the mono source tree '--with-moonlight=yes' #

	# Configure, make and install a temporary system mono (without moonlight) #
	echo && einfo "Building temporary system mono (1st pass without moonlight)" && echo
	cd "${WORKDIR}/mono"
	./autogen.sh    --prefix="${WORKDIR}/mono-install" \
			--disable-quiet-build \
			--with-moonlight=no || die "Configure failed for mono"
	make && make install || die "Make failed for mono"

	# Setup mono build environment so that it uses the temporary base system mono #
	MONO_PREFIX="${WORKDIR}/mono-install"
	GNOME_PREFIX=/usr
	export DYLD_LIBRARY_FALLBACK_PATH=$MONO_PREFIX/lib:$DYLD_LIBRARY_FALLBACK_PATH
	export LD_LIBRARY_PATH=$MONO_PREFIX/lib:$LD_LIBRARY_PATH
	export C_INCLUDE_PATH=$MONO_PREFIX/include:$GNOME_PREFIX/include
	export ACLOCAL_PATH=$MONO_PREFIX/share/aclocal
	export PKG_CONFIG_PATH=$MONO_PREFIX/lib/pkgconfig:$GNOME_PREFIX/lib/pkgconfig
	export PATH=$MONO_PREFIX/bin:$PATH

	# Install libgdiplus into the temporary system mono #
	cd "${WORKDIR}/${LIBGDIPLUS}"
	./configure --prefix="${WORKDIR}/mono-install"
	make && make install || die "Make failed for libgdiplus"

	# Install gtk-sharp into the temporary system mono #
	cd "${WORKDIR}/${GTKSHARP}"
	./configure --prefix="${WORKDIR}/mono-install"
	make && make install || die "Make failed for gtk-sharp"

	# Configure and make the mono source tree (with moonlight) #
	cd "${WORKDIR}/mono"
	make distclean
	echo && einfo "Building mono source (2nd pass with moonlight)" && echo
	./autogen.sh    --disable-quiet-build \
			--with-moonlight=yes || die "Configure failed for mono"
	make || die "Make failed for mono"

	# Configure mono-basic #
	echo && einfo "Configuring mono-basic" && echo
	cd "${WORKDIR}/mono-basic"
	./configure     --with-moonlight=yes \
			--moonlight-sdk-location="${WORKDIR}/mono/mcs/class/lib/moonlight_raw"
}

src_configure() {
	echo && einfo "Building moonlight" && echo
	./autogen.sh	--prefix=/usr \
			--with-manual-mono=build \
			--enable-shared \
			--with-cairo=system \
			--with-ffmpeg=yes \
			--with-glx=yes \
			--with-ff3=yes \
			--without-ff2 \
			--enable-desktop-support \
			--with-examples=no \
			--with-curl=$(use !curl && printf "no" || printf "system") \
			--with-alsa=$(use !alsa && printf "no" || printf "yes") \
			--with-pulseaudio=$(use !pulseaudio && printf "no" || printf "yes") \
			--with-debug=$(use !debug && printf "no" || printf "yes") \
			--with-testing=$(use !test && printf "no" || printf "yes") \
			--with-performance=$(use !test && printf "no" || printf "yes") \
			$(use_enable nsplugin browser-support) \
			$(use_enable sdk) \
				|| die "Configure failed for moonlight"
}

src_compile() {
	emake || die "emake moonlight failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	if use nsplugin; then
		inst_plugin /usr/$(get_libdir)/moonlight/plugin/libmoonloader.so || die "installing libmoonloader failed"
	fi
	find "${D}" -name '*.la' -exec rm -rf '{}' '+' || die "la removal failed"
}
