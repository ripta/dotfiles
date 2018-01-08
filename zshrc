# Path to your oh-my-zsh configuration.
DOTFILES=$HOME/.dotfiles
ZSH=$DOTFILES/modules/oh-my-zsh
ZSH_CUSTOM=$DOTFILES/zsh-custom

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
ZSH_THEME="agnoster"

# CASE_SENSITIVE="true"
DISABLE_AUTO_UPDATE="true"
# export UPDATE_ZSH_DAYS=13
# DISABLE_LS_COLORS="true"
# DISABLE_AUTO_TITLE="true"
ENABLE_CORRECTION="false"
COMPLETION_WAITING_DOTS="true"

DEFAULT_USER='rpasay'
HISTSIZE=100000
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Show timing information if above configured threshold
ZSH_COMMAND_TIME_ECHO=1
ZSH_COMMAND_TIME_MIN_SECONDS=3

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(bd docker encode64 fleetctl jsontools redis-cli rpasay-git sprunge ssh-agent rvm bundler brew aws z command-time)
plugins+=(gogo)

zstyle :omz:plugins:ssh-agent agent-forwarding on
zstyle :omz:plugins:ssh-agent identities id_ed25519 id_rsa id_rsa_2015 google_compute_engine

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

