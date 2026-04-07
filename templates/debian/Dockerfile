# Development environment based on Debian Trixie
FROM debian:13-slim
ENV HOME=/root
ENV USER=root
WORKDIR /app
# Install development tools
RUN apt-get update && apt-get install -y \
  # Build tools
  build-essential \
  cmake \
  gcc \
  g++ \
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
  # Shell & editors
  zsh \
  kitty-terminfo \
  && rm -rf /var/lib/apt/lists/*

# Install neovim v0.12.1
RUN curl -sL https://github.com/neovim/neovim/releases/download/v0.12.1/nvim-linux-x86_64.tar.gz -o /tmp/nvim.tar.gz && \
  tar -xzf /tmp/nvim.tar.gz --strip-components=1 --overwrite -C /usr && \
  rm -rf /tmp/nvim.tar.gz && \
  git clone https://github.com/Hnatekmar/lazyvim.git ~/.config/nvim && nvim --headless "+Lazy! sync" +qa

# Install Oh My Zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended && \
  cp /root/.zshrc /etc/skel/.zshrc

# Install k9s
RUN curl -sS -L https://github.com/derailed/k9s/releases/download/v0.32.5/k9s_Linux_amd64.tar.gz -o /tmp/k9s.tar.gz \
  && tar -xzf /tmp/k9s.tar.gz -C /tmp \
  && mv /tmp/k9s /usr/local/bin/ \
  && chmod +x /usr/local/bin/k9s \
  && rm -rf /tmp/k9s.tar.gz /tmp/k9s

# Install Carvel ytt
RUN curl -Lo /tmp/ytt https://github.com/carvel-dev/ytt/releases/download/v0.47.0/ytt-linux-amd64 \
  && mv /tmp/ytt /usr/local/bin/ytt \
  && chmod +x /usr/local/bin/ytt

# Install kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
  && chmod +x kubectl \
  && mv kubectl /usr/local/bin/ \
  && rm -f kubectl

# Install NVM and Node.js
# Note: PATH added to /etc/profile for all shells (SSH, interactive, etc.)
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash && \
  . "$HOME/.nvm/nvm.sh" && \
  nvm install --lts && \
  nvm alias default lts/* && \
  NODE_VERSION=$(nvm version default) && \
  echo 'export NVM_DIR="/root/.nvm"' >> /etc/profile && \
  echo '[ -s "$NVM_DIR/nvm.sh" ] && \\. "$NVM_DIR/nvm.sh"' >> /etc/profile && \
  echo 'export PATH="/root/.nvm/versions/node/'${NODE_VERSION}'/bin:$PATH"' >> /etc/profile

# Install Bun
RUN curl -fsSL https://bun.sh/install | bash && \
  echo 'export PATH="/root/.bun/bin:$PATH"' >> /etc/profile
# Remove redundant apt-based Node.js installation (NVM handles this)

# Install pi.dev coding agent
RUN ~/.bun/bin/bun add -g @mariozechner/pi-coding-agent


# Install UV
RUN curl -LsSf https://astral.sh/uv/0.10.7/install.sh | sh && \
  echo 'export PATH="/root/.local/bin:$PATH"' >> /etc/profile

# Add NVM_DIR to profile.d for consistency
RUN echo 'export NVM_DIR=/root/.nvm' > /etc/profile.d/dev-tools.sh && \
  chmod +x /etc/profile.d/dev-tools.sh
COPY ./models.yml /root/.omp/agent/models.yml
COPY ./models.json /root/.pi/agent/models.json

# Source profile.d scripts in zshenv for all zsh invocations
RUN echo 'for script in /etc/profile.d/*.sh; do [ -f "$script" ] && source "$script"; done' >> /etc/zsh/zshenv

# Ensure zsh sources bashrc (where NVM/Bun are configured)
RUN echo 'source ~/.bashrc' >> ~/.zshrc

WORKDIR /root/app
# Copy and setup entrypoint script
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

RUN . ~/.bashrc && nvm install 24 && nvm use 24 && \
  pi install git:github.com/tmustier/pi-extensions

# Set entrypoint
ENTRYPOINT ["/entrypoint.sh"]
