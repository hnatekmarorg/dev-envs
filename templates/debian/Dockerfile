# Development environment based on Debian Trixie
FROM debian:13-slim

# Build arguments for user ID customization
ARG USER_UID=1000
ARG USER_GID=1000

# Create non-root user with custom UID/GID
RUN groupadd -g ${USER_GID} -r devuser && useradd -r -g devuser -u ${USER_UID} -m -d /home/devuser devuser
RUN mkdir -p /home/devuser/app && chown ${USER_UID}:${USER_GID} /home/devuser/app

WORKDIR /home/devuser/app
# ============================================================================
# PHASE 1: Root - System Packages
# ============================================================================
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y \
  # Build tools
  build-essential \
  cmake \
  gcc \
  g++ \
  sudo \
  make \
  # Version control
  git \
  git-lfs \
  # Network tools
  curl \
  wget \
  htop \
  iputils-ping \
  nmap \
  net-tools \
  fd-find \
  ripgrep \
  bat \
  git-delta \
  glow \
  # System tools
  jq \
  rsync \
  tar \
  unzip \
  procps \
  # Shell & editors
  zsh \
  kitty-terminfo \
  direnv \
  # SSH server
  openssh-server \
  && rm -rf /var/lib/apt/lists/*

# Configure sudo for devuser (after sudo package is installed)
RUN echo 'devuser ALL=(ALL:ALL) NOPASSWD: ALL' > /etc/sudoers.d/devuser && \
  chmod 0440 /etc/sudoers.d/devuser && \
  usermod -aG sudo devuser

# Install neovim v0.12.1 (system-wide)
RUN curl -sL https://github.com/neovim/neovim/releases/download/v0.12.1/nvim-linux-x86_64.tar.gz -o /tmp/nvim.tar.gz && \
  tar -xzf /tmp/nvim.tar.gz --strip-components=1 --overwrite -C /usr && \
  rm -rf /tmp/nvim.tar.gz && \
  mkdir -p /root/.config


# Install Oh My Zsh for root (will be copied to skeleton)
RUN HOME=/root USER=root sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended && \
  cp /root/.zshrc /etc/skel/.zshrc

# Install k9s (system-wide)
RUN curl -sS -L https://github.com/derailed/k9s/releases/download/v0.32.5/k9s_Linux_amd64.tar.gz -o /tmp/k9s.tar.gz \
  && tar -xzf /tmp/k9s.tar.gz -C /tmp \
  && mv /tmp/k9s /usr/local/bin/ \
  && chmod +x /usr/local/bin/k9s \
  && rm -rf /tmp/k9s.tar.gz /tmp/k9s

# Install Carvel ytt (system-wide)
RUN curl -Lo /tmp/ytt https://github.com/carvel-dev/ytt/releases/download/v0.47.0/ytt-linux-amd64 \
  && mv /tmp/ytt /usr/local/bin/ytt \
  && chmod +x /usr/local/bin/ytt

# Install kubectl (system-wide)
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
  && chmod +x kubectl \
  && mv kubectl /usr/local/bin/ \
  && rm -f kubectl

# Install Helm (system-wide)
RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 && \
  chmod 700 get_helm.sh && \
  ./get_helm.sh && \
  rm -f get_helm.sh

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

# Install Homebrew (Linuxbrew as devuser)
RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" < /dev/null

# Install global npm packages (as devuser)
RUN . "$HOME/.nvm/nvm.sh" && \
  ~/.bun/bin/bun add -g @mariozechner/pi-coding-agent

# Install pi extensions and openspec (as devuser)
RUN cd /home/devuser && export NVM_DIR="$HOME/.nvm" && \
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" && \
  ~/.bun/bin/pi install git:github.com/tmdgusya/pi-engineering-discipline-extension 

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
  echo 'export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"' >> /etc/profile.d/dev-path.sh && \
  chmod +x /etc/profile.d/dev-path.sh

# Add NVM_DIR to profile.d for consistency
RUN echo 'export NVM_DIR=/home/devuser/.nvm' > /etc/profile.d/dev-tools.sh && \
  chmod +x /etc/profile.d/dev-tools.sh

# Disable openspec telemetry
RUN echo 'export OPENSPEC_TELEMETRY=0' > /etc/profile.d/disable_openspec_telemetry.sh

# Source profile.d scripts in zshenv for all zsh invocations
RUN echo 'for script in /etc/profile.d/*.sh; do [ -f "$script" ] && source "$script"; done' >> /etc/zsh/zshenv

# Install Oh My Zsh for devuser
USER devuser
RUN curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | HOME=/home/devuser bash -s -- --unattended
USER root
# Configure devuser's .zshrc with Oh My Zsh and PATH
RUN # Start with Oh My Zsh default zshrc and prepend PATH source\
  { echo 'source /etc/profile.d/dev-path.sh'; cat /home/devuser/.oh-my-zsh/templates/zshrc.zsh-template; echo ''; echo '# direnv hook for automatic environment variable loading'; echo 'eval "$(direnv hook zsh)"'; } > /home/devuser/.zshrc && \
  cp /home/devuser/.zshrc /etc/skel/.zshrc && \
  chown ${USER_UID}:${USER_GID} /home/devuser/.zshrc


WORKDIR /home/devuser/app

COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

USER devuser

RUN direnv hook zsh >> ~/.zprofile

RUN zsh -c "brew install kubelogin"

COPY --chown=${USER_UID}:${USER_GID} ./models.json /home/devuser/.pi/agent/models.json

ENTRYPOINT ["/entrypoint.sh"]
