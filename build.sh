#!/bin/bash

# Exit on first error
set -e

# sudo yum install -y man vim curl git perl-devel libcurl-devel \
#   openssl-devel zlib-devel gperf cmake \
#   asciidoc xmlto startup-notification-devel gtk-doc \
#   libpng-devel freetype-devel libxml2-devel \
#   docbook-utils-pdf libffi-devel libXext-devel \
#   libX11-devel
sudo yum install -y man vim curl git gcc gcc-c++ svn autoconf automake \
  libtool make patch gperf cmake gettext bison libffi-devel \
  libxml2-devel gtk-doc

# sudo yum groupinstall -y "X Window System"
# sudo yum groupinstall -y "Desktop Platform Development"

# git clone git://github.com/mattness/dotfiles.git $HOME/.dotfiles
# cp $HOME/.dotfiles/git/gitconfig.symlink{.example,}
# $HOME/.dotfiles/install <<<'O'

sudo mkdir -p -m 775 /src && sudo chown root:vagrant /src && cd $_

# Build a modern Git
# git clone git://github.com/gitster/git-manpages.git
# git clone git://github.com/git/git.git
# cd git
# git checkout v2.6.3
# make configure
# ./configure --prefix=/usr/local
# make
# sudo make install quick-install-man
# sudo ln -s /src/git/contrib/completion/git-completion.bash /etc/profile.d/git-completion.sh
# sudo ln -s /src/git/contrib/completion/git-prompt.sh /etc/profile.d/git-prompt.sh
# sudo yum remove -y git
# hash -r

# Build i3
cd /src
git clone http://anongit.freedesktop.org/git/pkg-config.git
# curl -s http://pkgconfig.freedesktop.org/releases/pkg-config-0.28.tar.gz | tar zxf -
git clone https://git.gnome.org/browse/glib
# curl -s http://ftp.gnome.org/pub/gnome/sources/glib/2.33/glib-2.33.14.tar.xz
git clone http://anongit.freedesktop.org/git/xorg/util/macros.git
# curl -s http://xorg.freedesktop.org/releases/individual/util/util-macros-1.18.0.tar.gz | tar zxf -
git clone http://anongit.freedesktop.org/git/xcb/proto.git
# curl -s http://xcb.freedesktop.org/dist/xcb-proto-1.11.tar.gz | tar zxf -
git clone http://anongit.freedesktop.org/git/xcb/pthread-stubs.git
# curl -s http://xcb.freedesktop.org/dist/libpthread-stubs-0.3.tar.gz | tar zxf -
git clone http://anongit.freedesktop.org/git/xorg/proto/xproto.git
# curl -s http://xorg.freedesktop.org/releases/individual/proto/xproto-7.0.28.tar.gz | tar zxf -
git clone http://anongit.freedesktop.org/git/xorg/lib/libXau.git
# curl -s http://xorg.freedesktop.org/releases/individual/lib/libXau-1.0.8.tar.gz | tar zxf -
git clone http://anongit.freedesktop.org/git/xcb/libxcb.git
# curl -s http://xcb.freedesktop.org/dist/libxcb-1.11.tar.gz | tar zxf -
git clone http://anongit.freedesktop.org/git/xcb/util.git /src/xcb-util --recursive
# curl -s http://xcb.freedesktop.org/dist/xcb-util-0.4.0.tar.gz | tar zxf -
git clone https://github.com/xkbcommon/libxkbcommon.git
git clone http://anongit.freedesktop.org/git/xcb/util-renderutil.git --recursive
# curl -s http://xcb.freedesktop.org/dist/xcb-util-renderutil-0.3.9.tar.gz | tar zxf -
git clone http://anongit.freedesktop.org/git/xcb/util-image.git --recursive
# http://xcb.freedesktop.org/dist/xcb-util-image-0.4.0.tar.gz
git clone http://anongit.freedesktop.org/git/xcb/util-cursor.git --recursive
# http://xcb.freedesktop.org/dist/xcb-util-cursor-0.1.2.tar.gz
git clone http://anongit.freedesktop.org/git/xcb/util-wm.git --recursive
# http://xcb.freedesktop.org/dist/xcb-util-wm-0.3.8.tar.gz
git clone http://anongit.freedesktop.org/git/xcb/util-keysyms.git --recursive
# http://xcb.freedesktop.org/dist/xcb-util-keysyms-0.4.0.tar.gz
git clone http://git.lighttpd.net/libev.git
# curl -s http://dist.schmorp.de/libev/Attic/libev-4.19.tar.gz | tar zxf -
git clone https://github.com/lloyd/yajl.git
# http://github.com/lloyd/yajl/tarball/2.1.0
svn co svn://vcs.exim.org/pcre/code/tags/pcre-8.35 pcre
git clone http://anongit.freedesktop.org/git/pixman.git
# http://cairographics.org/releases/pixman-0.30.2.tar.gz
git clone git://git.sv.nongnu.org/freetype/freetype2.git
# http://download.savannah.gnu.org/releases/freetype/freetype-2.6.2.tar.gz
git clone http://anongit.freedesktop.org/git/fontconfig
# http://www.freedesktop.org/software/fontconfig/release/fontconfig-2.10.95.tar.gz
git clone http://git.code.sf.net/p/libpng/code libpng
# ftp://ftp.simplesystems.org/pub/libpng/png/src/libpng12/libpng-1.2.54.tar.gz
git clone http://anongit.freedesktop.org/git/cairo
# http://cairographics.org/releases/cairo-1.14.4.tar.xz
curl -s http://www.freedesktop.org/software/harfbuzz/release/harfbuzz-1.1.1.tar.bz2 | tar jxf -
git clone git://git.gnome.org/pango
git clone http://anongit.freedesktop.org/git/xorg/lib/libxtrans.git
git clone http://anongit.freedesktop.org/git/xorg/proto/xextproto.git
git clone http://anongit.freedesktop.org/git/xorg/proto/kbproto.git
git clone http://anongit.freedesktop.org/git/xorg/proto/inputproto.git
git clone http://anongit.freedesktop.org/git/xorg/lib/libX11.git
git clone http://anongit.freedesktop.org/git/startup-notification.git
git clone https://github.com/i3/i3.git
git clone https://github.com/i3/i3status.git

