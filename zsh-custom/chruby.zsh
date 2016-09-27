# chruby+rvm mumbo-jumbo
CHRUBY_HOME=/usr/local/opt/chruby
if [[ -d $CHRUBY_HOME ]]
then
    source $CHRUBY_HOME/share/chruby/chruby.sh
    source $CHRUBY_HOME/share/chruby/auto.sh

    if [[ -d ~/.rvm ]]
    then
        RUBIES+=(~/.rvm/rubies/*)

        # NOTE(rpasay): rvm complains if it doesn't appear first in PATH; srsly
        export PATH=$HOME/.rvm/bin:$PATH
    fi

    if [[ -n "$CHRUBY_RUBY_VERSION" ]]
    then
        chruby $CHRUBY_RUBY_VERSION
    fi
fi
