function kt {
  file=$1
  if [[ -z "$file" ]]
  then
    for dir in ~/.kube/configs ~/.ssh/kubeconfigs
    do
      if [[ ! -d "$dir" ]]
      then
        continue
      fi
      for cand in $(ls "$dir")
      do
        if [[ -n "$KUBECONFIG" && "$KUBECONFIG" = "$dir/$cand" ]]
        then
          echo "* $cand"
        else
          echo "  $cand"
        fi
      done
    done
    return
  fi

  if [[ -f "$file" ]]
  then
    export KUBECONFIG="$file"
    return
  fi

  for dir in ~/.kube/configs ~/.ssh/kubeconfigs
  do
    if [[ -f "$dir/$file" ]]
    then
      export KUBECONFIG="$dir/$file"
      return
    fi
  done
  echo "Invalid KUBECONFIG: cannot find '$file'" >&2
}


function prompt_kube_plugin() {
  local name cfg
  [[ -n "$KUBECONFIG" ]] || return
  cfg="$(echo "$KUBECONFIG" | awk -F: '{print $1}')"
  name="$(basename $cfg)"
  p10k segment -s NORMAL -r -i KUBERNETES_ICON -b blue -f white -t "$name"
}
