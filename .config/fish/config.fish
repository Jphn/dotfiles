set -g fish_greeting

if status is-interactive
    # Commands to run in interactive sessions can go here
end

if not set -q nvm_default_version
    set --universal nvm_default_version lts
end

__check_nvm

alias ld='eza -lD'
alias lf='eza -lF --color=always | grep -v /'
alias lh='eza -dl .* --group-directories-first'
alias ll='eza -al --group-directories-first'
alias ls='eza -alF --color=always --sort=size | grep -v /'
alias lt='eza -al --sort=modified'

# Use batcat instead of cat, if avaiable
if test -f /usr/bin/batcat
    alias cat='batcat'
end

# Fish
alias freload='. ~/.config/fish/config.fish'
alias fconfig='nvim ~/.config/fish/config.fish'

alias pulsefix='systemctl --user restart pulseaudio && systemctl --user restart pulseaudio'

alias act='gh act'

alias lg='lazygit'

alias q='exit 0'
alias xo='xdg-open'

# Docker
alias dc='docker compose'
alias dcd='docker compose -f docker-compose.dev.yaml'
alias dcl='docker compose logs'
alias dtest='docker compose -f docker-compose.test.yaml up --build --abort-on-container-exit; and docker compose -f docker-compose.test.yaml down -v'

fish_add_path /home/jphn/.spicetify
fish_add_path /home/jphn/.deno/bin
fish_add_path /home/jphn/.config/composer/vendor/bin
fish_add_path /home/.cargo/bin
fish_add_path /home/jphn/.config/composer/vendor/bin
fish_add_path /home/jphn/Downloads/swift-6.0.3-RELEASE-ubuntu24.04/usr/bin
fish_add_path -g -p /home/jphn/development/flutter/bin

# Android SDK
set --export ANDROID_HOME $HOME/Android/Sdk
set -gx PATH $ANDROID_HOME/emulator $PATH
set -gx PATH $ANDROID_HOME/tools $PATH
set -gx PATH $ANDROID_HOME/tools/bin $PATH
set -gx PATH $ANDROID_HOME/platform-tools $PATH

zoxide init fish | source
starship init fish | source

set -Ux SDKMAN_DIR (brew --prefix SDKMAN-cli)/libexec

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
