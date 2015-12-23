#!/bin/bash

sudo yum update -y

cat <<'EOH' | sudo tee /etc/yum.repos.d/gollob.repo &>/dev/null
[gollob]
name=gollob
baseurl=http://yum.gollob.net/
enabled=1
gpgcheck=0
EOH

sudo yum install -y epel-release
sudo yum install -y i3{,status}
sudo yum groupinstall -y 'X Window System' 'Fonts'
sudo yum install -y gdm rxvt-unicode-256color dmenu
sudo yum install -y kernel-devel

git clone git://github.com/mattness/dotfiles.git $HOME/.dotfiles && ${_}/install <<<'B'
curl -s https://gist.githubusercontent.com/mattness/ff46991267975693aecc/raw/4b4d6ed2ab3223fdb0433fc537dcbba38168380d/gistfile1.txt > $HOME/.Xresources

sudo sed -i 's/id:3/id:5/' /etc/inittab
sudo telinit 5
