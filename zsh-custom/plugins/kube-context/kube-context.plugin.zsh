function kt {
  file=$1
  if [[ -z "$file" ]]
  then
    for dir in ~/.kube/configs ~/.ssh/kubeconfigs
    do
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