## Build an updated pkgconfig
cd /src/pkg-config
git checkout pkg-config-0.28
./autogen.sh
./configure --enable-static=yes --enable-shared=no --with-internal-glib
make && sudo make install && hash -r

export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:/usr/local/share/pkgconfig:/usr/lib64/pkgconfig:/usr/share/pkgconfig

# glib
cd /src/glib
git checkout 2.33.14
export ACLOCAL="aclocal -I /usr/local/share/aclocal"
./autogen.sh
./configure --enable-static=yes --enable-shared=no
make && sudo make install

# Macros
cd /src/macros
git checkout util-macros-1.18.0
export ACLOCAL="aclocal -I /usr/local/share/aclocal"
./autogen.sh
./configure --enable-static=yes --enable-shared=no
make && sudo make install

# proto
cd /src/proto
git checkout 1.11
export ACLOCAL="aclocal -I /usr/local/share/aclocal"
./autogen.sh
./configure --enable-static=yes --enable-shared=no
make && sudo make install

# pthread-stubs
cd /src/pthread-stubs
git checkout 0.3
export ACLOCAL="aclocal -I /usr/local/share/aclocal"
./autogen.sh
./configure --enable-static=yes --enable-shared=no
make && sudo make install

# xproto
cd /src/xproto/
git checkout xproto-7.0.28
export ACLOCAL="aclocal -I /usr/local/share/aclocal"
./autogen.sh
./configure --enable-static=yes --enable-shared=no
make && sudo make install

# libXau
cd /src/libXau/
git checkout libXau-1.0.8
export ACLOCAL="aclocal -I /usr/local/share/aclocal"
./autogen.sh
./configure --enable-static=yes --enable-shared=no
make && sudo make install

# libxcb
cd /src/libxcb/
git checkout 1.11
export ACLOCAL="aclocal -I /usr/local/share/aclocal"
./autogen.sh
./configure --enable-static=yes --enable-shared=no
make && sudo make install

# xcb-util
cd /src/xcb-util
git checkout 0.4.0
export ACLOCAL="aclocal -I /usr/local/share/aclocal"
./autogen.sh
./configure --enable-static=yes --enable-shared=no
make && sudo make install

# xkbcommon
cd /src/libxkbcommon/
git checkout xkbcommon-0.5.0
export ACLOCAL="aclocal -I /usr/local/share/aclocal"
./autogen.sh
./configure --enable-static=yes --enable-shared=no
make && sudo make install

