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
