# Use ARG to specify the base image
ARG BASE_IMAGE=python:latest
FROM ${BASE_IMAGE}

# Set environment variables to ensure non-interactive installation
ENV DEBIAN_FRONTEND=noninteractive

# Update the package list and install dependencies
RUN apt-get update && \
    apt-get install -y zsh curl git man tmux ripgrep && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY .zshrc /root/
COPY .p10k.zsh /root/
COPY configure.sh /tmp/
COPY .gitconfig /root/

# Install oh-my-zsh
RUN KEEP_ZSHRC="yes" CHSH="yes" RUNZSH="no" sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
    && git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $HOME/.oh-my-zsh/custom/themes/powerlevel10k

SHELL ["/bin/zsh", "-l", "-c"]

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash \
    && . ~/.nvm/nvm.sh \
    && nvm install 20 \
    && nvm use 20

RUN . ~/.zshrc && /tmp/configure.sh

WORKDIR /root

# Launch directly into tmux
CMD ["tmux", "-2"]
