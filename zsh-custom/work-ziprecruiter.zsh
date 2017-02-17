# ZipRecruiter
if [ -d "$HOME/ziprecruiter" ]
then
  export STARTERVIEW="$HOME/ziprecruiter"
elif [ -d "/var/starterview" ]
then
  export STARTERVIEW="/var/starterview"
fi

if [ -d "$STARTERVIEW" -o -f "/etc/ziprecruiter.yml" ]
then
  echo "Welcome to ZipRecruiter!"
else
  return
fi

export LOCAL_SANDBOX_USERNAME=ripta
export STARTERVIEW="$HOME/ziprecruiter"

ZR_REPO="$HOME/Projects/git/ZipRecruiter"
if [ -d "$ZR_REPO" ]
then
  export ZR_REPO
  alias gozr="cd $ZR_REPO"
fi

# Infrastructure repository
INFRAWD="$HOME/Projects/git/ZipRecruiter/infrastructure"
if [ -d "$INFRAWD/bin" ]
then
  export INFRAWD
  export PATH="$INFRAWD/bin:$PATH"
fi