# util-render
cd /src/util-renderutil/
git checkout 0.3.9
export ACLOCAL="aclocal -I /usr/local/share/aclocal"
./autogen.sh
./configure --enable-static=yes --enable-shared=no
make && sudo make install

# util-image
cd /src/util-image/
git checkout 0.4.0
export ACLOCAL="aclocal -I /usr/local/share/aclocal"
./autogen.sh
./configure --enable-static=yes --enable-shared=no
make && sudo make install

# util-cursor
cd /src/util-cursor/
git checkout 0.1.2
export ACLOCAL="aclocal -I /usr/local/share/aclocal"
./autogen.sh
./configure --enable-static=yes --enable-shared=no
make && sudo make install

# util-wm
cd /src/util-wm
git checkout 0.3.8
export ACLOCAL="aclocal -I /usr/local/share/aclocal"
./autogen.sh
./configure --enable-static=yes --enable-shared=no
make && sudo make install

# util-keysyms
cd /src/util-keysyms
git checkout 0.4.0
export ACLOCAL="aclocal -I /usr/local/share/aclocal"
./autogen.sh
./configure --enable-static=yes --enable-shared=no
make && sudo make install

# libev
# cd /src/libev-4.19
cd /src/libev
git checkout rel-4.19
export ACLOCAL="aclocal -I /usr/local/share/aclocal"
autoreconf -v --install
./configure --enable-static=yes --enable-shared=no
make && sudo make install

# yajl
cd /src/yajl
git checkout 2.1.0
./configure --enable-static=yes --enable-shared=no
make && sudo make install

# pcre
cd /src/pcre
export ACLOCAL="aclocal -I /usr/local/share/aclocal"
./autogen.sh
./configure --enable-static=yes --enable-shared=no && make && sudo make install

# pixman
cd /src/pixman
git checkout pixman-0.30.2
export ACLOCAL="aclocal -I /usr/local/share/aclocal"
./autogen.sh
./configure --enable-static=yes --enable-shared=no
make && sudo make install

# freetype2
cd /src/freetype2
git checkout VER-2-6-2
export ACLOCAL="aclocal -I /usr/local/share/aclocal"
./autogen.sh && ./configure --enable-static=yes --enable-shared=no
make && sudo make install

# fontconfig
cd /src/fontconfig
git checkout 2.10.95
export ACLOCAL="aclocal -I /usr/local/share/aclocal"
./autogen.sh --enable-libxml2
./configure --enable-static=yes --enable-shared=no --disable-docs --enable-libxml2
make && sudo make install

# png
cd /src/libpng
git checkout v1.2.55
export ACLOCAL="aclocal -I /usr/local/share/aclocal"
./autogen.sh
./configure --enable-static=yes --enable-shared=no
make && sudo make install

# cairo
cd /src/cairo
git checkout 1.14.4
export ACLOCAL="aclocal -I /usr/local/share/aclocal"
./autogen.sh
./configure --enable-static=yes --enable-shared=no
make && sudo make install

# harfbuzz
cd /src/harfbuzz-1.1.1
./configure --enable-static=yes --enable-shared=no && make && sudo make install

# pango
cd /src/pango
git checkout 1.36.8
export ACLOCAL="aclocal -I /usr/local/share/aclocal"
./autogen.sh
./configure --enable-static=yes --enable-shared=no
patch -p 1 <<'EOH'
diff --git a/tests/markup-parse.c b/tests/markup-parse.c
index e9cb6a5..04521d0 100644
--- a/tests/markup-parse.c
+++ b/tests/markup-parse.c
@@ -228,7 +228,7 @@ main (int argc, char *argv[])

       return 0;
     }
-
+/*
   path = g_test_build_filename (G_TEST_DIST, "markups", NULL);
   dir = g_dir_open (path, 0, &error);
   g_free (path);
@@ -244,6 +244,6 @@ main (int argc, char *argv[])
       g_free (path);
     }
   g_dir_close (dir);
-
+*/
   return g_test_run ();
 }
diff --git a/tests/test-layout.c b/tests/test-layout.c
index fffc963..514a163 100644
--- a/tests/test-layout.c
+++ b/tests/test-layout.c
@@ -522,7 +522,7 @@ main (int argc, char *argv[])

       return 0;
     }
