
FROM --platform=linux/amd64 ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV TERM=xterm-256color

RUN apt-get update && apt-get install -y --no-install-recommends \
    bash zsh zsh-autosuggestions zsh-syntax-highlighting \
    neovim vim nano tmux htop btop \
    git curl wget ca-certificates gnupg \
    python3 python3-pip python3-venv \
    build-essential gcc g++ make cmake pkg-config \
    rustc cargo \
    iproute2 iputils-ping dnsutils net-tools \
    openssh-client rsync unzip zip xz-utils \
    jq tree less file procps lsof \
    sudo locales tzdata \
    && locale-gen en_US.UTF-8 \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/zsh exp1o5ive \
    && usermod -aG sudo exp1o5ive \
    && printf 'exp1o5ive ALL=(ALL) NOPASSWD:ALL\n' > /etc/sudoers.d/exp1o5ive \
    && chmod 0440 /etc/sudoers.d/exp1o5ive

RUN mkdir -p /home/exp1o5ive/.config/nvim \
    && chown -R exp1o5ive:exp1o5ive /home/exp1o5ive

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

USER exp1o5ive
WORKDIR /home/exp1o5ive

ENV HOME=/home/exp1o5ive
ENV SHELL=/bin/zsh

CMD ["sleep", "infinity"]
