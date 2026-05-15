# Development environment based on NVIDIA CUDA with Ubuntu 24.04
# Base image includes CUDA Toolkit, cuDNN, and GPU development libraries
FROM nvidia/cuda:12.8.2-devel-ubuntu24.04

# Build arguments for user ID customization
ARG USER_UID=1000
ARG USER_GID=1000

# Build arguments for tool versions
ARG GO_VERSION=1.26.3

# Use existing ubuntu user (UID 1000) from base image
# Rename to devuser for consistency with VM environment
RUN usermod -l devuser ubuntu && \
  groupmod -n devuser ubuntu && \
  usermod -d /home/devuser -m devuser && \
  mkdir -p /home/devuser/app && chown ${USER_UID}:${USER_GID} /home/devuser/app

WORKDIR /home/devuser/app
# ============================================================================
# PHASE 1: Root - System Packages (minimal for brew)
# ============================================================================
# Install minimal system packages required for Homebrew and basic functionality
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y \
  # Required for Homebrew
  build-essential \
  procps \
  curl \
  file \
  git \
  # Not available in Homebrew (Linux)
  sudo \
  && rm -rf /var/lib/apt/lists/*

# Configure sudo for devuser (after sudo package is installed)
RUN echo 'devuser ALL=(ALL:ALL) NOPASSWD: ALL' > /etc/sudoers.d/devuser && \
  chmod 0440 /etc/sudoers.d/devuser && \
  usermod -aG sudo devuser

# Install Homebrew (Linuxbrew) as root for system-wide availability
RUN curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | bash
ENV PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:$PATH"
ENV HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew"
ENV HOMEBREW_CELLAR="/home/linuxbrew/.linuxbrew/Cellar"
ENV HOMEBREW_REPOSITORY="/home/linuxbrew/.linuxbrew/Homebrew"

# Install most packages via Homebrew for portability
RUN brew update && brew install \
  # Build tools
  cmake \
  make \
  # Version control
  git-lfs \
  # Network tools
  wget \
  htop \
  iputils \
  nmap \
  net-tools \
  # CLI tools
  fd \
  ripgrep \
  bat \
  git-delta \
  glow \
  # System tools
  gnupg \
  jq \
  rsync \
  unzip \
  # Shell & editors
  zsh \
  direnv \
  neovim \
  # SSH server
  openssh \
  # Additional tools
  k9s \
  ytt \
  kubectl \
  helm \
  kubelogin


# Install Oh My Zsh for root (will be copied to skeleton)
RUN HOME=/root USER=root sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended && \
  cp /root/.zshrc /etc/skel/.zshrc

# Install Go (system-wide, multi-architecture support)
RUN ARCH=$(uname -m | sed 's/x86_64/amd64/; s/aarch64/arm64/') && \
  curl -sL https://go.dev/dl/go${GO_VERSION}.linux-${ARCH}.tar.gz -o /tmp/go.tar.gz && \
  tar -xzf /tmp/go.tar.gz -C /usr/local && \
  rm -rf /tmp/go.tar.gz
ENV PATH="/usr/local/go/bin:$PATH"
ENV GOPATH="/home/devuser/go"
ENV PATH="$GOPATH/bin:$PATH"

# Set CUDA environment variables (from base image)
ENV PATH="/usr/local/cuda/bin:$PATH"
ENV LD_LIBRARY_PATH="/usr/local/cuda/lib64:$LD_LIBRARY_PATH"
ENV CUDA_HOME="/usr/local/cuda"
ENV CUDA_PATH="/usr/local/cuda"

# ============================================================================
# PHASE 2: Non-Root User - Application Tools
# ============================================================================
USER devuser

RUN git clone https://github.com/Hnatekmar/lazyvim.git ~/.config/nvim 

# Install NVM and Node.js (as devuser)
RUN cd /home/devuser && export NVM_DIR="/home/devuser/.nvm" && curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash && \
  . "$NVM_DIR/nvm.sh" && \
  nvm install --lts && \
  nvm alias default lts/*

# Install Bun (as devuser)
RUN curl -fsSL https://bun.sh/install | bash

# Install UV (as devuser)
RUN curl -LsSf https://astral.sh/uv/0.10.7/install.sh | sh

# Install Homebrew for devuser (if not already available from root installation)
RUN if [ ! -d "/home/linuxbrew/.linuxbrew" ]; then \
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" < /dev/null; \
  fi

# Install global npm packages (as devuser)
RUN . "$HOME/.nvm/nvm.sh" && \
  ~/.bun/bin/bun add -g @mariozechner/pi-coding-agent


# ============================================================================
# PHASE 3: Shell Configuration (as root)
# ============================================================================
USER root

# Create dev environment PATH script (sourced by zsh via zshenv)
RUN echo '# Development environment PATH exports' > /etc/profile.d/dev-path.sh && \
  echo 'export NVM_DIR="/home/devuser/.nvm"' >> /etc/profile.d/dev-path.sh && \
  echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> /etc/profile.d/dev-path.sh && \
  echo 'export PATH="/home/devuser/.nvm/versions/node/lts/bin:$PATH"' >> /etc/profile.d/dev-path.sh && \
  echo 'export PATH="/home/devuser/.bun/bin:$PATH"' >> /etc/profile.d/dev-path.sh && \
  echo 'export PATH="/home/devuser/.local/bin:$PATH"' >> /etc/profile.d/dev-path.sh && \
  echo 'export PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:$PATH"' >> /etc/profile.d/dev-path.sh && \
  echo 'export HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew"' >> /etc/profile.d/dev-path.sh && \
  echo 'export HOMEBREW_CELLAR="/home/linuxbrew/.linuxbrew/Cellar"' >> /etc/profile.d/dev-path.sh && \
  echo 'export HOMEBREW_REPOSITORY="/home/linuxbrew/.linuxbrew/Homebrew"' >> /etc/profile.d/dev-path.sh && \
  chmod +x /etc/profile.d/dev-path.sh

# Add NVM_DIR to profile.d for consistency
RUN echo 'export NVM_DIR=/home/devuser/.nvm' > /etc/profile.d/dev-tools.sh && \
  chmod +x /etc/profile.d/dev-tools.sh

# Disable openspec telemetry
RUN echo 'export OPENSPEC_TELEMETRY=0' > /etc/profile.d/disable_openspec_telemetry.sh

# Source profile.d scripts in zshenv for all zsh invocations
RUN mkdir -p /etc/zsh && \
  echo 'for script in /etc/profile.d/*.sh; do [ -f "$script" ] && source "$script"; done' >> /etc/zsh/zshenv

# Source profile.d scripts in bash.bashrc for all interactive bash shells
RUN echo 'for script in /etc/profile.d/*.sh; do [ -f "$script" ] && source "$script"; done' >> /etc/bash.bashrc

# Install Oh My Zsh for devuser
USER devuser
RUN curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | HOME=/home/devuser bash -s -- --unattended
USER root
# Configure devuser's .zshrc - prepend profile.d sourcing after Oh My Zsh installation
RUN { echo '# Source profile.d scripts for PATH and environment variables'; \
  echo 'for script in /etc/profile.d/*.sh; do [ -f "$script" ] && source "$script"; done'; \
  echo ''; \
  cat /home/devuser/.zshrc; \
  echo ''; \
  echo '# direnv hook for automatic environment variable loading'; \
  echo 'eval "$(direnv hook zsh)"'; } > /tmp/zshrc.new && \
  mv /tmp/zshrc.new /home/devuser/.zshrc && \
  cp /home/devuser/.zshrc /etc/skel/.zshrc && \
  chown ${USER_UID}:${USER_GID} /home/devuser/.zshrc


WORKDIR /home/devuser/app

COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

USER devuser

# Configure .zprofile for login shells to source profile.d and direnv
RUN echo '# Source profile.d scripts for login shells' > ~/.zprofile && \
  echo 'for script in /etc/profile.d/*.sh; do [ -f "$script" ] && source "$script"; done' >> ~/.zprofile && \
  echo '' >> ~/.zprofile && \
  direnv hook zsh >> ~/.zprofile

# Note: kubelogin is now installed via brew in PHASE 1

# Install pi extensions and openspec (as devuser)
RUN cd /home/devuser && export NVM_DIR="$HOME/.nvm" && \
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" && \
  ~/.bun/bin/pi install npm:@tintinweb/pi-subagents

COPY --chown=${USER_UID}:${USER_GID} ./models.json /home/devuser/.pi/agent/models.json

ENTRYPOINT ["/entrypoint.sh"]