-
+/*
   path = g_test_build_filename (G_TEST_DIST, "layouts", NULL);
   dir = g_dir_open (path, 0, &error);
   g_free (path);
@@ -538,6 +538,6 @@ main (int argc, char *argv[])
       g_free (path);
     }
   g_dir_close (dir);
-
+*/
   return g_test_run ();
 }
EOH
make && sudo make install

# libxtrans
cd /src/libxtrans
git checkout xtrans-1.3.5
export ACLOCAL="aclocal -I /usr/local/share/aclocal"
./autogen.sh
./configure --enable-static=yes --enable-shared=no
make && sudo make install

# xextproto
cd /src/xextproto
git checkout xextproto-7.3.0
export ACLOCAL="aclocal -I /usr/local/share/aclocal"
./autogen.sh
make && sudo make install

# kbproto
cd /src/kbproto
git checkout kbproto-1.0.7
export ACLOCAL="aclocal -I /usr/local/share/aclocal"
./autogen.sh
make && sudo make install

# inputproto
cd /src/inputproto
git checkout inputproto-2.3.1
./autogen.sh
make && sudo make install

# libX11
cd /src/libX11
git checkout libX11-1.6.3
export ACLOCAL="aclocal -I /usr/local/share/aclocal"
./autogen.sh
./configure --enable-static=yes --enable-shared=no
make && sudo make install

# libsn
cd /src/startup-notification
git checkout STARTUP_NOTIFICATION_0_12
export ACLOCAL="aclocal -I /usr/local/share/aclocal"
./autogen.sh
./configure --enable-static=yes --enable-shared=no
make && sudo make install

# i3
cd /src/i3
git checkout 4.11
make i3_LIBS='-L/usr/local/lib -lxkbcommon -lxcb -lyajl_s -lev -lxkbcommon-x11 -lxcb-keysyms -lstartup-notification-1 -lxcb-icccm -lxcb-util -lxcb-xkb -lxcb-randr -lxcb-cursor -lxcb-xinerama -lm -lpangocairo-1.0 -lpango-1.0 -lgobject-2.0 -lcairo -lXau -lX11-xcb -lxcb-render -lxcb-render-util -lxcb-image -lpangoft2-1.0 -lfontconfig -lfreetype -lgmodule-2.0 -lffi -lpixman-1 -lxcb-shm -lxml2 -lglib-2.0' i3_config_wizard_LIBS='-L/usr/local/lib -lxcb -lxcb-keysyms -lxkbcommon -lxkbcommon-x11 -lxcb-util -lpangocairo-1.0 -lpango-1.0 -lcairo -lgobject-2.0 -lxcb-xkb -lXau -lpangoft2-1.0 -lfontconfig -lfreetype -lgmodule-2.0 -lpixman-1 -lxcb-render -lxcb-shm -lglib-2.0 -lpthread -lffi -lxml2 -lrt' i3_msg_LIBS='-L/usr/local/lib -lyajl_s -lxcb -lXau -lxcb-util' i3_input_LIBS='-L/usr/local/lib -lxcb -lxcb-keysyms -lxcb-util -lpangocairo-1.0 -lpango-1.0 -lgobject-2.0 -lcairo -lXau -lpangoft2-1.0 -lfontconfig -lfreetype -lgmodule-2.0 -lpixman-1 -lxcb-render -lxcb-shm -lglib-2.0 -lffi -lpthread -lxml2 -lrt' i3_nagbar_LIBS='-L/usr/local/lib -lxcb -lxcb-randr -lxcb-util -lpangocairo-1.0 -lpango-1.0 -lgobject-2.0 -lcairo -lXau -lpangoft2-1.0 -lfontconfig -lfreetype -lgmodule-2.0 -lpixman-1 -lxcb-render -lxcb-shm -lglib-2.0 -lffi -lpthread -lxml2 -lrt' i3bar_LIBS='-L/usr/local/lib -lxcb -lxcb-randr -lxcb-util -lpangocairo-1.0 -lpango-1.0 -lgobject-2.0 -lcairo -lXau -lpangoft2-1.0 -lfontconfig -lfreetype -lgmodule-2.0 -lpixman-1 -lxcb-render -lxcb-shm -lev -lyajl_s -lxcb-xkb -lXau -lglib-2.0 -lffi -lpthread -lxml2 -lrt' i3_dump_log_LIBS='-L/usr/local/lib -lxcb -lxcb-util -lXau' && sudo make install
