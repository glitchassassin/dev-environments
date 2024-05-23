#! /usr/bin/env zsh
set -e 

cd /tmp/

node --version
npm --version

# Install neovim from appimage
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage
./nvim.appimage --appimage-extract > /dev/null 2>&1

mv squashfs-root / > /dev/null 2>&1
ln -s /squashfs-root/AppRun /usr/bin/nvim

# Install lazygit
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
install lazygit /usr/local/bin

# Install ripgrep
RIPGREP_VERSION=$(curl -s "https://api.github.com/repos/BurntSushi/ripgrep/releases/latest" | grep -Po '"tag_name": "\K[^"]*')
echo "Ripgrep version: ${RIPGREP_VERSION}"
curl -Lo ripgrep.deb "https://github.com/BurntSushi/ripgrep/releases/latest/download/ripgrep_${RIPGREP_VERSION}-1_amd64.deb"
dpkg -i ripgrep.deb

# Install fd
FD_VERSION=$(curl -s "https://api.github.com/repos/sharkdp/fd/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
echo "fd version: ${FD_VERSION}"
curl -Lo fd.deb "https://github.com/sharkdp/fd/releases/latest/download/fd_${FD_VERSION}_amd64.deb"
dpkg -i fd.deb

# clone config
git clone -b v10 https://github.com/glitchassassin/nvim-config ~/.config/nvim

nvim --headless -c "Lazy! sync" -c "sleep 45" -c "qa"

