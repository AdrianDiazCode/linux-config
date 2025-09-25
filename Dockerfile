# Use Ubuntu as base image for testing the install-deps.sh script
FROM ubuntu:22.04

# Set environment variables to avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive
ENV NONINTERACTIVE=1

# Update package list and install basic dependencies
RUN apt-get update && apt-get install -y \
    sudo \
    curl \
    git \
    build-essential \
    procps \
    file \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user for testing
RUN useradd -m -s /bin/bash testuser && \
    echo "testuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Switch to the test user
USER testuser
WORKDIR /home/testuser

# Copy the install script
COPY install-deps.sh /home/testuser/install-deps.sh

# Make the script executable
RUN sudo chmod +x install-deps.sh

# Run the installation script
RUN ./install-deps.sh

# Set up environment for Homebrew
ENV PATH="/home/linuxbrew/.linuxbrew/bin:${PATH}"

# Default command to verify installations
CMD ["bash", "-c", "echo 'Testing installed tools:' && \
    curl --version && \
    brew --version && \
    nvim --version && \
    tmux -V && \
    zig version && \
    git --version && \
    fzf --version && \
    lazygit --version && \
    rg --version && \
    docker --version"]