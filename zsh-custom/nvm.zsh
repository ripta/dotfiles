# Node Version Manager workspace
export NVM_DIR=~/.nvm
if [[ -d "$NVM_DIR" ]]
then
    export PATH=./node_modules/.bin:.bundle/binstubs:$NVM_DIR/bin:$PATH
    source $NVM_DIR/nvm.sh
fi
