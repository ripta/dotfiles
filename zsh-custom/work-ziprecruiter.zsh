# ZipRecruiter
export LOCAL_SANDBOX_USERNAME=ripta
export STARTERVIEW=~/ziprecruiter

export ZR_REPO="$HOME/Projects/git/ZipRecruiter"
alias gozr="cd $ZR_REPO"

# Infrastructure repository
export INFRAWD="$HOME/Projects/git/ZipRecruiter/infrastructure"
if [ -d "$INFRAWD/bin" ]
then
  export PATH="$INFRAWD/bin:$PATH"
fi

