zmodload -i zsh/parameter
insert-last-command-output() {
    LBUFFER+="$(eval $history[$((HISTCMD-1))])"
}

zle -N insert-last-command-output
bindkey "^X^L" insert-last-command-output
