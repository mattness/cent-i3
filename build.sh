#!/bin/bash

# Exit on first error
set -e

# Common / i3
sudo yum install -y epel-release gcc gcc-c++ libtool make \
  patch pcre-devel xorg-x11-util-macros xcb-util-keysyms-devel \
  xcb-util-wm-devel startup-notification-devel

sudo yum install -y libev-devel \
  /vagrant/RPMS/x86_64/yajl2{,-devel}-2.0.4-1.el6.x86_64.rpm \
  /vagrant/RPMS/x86_64/xcb-util-cursor{,-devel}-0.1.0-1.el6.x86_64.rpm

# i3status
sudo yum install -y libconfuse-devel alsa-lib-devel wireless-tools-devel \
  asciidoc

sudo mkdir -p -m 775 /src && sudo chown root:vagrant /src

# Build i3
cd /src
curl -s http://i3wm.org/downloads/i3-4.8.tar.bz2 | tar jxf -
curl -sL https://github.com/i3/i3status/archive/2.9.tar.gz | tar zxf -

# i3
cd /src/i3-4.8
# disable pango
patch -p1 <<'EOH'
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
cd /src/i3status-2.9
# Use the static-linked version of libyajl so we don't need a wrapper script
sed -i 's/LIBS+=-lyajl/LIBS+=-lyajl_s/' Makefile
make && sudo make install

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
