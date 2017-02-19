# ZipRecruiter
if [ -d "$HOME/ziprecruiter" ]
then
  export STARTERVIEW="$HOME/ziprecruiter"
elif [ -d "/var/starterview" ]
then
  export STARTERVIEW="/var/starterview"
elif [ -d "$HOME/Projects/ziprecruiter" ]
then
  export STARTERVIEW="$HOME/Projects/ziprecruiter"
elif [ -d "$HOME/Projects/zr/ziprecruiter" ]
then
  export STARTERVIEW="$HOME/Projects/zr/ziprecruiter"
fi

if [ -d "$STARTERVIEW" -o -f "/etc/ziprecruiter.yml" ]
then
  echo "Welcome to ZipRecruiter!"
  echo "STARTERVIEW=$STARTERVIEW"
  alias gozr="cd $STARTERVIEW"
else
  return
fi

export LOCAL_SANDBOX_USERNAME=ripta

# Infrastructure repository
INFRAWD="$HOME/Projects/git/ZipRecruiter/infrastructure"
if [ -d "$INFRAWD/bin" ]
then
  export INFRAWD
  export PATH="$INFRAWD/bin:$PATH"
fi
