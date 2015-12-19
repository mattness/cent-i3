#!/bin/bash

# Exit on first error
set -e

sudo yum install -y man vim curl git gcc gcc-c++ svn autoconf automake \
  libtool make patch gperf cmake gettext bison gtk-doc libffi-devel \
  zlib-devel libXau-devel libxcb-devel xcb-util-devel xcb-util-image-devel \
  ruby freetype-devel fontconfig-devel libpng-devel pixman-devel \
  startup-notification-devel xcb-util-keysyms-devel xcb-util-wm-devel

sudo mkdir -p -m 775 /src && sudo chown root:vagrant /src && cd $_

# Build i3
cd /src
git clone http://anongit.freedesktop.org/git/pkg-config.git
# curl -s http://pkgconfig.freedesktop.org/releases/pkg-config-0.28.tar.gz | tar zxf -
git clone https://git.gnome.org/browse/glib
# curl -s http://ftp.gnome.org/pub/gnome/sources/glib/2.33/glib-2.33.14.tar.xz
git clone http://anongit.freedesktop.org/git/xorg/util/macros.git
# curl -s http://xorg.freedesktop.org/releases/individual/util/util-macros-1.18.0.tar.gz | tar zxf -
git clone http://anongit.freedesktop.org/git/xcb/util-cursor.git --recursive
# http://xcb.freedesktop.org/dist/xcb-util-cursor-0.1.2.tar.gz
git clone http://git.lighttpd.net/libev.git
# curl -s http://dist.schmorp.de/libev/Attic/libev-4.19.tar.gz | tar zxf -
git clone https://github.com/lloyd/yajl.git
# curl -s http://github.com/lloyd/yajl/tarball/2.1.0 | tar zxf -

#######################################################
svn co svn://vcs.exim.org/pcre/code/tags/pcre-8.12 pcre
#######################################################

git clone http://anongit.freedesktop.org/git/cairo
# http://cairographics.org/releases/cairo-1.14.4.tar.xz
git clone git://git.gnome.org/pango
git clone https://github.com/i3/i3.git
# curl -s https://github.com/i3/i3/archive/4.8.tar.gz | tar zxf -
git clone https://github.com/i3/i3status.git
# curl -s https://github.com/i3/i3status/archive/2.8.tar.gz | tar zxf -
git clone https://github.com/i3/i3lock.git
# curl -s https://github.com/i3/i3lock/archive/2.6.tar.gz | tar zxf -

curl -sO http://download.virtualbox.org/virtualbox/5.0.10/VBoxGuestAdditions_5.0.10.iso

## Build an updated pkgconfig
cd /src/pkg-config
git checkout pkg-config-0.25
./autogen.sh
make && sudo make install && hash -r

export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:/usr/local/share/pkgconfig:/usr/lib64/pkgconfig:/usr/share/pkgconfig
export ACLOCAL_PATH=/usr/local/share/aclocal-1.11:/usr/local/share/aclocal
export ACLOCAL_FLAGS='-I /usr/local/share/aclocal'

# glib
cd /src/glib
git checkout 2.31.0
export ACLOCAL="aclocal -I /usr/local/share/aclocal"
./autogen.sh
make && sudo make install

# Macros
cd /src/macros
git checkout util-macros-1.18.0
export ACLOCAL="aclocal -I /usr/local/share/aclocal"
./autogen.sh
make && sudo make install

# util-cursor
cd /src/util-cursor/
git checkout 0.1.0
export ACLOCAL="aclocal -I /usr/local/share/aclocal"
./autogen.sh
make && sudo make install

# libev
# cd /src/libev-4.19
cd /src/libev
git checkout rel-4.11
export ACLOCAL="aclocal -I /usr/local/share/aclocal"
autoreconf -v --install && ./configure
make && sudo make install

# yajl
cd /src/yajl
git checkout 2.0.4
./configure
make && sudo make install

# pcre
cd /src/pcre
export ACLOCAL="aclocal -I /usr/local/share/aclocal"
./autogen.sh
./configure && make && sudo make install

# cairo
cd /src/cairo
git checkout 1.12.2
export ACLOCAL="aclocal -I /usr/local/share/aclocal"
./autogen.sh
make && sudo make install

# pango
cd /src/pango
git checkout 1.30.0
export ACLOCAL="aclocal -I /usr/local/share/aclocal"
./autogen.sh
make && sudo make install

# i3
cd /src/i3
git checkout 4.8
make && sudo make install

# i3Status
# cd /src/i3status
# git checkout 2.8
# make PREFIX=/opt/i3 && sudo make install PREFIX=/opt/i3

# i3Lock
# cd /src/i3lock
# git checkout 2.6
# make PREFIX=/opt/i3 && sudo make install PREFIX=/opt/i3

# Extra stuff for testing

sudo yum install -y epel-release
sudo yum groupinstall -y 'X Window System' 'Fonts' 'Desktop Platform'
sudo yum install -y gdm rxvt-unicode-256color dmenu
sudo yum install -y kernel-devel

# sudo tee /etc/sysconfig/desktop <<'EOH' > /dev/null
# DISPLAYMANAGER=XDM
# EOH

sudo tee /usr/local/bin/i3 <<'EOH' > /dev/null
#!/bin/bash

export LD_LIBRARY_PATH=/usr/local/lib
/usr/bin/i3
EOH

sudo chmod +x /usr/local/bin/i3
sudo sed -i 's%Exec=i3%Exec=/usr/local/bin/i3%' /usr/share/xsessions/i3.desktop
sudo sed -i 's/id:3/id:5/' /etc/inittab
# sudo mount /src/VBoxGuestAdditions_5.0.10.iso -o loop /mnt
# sudo /mnt/VBoxLinuxAdditions.run
sudo reboot
