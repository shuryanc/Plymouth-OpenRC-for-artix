# Maintainer: Taijian <taijian@posteo.de>
# Contributors: Patrick Burroughs (Celti), Abbradar, Zephyr, Christian Autermann, Biginoz, Martin Lee, Ricardo Funke,
#               PirateJonno, lh, Cilyan Olowen, Shaffer, Brcha, Lyle Putnam, Det, Boohbah,
#               Lara Maia, Padfoot, Jorge Barroso, carstene1ns, Sebastian Lau

pkgname=plymouth-git-openrc
pkgver=0.9.5.r106.gbad6d41
pkgrel=1
pkgdesc="A graphical boot splash screen with kernel mode-setting support (Development version)"
url="https://www.freedesktop.org/wiki/Software/Plymouth/"
arch=('i686' 'x86_64')
license=('GPL')

depends=('libdrm' 'pango' 'openrc')
makedepends=('git' 'docbook-xsl')
optdepends=('ttf-dejavu: For true type font support'
        'xf86-video-fbdev: Support special graphic cards on early startup'
        'cantarell-fonts: True Type support for BGRT theme')
provides=('plymouth')
conflicts=('plymouth' 'plymouth-legacy' 'plymouth-nosystemd' 'plymouth-git')
backup=('etc/plymouth/plymouthd.conf')

options=('!libtool' '!emptydirs')

source=("git+https://gitlab.freedesktop.org/plymouth/plymouth.git"
       'artix-logo.png'
       'plymouth.encrypt_hook'
       'plymouth.encrypt_install'
       'lxdm-plymouth'
       'lightdm-plymouth'
       'sddm-plymouth'
       'slim-plymouth'
       'plymouth-deactivate' # needed for sddm
       'plymouth-start'
       'plymouth-quit'
       'plymouth-poweroff.stop'
       'plymouth.initcpio_hook'
       'plymouth.initcpio_install'
       'sd-plymouth.initcpio_install'
       'plymouth-update-initrd.patch'
       'plymouthd.conf.patch'
)

sha256sums=('SKIP'
            'b05a820ddd43767d64cd87574899ddb033993c4eda5718017d050dfcf8541881'
            '748e0cfa0e10ab781bc202fceeed46e765ed788784f1b85945187b0f29eafad7'
            '373ec20fe4c47e693a0c45cc06dd906e35dd1d70a85546bd1d571391de11763a'
            '466bd13a27c9797883a0fcf01d17169ec2d0a5355123a095d16d840521c0e370'
            '06db7742c1cb7c6fd1384d1711b29803cecaed62cab934549af416c1e47076ae'
            '2d6e9d76353521c63b75b020d91cb8760d7d0c86421feccf4b9ca0fac271a9ca'
            '3f7023eb95fc3111300dfbf81928054aa8b7b86ab535327a357d0145497e7c35'
            '36e19c8104657aeee587a0a6bdbd9b14ddddea1357a3d36841ce50d15e3ea9ee'
            '00088b69709db7d68f4fe7ea681f717e296564e46567ada394355a57f94cfaca'
            '181f1ff223d605d28d9a54e9bc6d4b61027b768dbae0aa43cd90ee0b0cacf56e'
            '4f715f0a4db37557961017a8cafa786c8ec74df83c3d911b2c1917890fc2fccf'
            '2a80e2cad8de428358647677afa166219589d3338c5f94838146c804a29e2769'
            'd2201253d9f4a1f7e556e60a04401237273a4577e157a8c4471d5c81bff88ccd'
            'd254f3d01631024ed4563d39fcaa631b0ace097faf7ed05de382859ccfa48a08'
            '74908ba59cea53c6a9ab67bb6dec1de1616f3851a0fd89bb3c157a1c54e6633a'
            '71d34351b4313da01e1ceeb082d9776599974ce143c87e93f0a465f342a74fd2')

pkgver() {
  cd plymouth
  git describe --long | sed 's/-/.r/;s/-/./'
}

prepare() {
	cd plymouth
	patch -p1 -i $srcdir/plymouth-update-initrd.patch
	patch -p1 -i $srcdir/plymouthd.conf.patch
}

build() {
	cd plymouth

	LDFLAGS="$LDFLAGS -ludev" ./autogen.sh \
		--prefix=/usr \
		--exec-prefix=/usr \
		--sysconfdir=/etc \
		--localstatedir=/var \
		--libdir=/usr/lib \
		--libexecdir=/usr/lib \
		--sbindir=/usr/bin \
		--enable-drm \
		--enable-tracing \
		--enable-pango \
		--enable-gtk=no \
		--with-release-file=/etc/os-release \
		--with-logo=/usr/share/plymouth/arch-logo.png \
		--with-background-color=0x000000 \
		--with-background-start-color-stop=0x000000 \
		--with-background-end-color-stop=0x4D4D4D \
		--without-rhgb-compat-link \
		--without-system-root-install \
		--with-runtimedir=/run

	make
}

package() {
  cd plymouth

	make DESTDIR="$pkgdir" install

	install -Dm644 "$srcdir/artix-logo.png" "$pkgdir/usr/share/plymouth/artix-logo.png"

	install -Dm644 "$srcdir/plymouth.encrypt_hook" "$pkgdir/usr/lib/initcpio/hooks/plymouth-encrypt"
	install -Dm644 "$srcdir/plymouth.encrypt_install" "$pkgdir/usr/lib/initcpio/install/plymouth-encrypt"
	install -Dm644 "$srcdir/plymouth.initcpio_hook" "$pkgdir/usr/lib/initcpio/hooks/plymouth"
	install -Dm644 "$srcdir/plymouth.initcpio_install" "$pkgdir/usr/lib/initcpio/install/plymouth"
	install -Dm644 "$srcdir/sd-plymouth.initcpio_install" "$pkgdir/usr/lib/initcpio/install/sd-plymouth"
	
	install -Dm644 "$srcdir/plymouth-start" "$pkgdir/etc/init.d/plymouth-start"
	install -Dm644 "$srcdir/plymouth-quit" "$pkgdir/etc/init.d/plymouth-quit"
	install -Dm644 "$srcdir/plymouth-poweroff.stop" "$pkgdir/etc/local.d/plymouth-poweroff.stop"
	
	for i in {sddm,lxdm,lightdm,slim}-plymouth; do
		install -Dm644 "$srcdir/$i" "$pkgdir/etc/init.d/$i"
	done
	
	ln -s "/etc/init.d/gdm" "$pkgdir/etc/init.d/gdm-plymouth"

	install -Dm644 "$pkgdir/usr/share/plymouth/plymouthd.defaults" "$pkgdir/etc/plymouth/plymouthd.conf"
	rm -r $pkgdir/*.wants
	chmod 755 $pkgdir/etc/init.d/*
	chmod 755 $pkgdir/etc/local.d/*
}
