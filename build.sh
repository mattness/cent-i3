#!/bin/bash

# Exit on first error
set -e

sudo yum groupinstall -y "Development Tools"
# sudo yum install -y man vim curl git perl-devel libcurl-devel \
#   openssl-devel zlib-devel gperf cmake \
#   asciidoc xmlto startup-notification-devel gtk-doc \
#   libpng-devel freetype-devel libxml2-devel \
#   docbook-utils-pdf libffi-devel libXext-devel \
#   libX11-devel
sudo yum install -y man vim curl git gperf cmake libxml2-devel \
  libpng-devel gtk-doc

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
git clone https://git.gnome.org/browse/glib
git clone http://anongit.freedesktop.org/git/xorg/util/macros.git
git clone http://anongit.freedesktop.org/git/xcb/proto.git
git clone http://anongit.freedesktop.org/git/xcb/pthread-stubs.git
git clone http://anongit.freedesktop.org/git/xcb/libxcb.git
git clone https://github.com/xkbcommon/libxkbcommon.git
git clone http://anongit.freedesktop.org/git/xcb/util-image.git --recursive
git clone http://anongit.freedesktop.org/git/xcb/util-cursor.git --recursive
git clone http://git.lighttpd.net/libev.git
git clone https://github.com/lloyd/yajl.git
svn co svn://vcs.exim.org/pcre/code/tags/pcre-8.35 pcre
git clone http://anongit.freedesktop.org/git/pixman.git
git clone git://git.sv.nongnu.org/freetype/freetype2.git
git clone http://anongit.freedesktop.org/git/fontconfig
git clone http://anongit.freedesktop.org/git/cairo
curl -s http://www.freedesktop.org/software/harfbuzz/release/harfbuzz-1.1.1.tar.bz2 | tar jxf -
git clone git://git.gnome.org/pango
git clone http://anongit.freedesktop.org/git/xorg/lib/libxtrans.git
git clone http://anongit.freedesktop.org/git/xorg/lib/libX11.git
git clone https://github.com/i3/i3.git
# git clone git://anongit.freedesktop.org/xcb/util /src/xcb-util --recursive
# git clone git://anongit.freedesktop.org/xcb/util-renderutil --recursive
# git clone git://anongit.freedesktop.org/xcb/util-wm --recursive
# git clone git://anongit.freedesktop.org/xcb/util-keysyms --recursive
# curl -s http://dist.schmorp.de/libev/Attic/libev-4.19.tar.gz | tar zxf -

## Build an updated pkgconfig
cd /src/pkg-config
git checkout pkg-config-0.28
./autogen.sh --with-internal-glib
make && sudo make install && hash -r

# TODO(mgollob): i3-env.sh
export ACLOCAL_PATH=/usr/local/share/aclocal-1.11:/usr/local/share/aclocal
# export PKG_CONFIG_LIBDIR=/usr/local/lib/pkgconfig/:/usr/local/lib64/pkgconfig/:/usr/lib/pkgconfig/:/usr/lib64/pkgconfig/
# export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:/usr/local/share/pkgconfig:$PKG_CONFIG_PATH
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:/usr/local/share/pkgconfig:/usr/lib64/pkgconfig:/usr/share/pkgconfig
export LD_LIBRARY_PATH=/usr/local/lib/:/usr/local/lib64/
export LD_RUN_PATH=/usr/local/lib/:/usr/local/lib64/
export ACLOCAL_FLAGS="-I /usr/local/share/aclocal"

# libffi
sudo yum install -y libffi-devel

# glib
cd /src/glib
git checkout 2.33.14
./autogen.sh
make && sudo make install

# Macros
cd /src/macros
git checkout util-macros-1.18.0
./autogen.sh
make && sudo make install
sudo ln -s /usr/local/share/aclocal/xorg-macros.m4 /usr/share/aclocal/xorg-macros.m4

# proto
cd /src/proto
git checkout 1.11
./autogen.sh
make && sudo make install

# pthread-stubs
cd /src/pthread-stubs
git checkout 0.3
./autogen.sh
make && sudo make install

# libXau
sudo yum install -y libXau-devel

