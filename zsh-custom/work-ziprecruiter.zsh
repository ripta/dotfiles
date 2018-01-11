# ZipRecruiter

local -a reporoots
local reporoot

reporoots=(
  /vol/$USER/ziprecruiter
  /vol/$USER/zr
  /vol/home/$USER/ziprecruiter
  /vol/home/$USER/zr
  $HOME/ziprecruiter
  $HOME/zr
  $HOME/Projects/ziprecruiter
  $HOME/Projects/zr
  /var/starterview
)

for candidate in $reporoots
do
  if [ -d "$candidate" ]
  then
    reporoot="$candidate"
    break
  fi
done

gozr() {
  if [ -z "$reporoot" ]
  then
    echo "» error: repository root not defined" >&2
    return
  fi

  if [ -z "$1" ]
  then
    cd "$reporoot"
    echo "» root" >&2
    return
  fi

  name="$1"
  basedir="$reporoot"

  found=""
  matches=0
  for dir in $(find "$basedir" -maxdepth 2 -type d | sed "s#^$basedir/##")
  do
    if [ -n "$name" ]
    then
      if [[ "$dir" =~ "$name" ]]
      then
        if [ $matches -eq 0 ]
        then
          found="$dir"
        fi
        echo "$dir"
        matches=$(($matches + 1))
      fi
    else
      matches=$(($matches + 1))
      echo "$dir"
    fi
  done

  if [ $matches -eq 1 ]
  then
    cd "$basedir/$found"
  else
    echo "» $matches candidates «" >&2
  fi
}

export LOCAL_SANDBOX_USERNAME=ripta
