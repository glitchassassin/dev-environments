# Use ARG to specify the base image
ARG BASE_IMAGE=python:latest
FROM ${BASE_IMAGE}

# Set environment variables to ensure non-interactive installation
ENV DEBIAN_FRONTEND=noninteractive

# Update the package list and install zsh
RUN apt-get update && \
    apt-get install -y zsh curl git man && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY configure.sh /tmp/
RUN /tmp/configure.sh

# Set zsh as the default shell
CMD ["zsh"]
