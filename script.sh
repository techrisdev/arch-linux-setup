#!/bin/sh
# Script base
INSTALL_COMMAND="sudo pacman -S"
echo_stage() {
	echo "-- $1 --"
}

echo "Assuming you're a normal user and sudo is installed and configured (THE USER SHOULD BE IN THE SUDO GROUP OR ALTERNATIVELY IN THE WHEEL GROUP!)"
echo "Assuming you're in the arch-linux-setup directory"

# Prepare system
sudo pacman -Syu
$INSTALL_COMMAND --needed base-devel

# Get packages to install
PACKAGES="$(cat packages)"
echo_stage "PACKAGES"
$INSTALL_COMMAND $PACKAGES

if [ "$(find . -name "JetBrains Mono Regular Nerd Font Complete.ttf" | wc -l)" = "0" ]; then
echo_stage "FONT"
wget "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/JetBrainsMono.zip"
unzip JetBrainsMono.zip -d JetBrainsMono
mkdir -p ~/.local/share/fonts
mv JetBrainsMono/*.ttf ~/.local/share/fonts
fi

echo_stage "INSTALL PARU (AUR HELPER)"
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
cd ..

echo_stage "AUR PACKAGES"
paru -S "$(cat aur_packages)"

echo_stage "DOTFILES"

echo_stage "SHELL"
# Set the default shell to fish
echo "Changing the default shell. Your password will be required."
chsh -s /usr/bin/fish

echo "For cleanup, run ./cleanup"
