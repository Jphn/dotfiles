if status is-interactive
    # Commands to run in interactive sessions can go here
end

set --universal nvm_default_version lts

function __check_nvm --on-variable PWD --description 'Do nvm stuff'
    if test -f .nvmrc
        set node_version (node -v)
        set node_version_target (cat .nvmrc)
        set nvmrc_node_version (nvm list | grep $node_version_target)

        if string match -q -- "*$node_version" $nvmrc_node_version
            # already current node version
        else if not set -q $nvmrc_node_version
            # install
            nvm install $node_version_target
        else
            nvm use $node_version_target
        end
    end
end
__check_nvm

alias ld='eza -lD'
alias lf='eza -lF --color=always | grep -v /'
alias lh='eza -dl .* --group-directories-first'
alias ll='eza -al --group-directories-first'
# alias ls='eza -alF --color=always --sort=size | grep -v /'
alias lt='eza -al --sort=modified'

alias freload='. ~/.config/fish/config.fish'
alias fconfig='nvim ~/.config/fish/config.fish'

alias act='gh act'

alias lg='lazygit'

alias q='exit 0'

alias dcu='docker compose up'
alias ddcu='docker compose -f docker-compose.dev.yaml up'
alias dcd='docker compose down'
alias dcl='docker compose logs'

fish_add_path /home/jphn/.spicetify
fish_add_path /home/jphn/.deno/bin

# export DENO_INSTALL="/home/jphn/.deno"
# export PATH="$DENO_INSTALL/bin:$PATH"
