# Google Cloud SDK
if [[ -d ~/bin/google-cloud-sdk ]]
then
    source ~/bin/google-cloud-sdk/path.zsh.inc
    source ~/bin/google-cloud-sdk/completion.zsh.inc

    # google-cloud-sdk prioritizes brew-installed python over system python,
    # which unfortunately doesn't work
    export CLOUDSDK_PYTHON=python
fi
