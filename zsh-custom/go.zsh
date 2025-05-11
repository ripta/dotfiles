if which go > /dev/null
then
    export PATH=$(go env GOPATH)/bin:$PATH
fi
