FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive \
    TERM=xterm-256color \
    LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8

RUN apt-get update && apt-get install -y --no-install-recommends \
    openssh-server \
    openssh-client \
    zsh \
    git \
    curl \
    wget \
    vim \
    nano \
    htop \
    neofetch \
    locales \
    ca-certificates \
    sudo \
    lsof \
    net-tools \
    iputils-ping \
    procps \
    && locale-gen en_US.UTF-8 \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/zsh Exp1o5ive && \
    echo "Exp1o5ive:exp1o5ive@@1212" | chpasswd && \
    echo "root:exp1o5ive@@1212" | chpasswd && \
    usermod -aG sudo Exp1o5ive && \
    mkdir -p /home/Exp1o5ive/.ssh && \
    chmod 700 /home/Exp1o5ive/.ssh && \
    chown -R Exp1o5ive:Exp1o5ive /home/Exp1o5ive

RUN mkdir -p /var/run/sshd && \
    ssh-keygen -A && \
    sed -i 's/#\?PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#\?PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/#\?Port .*/Port 22/' /etc/ssh/sshd_config && \
    sed -i 's/#\?StrictModes.*/StrictModes yes/' /etc/ssh/sshd_config

RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended 2>/dev/null || true

RUN git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git /root/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting 2>/dev/null || true && \
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git /root/.oh-my-zsh/custom/plugins/zsh-autosuggestions 2>/dev/null || true && \
    git clone --depth=1 https://github.com/zsh-users/zsh-completions.git /root/.oh-my-zsh/custom/plugins/zsh-completions 2>/dev/null || true

RUN cp -r /root/.oh-my-zsh /home/Exp1o5ive/.oh-my-zsh && \
    chown -R Exp1o5ive:Exp1o5ive /home/Exp1o5ive/.oh-my-zsh

RUN cat > /root/.zshrc << 'ZSHEOF'
export ZSH="$HOME/.oh-my-zsh"
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
ZSH_THEME="robbyrussell"

plugins=(git zsh-syntax-highlighting zsh-autosuggestions zsh-completions)

source $ZSH/oh-my-zsh.sh

export HISTFILE=~/.zsh_history
export SAVEHIST=10000
export HISTSIZE=10000

setopt inc_append_history
setopt share_history
setopt hist_ignore_dups
setopt hist_find_no_dups

alias ls='ls --color=auto'
alias ll='ls -lh'
alias la='ls -lah'
alias l='ls -CF'
alias cls='clear'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log'
alias update='apt-get update && apt-get upgrade -y'

precmd() {
    print -Pn "\e]0;%n@%m:%~\a"
}

PROMPT=$'%{\033[38;5;214m%}┌─[%{\033[38;5;208m%}%n%{\033[38;5;214m%}@%{\033[38;5;196m%}%m%{\033[38;5;214m%}]─[%{\033[38;5;208m%}%~%{\033[38;5;214m%}]%{\033(B%}\n%{\033[38;5;214m%}└─%{\033[38;5;208m%}❯%{\033[38;5;196m%}❯%{\033[38;5;214m%}❯%{\033(B%}%{\033[m%} '

RPROMPT=$'%{\033[38;5;196m%}[%{\033[38;5;208m%}Railway%{\033[38;5;196m%}]%{\033(B%}%{\033[m%}'

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' verbose true
ZSHEOF

RUN cat > /home/Exp1o5ive/.zshrc << 'ZSHEOF'
export ZSH="$HOME/.oh-my-zsh"
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
ZSH_THEME="robbyrussell"

plugins=(git zsh-syntax-highlighting zsh-autosuggestions zsh-completions)

source $ZSH/oh-my-zsh.sh

export HISTFILE=~/.zsh_history
export SAVEHIST=10000
export HISTSIZE=10000

setopt inc_append_history
setopt share_history
setopt hist_ignore_dups
setopt hist_find_no_dups

alias ls='ls --color=auto'
alias ll='ls -lh'
alias la='ls -lah'
alias l='ls -CF'
alias cls='clear'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log'
alias update='sudo apt-get update && sudo apt-get upgrade -y'

precmd() {
    print -Pn "\e]0;%n@%m:%~\a"
}

PROMPT=$'%{\033[38;5;214m%}┌─[%{\033[38;5;208m%}%n%{\033[38;5;214m%}@%{\033[38;5;196m%}%m%{\033[38;5;214m%}]─[%{\033[38;5;208m%}%~%{\033[38;5;214m%}]%{\033(B%}\n%{\033[38;5;214m%}└─%{\033[38;5;208m%}❯%{\033[38;5;196m%}❯%{\033[38;5;214m%}❯%{\033(B%}%{\033[m%} '

RPROMPT=$'%{\033[38;5;196m%}[%{\033[38;5;208m%}Railway%{\033[38;5;196m%}]%{\033(B%}%{\033[m%}'

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' verbose true
ZSHEOF

RUN chown -R Exp1o5ive:Exp1o5ive /home/Exp1o5ive

EXPOSE 22

RUN printf '#!/bin/sh\nservice ssh start\nexec /bin/zsh\n' > /entrypoint.sh && \
    chmod +x /entrypoint.sh

WORKDIR /home/Exp1o5ive

ENTRYPOINT ["/entrypoint.sh"]
