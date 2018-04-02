function kt {
  file=$1
  if [[ -z "$file" ]]
  then
    if [[ -z "$KUBECONFIG" ]]
    then
      echo "KUBECONFIG not set" >&2
    else
      echo "KUBECONFIG=$KUBECONFIG"
    fi
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

