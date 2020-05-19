function style() {
  name=$1
  if [[ -z $name ]]; then
    echo "!! Use 'istyle' for interactive selection" >&2
  elif [[ -f $DOTFILES/zsh-custom/styles/${name}.zsh ]]; then
    echo ">> Selected '$name'" >&2
    source $DOTFILES/zsh-custom/styles/${name}.zsh
  else
    echo "!! Invalid style '$name'" >&2
  fi
}

function istyle() {
  if command -v fzf &>/dev/null; then
    name=$(ls $DOTFILES/zsh-custom/styles | sed -e 's/.zsh$//' | fzf)
    if [[ -z $name ]]; then
      echo "!! Aborted" >&2
    else
      style $name
    fi
  else
    echo "!! Please choose one of:" >&2
    ls $DOTFILES/zsh-custom/styles | sed -e 's/.zsh$//'
  fi
}
