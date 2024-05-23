# Use ARG to specify the base image
ARG BASE_IMAGE=python:latest
FROM ${BASE_IMAGE}

# Set environment variables to ensure non-interactive installation
ENV DEBIAN_FRONTEND=noninteractive

# Update the package list and install dependencies
RUN apt-get update && \
    apt-get install -y zsh curl git man && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY .zshrc /root/
COPY .p10k.zsh /root/
COPY configure.sh /tmp/

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash \
    && . ~/.nvm/nvm.sh \
    && nvm install --lts \
    && nvm use --lts

SHELL ["/bin/zsh", "-c"]

RUN /tmp/configure.sh

# Set zsh as the default shell
CMD ["zsh"]
