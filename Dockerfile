
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV TERM=xterm-256color
ENV HOME=/home/exp1o5ive
ENV SHELL=/bin/zsh
ENV DISPLAY=:1
ENV CHROME_BIN=/usr/bin/google-chrome

RUN apt-get update && apt-get install -y --no-install-recommends \
    bash zsh zsh-autosuggestions zsh-syntax-highlighting \
    neovim vim nano tmux htop btop \
    git curl wget ca-certificates gnupg \
    python3 python3-pip python3-venv \
    build-essential gcc g++ make cmake pkg-config \
    rustc cargo \
    iproute2 iputils-ping dnsutils net-tools \
    openssh-client rsync unzip zip xz-utils \
    jq tree less file procps lsof sudo locales tzdata \
    xfce4 xfce4-terminal xfce4-session xfce4-panel xfdesktop4 xfwm4 \
    dbus-x11 xauth x11-xserver-utils xterm \
    tigervnc-standalone-server tigervnc-common novnc websockify \
    util-linux fonts-liberation fonts-noto-color-emoji \
    && locale-gen en_US.UTF-8 \
    && rm -rf /var/lib/apt/lists/*

RUN install -d -m 0755 /etc/apt/keyrings \
    && curl -fsSL https://dl.google.com/linux/linux_signing_key.pub \
       | gpg --dearmor -o /etc/apt/keyrings/google-chrome.gpg \
    && chmod 0644 /etc/apt/keyrings/google-chrome.gpg \
    && echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/google-chrome.gpg] https://dl.google.com/linux/chrome/deb/ stable main" \
       > /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends google-chrome-stable \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/zsh exp1o5ive \
    && usermod -aG sudo exp1o5ive \
    && printf 'exp1o5ive ALL=(ALL) NOPASSWD:ALL\n' > /etc/sudoers.d/exp1o5ive \
    && chmod 0440 /etc/sudoers.d/exp1o5ive \
    && install -d -o exp1o5ive -g exp1o5ive \
       /home/exp1o5ive/.config/nvim \
       /home/exp1o5ive/.vnc \
       /home/exp1o5ive/Downloads \
       /home/exp1o5ive/.local/share/applications

RUN printf '%s\n' \
    'export EDITOR=nvim' \
    'export VISUAL=nvim' \
    'export PAGER=less' \
    'export CLICOLOR=1' \
    'export CARGO_HOME="$HOME/.cargo"' \
    'export PATH="$CARGO_HOME/bin:$HOME/.local/bin:$PATH"' \
    'export HISTFILE="$HOME/.zsh_history"' \
    'HISTSIZE=50000' \
    'SAVEHIST=50000' \
    'setopt APPEND_HISTORY' \
    'setopt HIST_IGNORE_DUPS' \
    'setopt SHARE_HISTORY' \
    'setopt AUTO_CD' \
    'setopt INTERACTIVE_COMMENTS' \
    'autoload -Uz compinit && compinit' \
    '[[ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh' \
    '[[ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh' \
    'PROMPT="%F{red}Exp1o5ive%f%F{white}㉿%f%F{yellow}%n%f %F{cyan}%~%f %(?.%F{green}❯.%F{red}❯)%f "' \
    'alias ll="ls -lah --color=auto"' \
    'alias la="ls -A --color=auto"' \
    'alias cls="clear"' \
    'alias update="sudo apt-get update"' \
    'alias upgrade="sudo apt-get upgrade"' \
    'alias py="python3"' \
    'alias v="nvim"' \
    'alias g="git"' \
    > /home/exp1o5ive/.zshrc \
    && printf '%s\n' \
    'set number' \
    'set relativenumber' \
    'set mouse=a' \
    'set termguicolors' \
    'set expandtab' \
    'set shiftwidth=4' \
    'set tabstop=4' \
    'set smartindent' \
    'set cursorline' \
    'set clipboard=unnamedplus' \
    > /home/exp1o5ive/.config/nvim/init.vim \
    && chown -R exp1o5ive:exp1o5ive /home/exp1o5ive

RUN printf '%s\n' \
    '#!/bin/sh' \
    'exec dbus-launch --exit-with-session startxfce4' \
    > /usr/local/bin/xfce-session \
    && chmod 0755 /usr/local/bin/xfce-session

RUN printf '%s\n' \
    '[Desktop Entry]' \
    'Version=1.0' \
    'Type=Application' \
    'Name=Google Chrome' \
    'Exec=/usr/bin/google-chrome --no-sandbox --disable-dev-shm-usage --user-data-dir=/home/exp1o5ive/.config/google-chrome %U' \
    'Terminal=false' \
    'Categories=Network;WebBrowser;' \
    > /home/exp1o5ive/.local/share/applications/google-chrome.desktop \
    && chown -R exp1o5ive:exp1o5ive /home/exp1o5ive/.local

RUN cat > /usr/local/bin/start-desktop <<'EOF'
#!/usr/bin/env bash
set -Eeuo pipefail

: "${PORT:=8080}"

if [[ -z "${VNC_PASSWORD:-}" ]]; then
    echo "ERROR: Configure VNC_PASSWORD in Railway Variables."
    exit 1
fi

if [[ "${#VNC_PASSWORD}" -lt 8 ]]; then
    echo "ERROR: VNC_PASSWORD must contain at least 8 characters."
    exit 1
fi

install -d -o exp1o5ive -g exp1o5ive /home/exp1o5ive/.vnc

printf '%s' "${VNC_PASSWORD:0:8}" \
    | su -s /bin/bash exp1o5ive -c \
      'vncpasswd -f > "$HOME/.vnc/passwd"'

chmod 600 /home/exp1o5ive/.vnc/passwd
chown exp1o5ive:exp1o5ive /home/exp1o5ive/.vnc/passwd

su -s /bin/bash exp1o5ive -c \
  'tigervncserver :1 -localhost yes -rfbport 5901 -geometry 1600x900 -depth 24 -SecurityTypes VncAuth -PasswordFile "$HOME/.vnc/passwd" -xstartup /usr/local/bin/xfce-session'

sleep 2

if ! pgrep -u exp1o5ive -f Xtigervnc >/dev/null; then
    echo "ERROR: TigerVNC failed to start."
    exit 1
fi

exec runuser -u exp1o5ive -- websockify \
    --web=/usr/share/novnc \
    --heartbeat=30 \
    "0.0.0.0:${PORT}" \
    localhost:5901
EOF

RUN chmod 0755 /usr/local/bin/start-desktop

WORKDIR /home/exp1o5ive

EXPOSE 8080

CMD ["/usr/local/bin/start-desktop"]
