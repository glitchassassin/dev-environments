#! /usr/bin/env zsh
set -ex 

cd /tmp/

node --version
npm --version

ARCH=$(uname -m)
if [ "$ARCH" = "x86_64" ]; then
  NVIMEXT="x86_64"
  FDEXT="amd64"
else
  NVIMEXT="arm64"
  FDEXT="arm64"
fi

# Install neovim from archive
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-${NVIMEXT}.tar.gz
rm -rf /opt/nvim
tar -C /opt -xzf nvim-linux-${NVIMEXT}.tar.gz
NVIM_DIR="nvim-linux-${NVIMEXT}"
ln -s /opt/${NVIM_DIR}/bin/nvim /usr/bin/nvim

# Install fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# Install lazygit
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_${NVIMEXT}.tar.gz"
tar xf lazygit.tar.gz lazygit
install lazygit /usr/local/bin
mkdir -p /root/.config/lazygit/
touch /root/.config/lazygit/config.yml

# Install fd
FD_VERSION=$(curl -s "https://api.github.com/repos/sharkdp/fd/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
echo "fd version: ${FD_VERSION}"
curl -Lo fd.deb "https://github.com/sharkdp/fd/releases/latest/download/fd_${FD_VERSION}_${FDEXT}.deb"
dpkg -i fd.deb

# Install OpenAI Codex CLI
echo "Installing OpenAI Codex CLI..."
npm install -g @openai/codex

# Add GitHub SSH host key to known_hosts
echo "Adding GitHub SSH host key..."
mkdir -p ~/.ssh
ssh-keyscan github.com >> ~/.ssh/known_hosts

# clone nvim config via HTTPS (SSH keys aren't available until runtime)
git clone https://github.com/glitchassassin/nvim-config.git ~/.config/nvim
cd ~/.config/nvim
git remote set-url origin git@github.com:glitchassassin/nvim-config.git

# clone tmux config via HTTPS (SSH keys aren't available until runtime)
git clone https://github.com/glitchassassin/tmux.git ~/.config/tmux
cd ~/.config/tmux
git remote set-url origin git@github.com:glitchassassin/tmux.git

# install tmux plugins
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
~/.tmux/plugins/tpm/bin/install_plugins

nvim --headless -c "Lazy! sync" -c "sleep 45" -c "qa"

