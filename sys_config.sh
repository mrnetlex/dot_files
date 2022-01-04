#! /bin/sh

#add chaotic aur
sudo pacman-key --recv-key FBA220DFC880C036 --keyserver keyserver.ubuntu.com
sudo pacman-key --lsign-key FBA220DFC880C036
sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
sudo echo '[chaotic-aur]
Include = /etc/pacman.d/chaotic-mirrorlist' >> /etc/pacman.conf

#get fastest mirrors
sudo pacman -S reflector
sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist

#update sysytem
sudo pacman -Syuu
sudo yay -S pamac-aur paru
sudo paru -R yay
sudo paru -Syuu

#install packages
sudo pamac install libreoffice-fresh brave-beta-bin bat  ardour caprine discord celluloid ufw gimp kitty micro lutris mpv obs-studio steam ani-cli-git badlion-client btop btrfs-assistant cmatrix cpupower-git exa fd fish gamemode lf lolcat mangohud neofetch plocate snapper speedtest-cli spotify starship tealdeer teams tree ttf-ms-fonts wine winetricks 

#remove orphanes
sudo pamac remove -o

#enable firewall
sudo ufw enable

#install oh-my-fish and install bang-bang
curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish
omf install bang-bang

clear
pfetch
