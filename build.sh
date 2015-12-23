#!/bin/bash

# Exit on first error
set -e

sudo yum install -y man vim curl git gcc gcc-c++ svn autoconf automake \
  libtool make patch gperf cmake gettext bison gtk-doc libffi-devel \
  zlib-devel libXau-devel libxcb-devel xcb-util-devel xcb-util-image-devel \
  ruby freetype-devel fontconfig-devel libpng-devel pixman-devel \
  startup-notification-devel xcb-util-keysyms-devel xcb-util-wm-devel \
  pcre-devel alsa-lib-devel wireless-tools-devel asciidoc \
  xorg-x11-util-macros-1.17 epel-release

sudo yum install -y libev-devel libconfuse-devel

sudo mkdir -p -m 775 /src && sudo chown root:vagrant /src && cd $_

# Build i3
cd /src
git clone http://anongit.freedesktop.org/git/xcb/util-cursor.git --recursive
# http://xcb.freedesktop.org/dist/xcb-util-cursor-0.1.0.tar.gz
git clone https://github.com/lloyd/yajl.git
# curl -s http://github.com/lloyd/yajl/tarball/2.0.4 | tar zxf -
git clone https://github.com/i3/i3.git
# curl -s https://github.com/i3/i3/archive/4.8.tar.gz | tar zxf -
git clone https://github.com/i3/i3status.git
# curl -s https://github.com/i3/i3status/archive/2.9.tar.gz | tar zxf -
git clone https://github.com/i3/i3lock.git
# curl -s https://github.com/i3/i3lock/archive/2.6.tar.gz | tar zxf -

export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:/usr/local/share/pkgconfig

# util-cursor
cd /src/util-cursor/
git checkout 0.1.0
# export ACLOCAL="aclocal -I /usr/local/share/aclocal"
./autogen.sh
make && sudo make install

# yajl
cd /src/yajl
git checkout 2.0.4
./configure
make && sudo make install

# i3
cd /src/i3
git checkout 4.8
patch -p1 <<'EOH'
diff --git a/common.mk b/common.mk
index b086bc8..fcf9dbf 100644
--- a/common.mk
+++ b/common.mk
@@ -133,11 +133,11 @@ LIBSN_CFLAGS := $(call cflags_for_lib, libstartup-notification-1.0)
 LIBSN_LIBS   := $(call ldflags_for_lib, libstartup-notification-1.0,startup-notification-1)
 
 # Pango
-PANGO_CFLAGS := $(call cflags_for_lib, cairo)
-PANGO_CFLAGS += $(call cflags_for_lib, pangocairo)
-I3_CPPFLAGS  += -DPANGO_SUPPORT=1
-PANGO_LIBS   := $(call ldflags_for_lib, cairo)
-PANGO_LIBS   += $(call ldflags_for_lib, pangocairo)
+# PANGO_CFLAGS := $(call cflags_for_lib, cairo)
+# PANGO_CFLAGS += $(call cflags_for_lib, pangocairo)
+# I3_CPPFLAGS  += -DPANGO_SUPPORT=1
+# PANGO_LIBS   := $(call ldflags_for_lib, cairo)
+# PANGO_LIBS   += $(call ldflags_for_lib, pangocairo)
 
 # libi3
 LIBS = -L$(TOPDIR) -li3 -lm
EOH
make YAJL_LIBS='-lyajl_s' \
  XCURSOR_LIBS="-Wl,-Bstatic -L/usr/local/lib -lxcb-cursor -Wl,-Bdynamic -lxcb-render-util -lxcb-image -lxcb-render -lxcb-shm -lxcb -lXau" \
  && sudo make install

# i3Status
cd /src/i3status
git checkout 2.9
# Use the static-linked version of libyajl so we don't need a wrapper script
sed -i 's/LIBS+=-lyajl/LIBS+=-lyajl_s/' Makefile
make && sudo make install

# i3Lock
# cd /src/i3lock
# git checkout 2.6
# make && sudo make install

# Extra stuff for testing

sudo yum groupinstall -y 'X Window System' 'Fonts'
sudo yum install -y gdm rxvt-unicode-256color dmenu
sudo yum install -y kernel-devel

sudo sed -i 's/id:3/id:5/' /etc/inittab

git clone git://github.com/mattness/dotfiles.git $HOME/.dotfiles && ${_}/install <<<'B'
curl -s https://gist.githubusercontent.com/mattness/ff46991267975693aecc/raw/4b4d6ed2ab3223fdb0433fc537dcbba38168380d/gistfile1.txt > $HOME/.Xresources
# curl -sO http://download.virtualbox.org/virtualbox/5.0.10/VBoxGuestAdditions_5.0.10.iso
# sudo mount /src/VBoxGuestAdditions_5.0.10.iso -o loop /mnt
# sudo /mnt/VBoxLinuxAdditions.run
sudo reboot
