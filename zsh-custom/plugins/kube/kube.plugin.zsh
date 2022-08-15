function kt {
  local file=$1
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


function kubectl {
  local cmd

  args=( "$@" )
  for ((i = 1; i <= $#args; i++))
  do
    if [[ ${args[$i]} == -n ]] || [[ ${args[$i]} == --namespace ]]
    then
      i=$((i + 1))
      continue
    elif [[ ${args[$i]} == --namespace=* ]]
    then
      continue
    else
      cmd="${args[$i]}"
      #echo "$i: ${args[@]}" >&2
      args[$i]=()
      break
    fi
  done
  #args=( "${args[@]}" )

  #echo "cmd: $cmd"
  #echo "rest: ${(qq)args[@]}"
  if type "__kubectl_${cmd}" >/dev/null 2>&1
  then
    "__kubectl_${cmd}" "${args[@]}"
  else
    command kubectl "${cmd}" "${args[@]}"
  fi
}


function prompt_kube_plugin() {
  local name cfg
  [[ -n "$KUBECONFIG" ]] || return
  cfg="$(echo "$KUBECONFIG" | awk -F: '{print $1}')"
  name="$(basename $cfg)"
  p10k segment -s NORMAL -r -i KUBERNETES_ICON -b blue -f white -t "$name"
}


# Automatic flags for kubectl get:
# 1. "kc get foo" looks for the custom-columns template "foo.tpl" and
#    sets output format to use it if it exists.
# 2. "kc get foo -o ^bar" looks for the custom-columns template "bar.tpl"
#    and sets the output format to it if it exists.
# 3. "kc get foo" sets a default --sort-by unless one was provided.
function __kubectl_get {
  args=( "$@" )

  local rsrc
  local has_sort_by=false
  local output_idx=-1
  for ((i = 0; i <= $#args; i++))
  do
    if [[ ${args[$i]} == -o ]] || [[ ${args[$i]} == --output ]]
    then
      output_idx=$((i + 1))
      continue
    fi

    if [[ -z ${rsrc} ]]
    then
      rsrc="${args[$i]}"
      continue
    fi

    if [[ ${args[$i]} == --sort-by ]] || [[ ${args[$i]} == --sort-by=* ]]
    then
      has_sort_by=true
    fi
  done

  if [[ ${output_idx} -ge 0 ]]
  then
    if [[ ${args[$output_idx]} == ^* ]]
    then
      tplfile="${DOTFILES}/zsh-custom/plugins/kube/templates/${args[$output_idx]#^}.tpl"
      args[$output_idx]="custom-columns-file=${tplfile}"
    fi
  elif [[ -n ${rsrc} ]]
  then
    tplfile="${DOTFILES}/zsh-custom/plugins/kube/templates/${rsrc}.tpl"
    #echo "RSRC($rsrc}: ${tplfile}" >&2
    if [[ -f ${tplfile} ]]
    then
      args=( "${args[@]}" "-o" "custom-columns-file=${tplfile}" )
    fi
  fi

  if [[ $has_sort_by == false ]]
  then
    if [[ $rsrc == ev* ]]
    then
      args=( "${args[@]}" "--sort-by=.lastTimestamp" )
    elif [[ $rsrc == no ]] || [[ $rsrc == nodes ]]
    then
      args=( "${args[@]}" "--sort-by=.metadata.creationTimestamp" )
    fi
  fi

  echo "❯ kubectl get ${args[@]}" >&2
  command kubectl get "${args[@]}"
}
