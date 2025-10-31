# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh configuration.
DOTFILES=$HOME/.dotfiles
ZSH=$DOTFILES/modules/oh-my-zsh
ZSH_CUSTOM=$DOTFILES/zsh-custom

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
ZSH_THEME="powerlevel10k/powerlevel10k"

# CASE_SENSITIVE="true"
DISABLE_AUTO_UPDATE="true"
# DISABLE_MAGIC_FUNCTIONS="true"
# ZSH_DISABLE_COMPFIX="true"
# export UPDATE_ZSH_DAYS=13
# DISABLE_LS_COLORS="true"
# DISABLE_AUTO_TITLE="true"
ENABLE_CORRECTION="false"
COMPLETION_WAITING_DOTS="true"

DEFAULT_USER='rpasay'
HISTFILESIZE=1000000000
HISTSIZE=80000000
SAVEHIST=80000000
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ./zsh-custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(docker encode64 fancy-ctrl-z jsontools sprunge ssh-agent rvm bundler brew aws_new z)
plugins+=(bd direnv fleetctl gogo kube gpg-agent jump)

zstyle :omz:plugins:ssh-agent agent-forwarding on
zstyle :omz:plugins:ssh-agent identities id_ed25519

# Goodness, that's annoying.
unsetopt correct_all
unsetopt correct

if [[ -f ~/perl5/perlbrew/etc/bashrc ]]
then
    source ~/perl5/perlbrew/etc/bashrc
fi

if [[ -r "$HOME/.zshprerc" ]]
then
    source $HOME/.zshprerc
fi

source $ZSH/oh-my-zsh.sh
export PATH=/usr/local/sbin:$PATH

if [[ -r "$HOME/.zshpostrc" ]]
then
    source $HOME/.zshpostrc
fi

if [[ -f "/usr/local/opt/asdf/asdf.sh" ]]
then
  source /usr/local/opt/asdf/asdf.sh
fi

# powerlevel10k configuration
[[ ! -f $DOTFILES/zsh-custom/styles/normal.zsh ]] || source $DOTFILES/zsh-custom/styles/normal.zsh

# iTerm2 > Install Shell Integration
[[ -f /Users/ripta/.iterm2_shell_integration.zsh ]] && source /Users/ripta/.iterm2_shell_integration.zsh || true

# rustup shell setup
[[ -f $HOME/.cargo/env ]] && source $HOME/.cargo/env || true

alias vi=nvim
