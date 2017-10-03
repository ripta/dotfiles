# Add GOPATH for golang
export GOPATH=$HOME/Projects/gocode

if which go > /dev/null
then
    if [[ ! -d "$GOPATH" ]]
    then
        mkdir -p "$GOPATH/bin"
    fi

    export GOROOT=`go env GOROOT`
    export PATH=$GOPATH/bin:$PATH

    alias gopath="cd $GOPATH"
    gowd() {
      cd $GOPATH/src/${1:-github.com/ripta}
    }
fi
