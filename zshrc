# Path to your oh-my-zsh configuration.
ZSH=$HOME/.dotfiles/modules/oh-my-zsh
ZSH_CUSTOM=$HOME/.dotfiles/zsh-custom

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
#ZSH_THEME="robbyrussell"
ZSH_THEME="agnoster"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Uncomment this to disable bi-weekly auto-update checks
DISABLE_AUTO_UPDATE="true"

# Uncomment to change how often before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want to disable command autocorrection
# DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

DEFAULT_USER='rpasay'
HISTSIZE=15000

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(docker encode64 fleetctl jsontools redis-cli rpasay-git sprunge ssh-agent rvm bundler brew aws)

zstyle :omz:plugins:ssh-agent agent-forwarding on
zstyle :omz:plugins:ssh-agent identities id_rsa id_rsa_2015 google_compute_engine

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
export AUTOBOT_ENV=development
export EDITOR=vim
export PATH=$PATH:$HOME/bin:/usr/local/bin:/usr/bin:/bin:/usr/bin/X11:/usr/games
export PYTHONPATH=/usr/local/lib/python2.7/site-packages:$PYTHONPATH

# Goodness, that's annoying.
unsetopt correct_all
unsetopt correct

if [[ -f ~/perl5/perlbrew/etc/bashrc ]]
then
    source ~/perl5/perlbrew/etc/bashrc
fi

# Add GOPATH for golang
if which go > /dev/null
then
    export GOPATH=/Users/rpasay/Projects/gocode
    export GOROOT=`go env GOROOT`
    export PATH=$GOPATH/bin:$PATH
fi

alias a='ack'
alias aa='ack -a'
alias ap='ack --perl'
alias c='csvfix'
alias d='docker'
alias dc='docker-compose'
alias dm='docker-machine'
alias e='emacs-24.5'
alias g='git'
alias gce='gcloud compute'
alias gke='gcloud container clusters'
alias gopath="cd $GOPATH"
alias gowd="cd $GOPATH/src/github.com/ripta"
alias j='jq .'
alias kc='kubectl'
alias kcs='kubectl --namespace kube-system'
alias rake='noglob rake'
alias sdr='screen -dr'
alias sls='screen -ls'
alias st3='open -a "/Applications/Sublime Text.app"'
alias tf='terraform'
alias wr='cd $WEBROOT'
alias wrp='source ~/env/push ; cd $WEBROOT ; echo READY FOR PUSH'
alias v='vi'
alias zs='source ~/.zshrc'

# Google Cloud SDK
if [[ -d ~/bin/google-cloud-sdk ]]
then
    source ~/bin/google-cloud-sdk/path.zsh.inc
    source ~/bin/google-cloud-sdk/completion.zsh.inc
fi

export PATH=/usr/local/sbin:$PATH

# Node Version Manager workspace
if [[ -d ~/.nvm ]]
then
    export NVM_DIR=~/.nvm
    source $(brew --prefix nvm)/nvm.sh
fi

# RentPath, Inc. workspace
if [[ -d ~/source ]]
then
    export PATH=~/source/idg/bin:$PATH
    source ~/source/idg/completions/idg.zsh
fi

export PATH=./node_modules/.bin:.bundle/binstubs:$PATH

export ETCDCTL_PEERS=http://node-03.in.dc1.between.zone:4001
export FLEETCTL_ENDPOINT=http://node-03.in.dc1.between.zone:4001

# PyEnv
export PYENV_ROOT=~/.pyenv
if which pyenv > /dev/null
then
    eval "$(pyenv init -)"
fi

if which pyenv-virtualenv-init > /dev/null
then
    eval "$(pyenv virtualenv-init -)"
fi

# chruby+rvm mumbo-jumbo
# NOTE(rpasay): rvm complains if it doesn't appear first in PATH; srsly
export PATH=$HOME/.rvm/bin:$PATH
if [[ -d /usr/local/opt/chruby ]]
then
    source /usr/local/opt/chruby/share/chruby/chruby.sh
    source /usr/local/opt/chruby/share/chruby/auto.sh

    if [[ -d ~/.rvm ]]
    then
        RUBIES+=(~/.rvm/rubies/*)
    fi

    chruby 2.1
fi

# ZipRecruiter
export LOCAL_SANDBOX_USERNAME=ripta
export STARTERVIEW=~/ziprecruiter

function y2j() {
    python -c 'import sys, yaml, json; json.dump(yaml.load(sys.stdin), sys.stdout)'
}

function yq() {
    y2j | jq "$@"
}