# libxcb
cd /src/libxcb/
git checkout 1.11
patch <<'EOH'
diff --git a/autogen.sh b/autogen.sh
index fc34bd5..6a7eb13 100755
--- a/autogen.sh
+++ b/autogen.sh
@@ -6,7 +6,7 @@ test -z "$srcdir" && srcdir=.
 ORIGDIR=`pwd`
 cd $srcdir

-autoreconf -v --install || exit 1
+ACLOCAL="aclocal $ACLOCAL_FLAGS" autoreconf -v --install || exit 1
 cd $ORIGDIR || exit $?

 if test -z "$NOCONFIGURE"; then
EOH
./autogen.sh
make && sudo make install

# # xcb-util
# cd /src/xcb-util
# git checkout 0.3.8
# ./autogen.sh
# make && sudo make install
sudo yum install -y xcb-util{,-devel}

# xkeyboard
# sudo yum install -y xkeyboard-config{,-devel}
# sudo yum install -y xorg-x11-xkb-utils{,-devel}

# xkbcommon
cd /src/libxkbcommon/
git checkout xkbcommon-0.5.0
./autogen.sh
make && sudo make install

# # util-render
# cd /src/util-renderutil/
# git checkout 0.3.9
# ./autogen.sh
# make && sudo make install

# util-image
cd /src/util-image/
git checkout 0.4.0
patch <<'EOH'
diff --git a/autogen.sh b/autogen.sh
index afe5299..9566ac4 100755
--- a/autogen.sh
+++ b/autogen.sh
@@ -21,7 +21,7 @@ then
        fi
 fi

-autoreconf -v --install || exit 1
+ACLOCAL="aclocal $ACLOCAL_FLAGS" autoreconf -v --install || exit 1
 cd $ORIGDIR || exit $?

 $srcdir/configure --enable-maintainer-mode "$@"
EOH
./autogen.sh
make && sudo make install

# util-cursor
cd /src/util-cursor/
git checkout 0.1.2
patch <<'EOH'
diff --git a/autogen.sh b/autogen.sh
index afe5299..9566ac4 100755
--- a/autogen.sh
+++ b/autogen.sh
@@ -21,7 +21,7 @@ then
        fi
 fi

-autoreconf -v --install || exit 1
+ACLOCAL="aclocal $ACLOCAL_FLAGS" autoreconf -v --install || exit 1
 cd $ORIGDIR || exit $?

 $srcdir/configure --enable-maintainer-mode "$@"
EOH
./autogen.sh
make && sudo make install

# # util-wm
# cd /src/util-wm
# git checkout 0.3.8
# ./autogen.sh
# make && sudo make install
sudo yum install -y xcb-util-wm{,-devel}

# # util-keysyms
# cd /src/util-keysyms
# git checkout 0.4.0
# ./autogen.sh
# make && sudo make install
sudo yum install -y xcb-util-keysyms{,-devel}

# libev
# cd /src/libev-4.19
cd /src/libev
git checkout rel-4.19
ACLOCAL="aclocal $ACLOCAL_FLAGS" autoreconf -v --install
./configure
make && sudo make install

# yajl
cd /src/yajl
git checkout 2.1.0
./configure
make && sudo make install

# pcre
cd /src/pcre
./autogen.sh
./configure && make && sudo make install

# pixman
cd /src/pixman
git checkout pixman-0.30.2
./autogen.sh
make && sudo make install

# freetype2
cd /src/freetype2
git checkout VER-2-6-2
./autogen.sh && ./configure
make && sudo make install

# docbook2pdf
sudo yum install -y docbook-utils-pdf

# fontconfig
cd /src/fontconfig
git checkout 2.10.95
./autogen.sh --enable-libxml2
make && sudo make install

# cairo
cd /src/cairo
git checkout 1.14.4
./autogen.sh
make && sudo make install

# harfbuzz
cd /src/harfbuzz-1.1.1
./configure && make && sudo make install

# pango
cd /src/pango
git checkout 1.36.8
./autogen.sh
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

# libsn
sudo yum install -y startup-notification-devel

# libxtrans
cd /src/libxtrans
git checkout xtrans-1.3.5
./autogen.sh
make && sudo make install

# libX11
cd /src/libX11
git checkout libX11-1.6.3
./autogen.sh
make && sudo make install

# i3
cd /src/i3
git checkout 4.11
make && sudo make install
