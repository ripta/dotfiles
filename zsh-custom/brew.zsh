export HOMEBREW_NO_AUTO_UPDATE=1

if [[ -d "/opt/homebrew/opt/libpq/bin" ]]
then
    export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
fi
