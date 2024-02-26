# Google Cloud SDK
if [[ -d ~/bin/google-cloud-sdk ]]
then
    source ~/bin/google-cloud-sdk/path.zsh.inc
    source ~/bin/google-cloud-sdk/completion.zsh.inc

    # google-cloud-sdk used to prioritize brew-installed python over system
    # python, which unfortunately doesn't work. These days, google-cloud-sdk
    # will use the bundled python in its ~/bin/google-cloud-sdk/platform.
    #
    # export CLOUDSDK_PYTHON=python
fi
