typeset -ga KUBE_CONFIG_DIRS=( ~/.kube/configs ~/.ssh/kubeconfigs )
typeset -g __KUBE_TEMPLATE_DIR=${${(%):-%x}:A:h}/templates

function kt {
  local file=$1
  local dir cand
  if [[ -z "$file" ]]
  then
    local active="${KUBECONFIG%%:*}"
    for dir in "${KUBE_CONFIG_DIRS[@]}"
    do
      if [[ ! -d "$dir" ]]
      then
        continue
      fi
      for cand in "$dir"/*(N:t)
      do
        if [[ -n "$active" && "$active" = "$dir/$cand" ]]
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
    export KUBECONFIG="${file:a}"
    return
  fi

  for dir in "${KUBE_CONFIG_DIRS[@]}"
  do
    if [[ -f "$dir/$file" ]]
    then
      export KUBECONFIG="$dir/$file"
      return
    fi
  done
  echo "Invalid KUBECONFIG: cannot find '$file'" >&2
  return 1
}


# kubectl's flags, so arguments can be read the way kubectl reads them. A
# trailing "=" marks a flag that takes a value; the rest are booleans. "/x"
# gives the one-letter form. Unlisted flags are read as booleans, so a new
# kubectl flag that takes a value must be added here; test/kube.test.zsh
# compares these lists against the installed kubectl.
typeset -ga __KUBE_GLOBAL_FLAGS=(
  as= as-group= as-uid= cache-dir= certificate-authority= client-certificate=
  client-key= cluster= context= disable-compression help/h
  insecure-skip-tls-verify kubeconfig= log-flush-frequency= match-server-version
  namespace=/n password= profile= profile-output= request-timeout= server=/s
  tls-server-name= token= user= username= v=/v vmodule= warnings-as-errors
)
typeset -ga __KUBE_GET_FLAGS=(
  all-namespaces/A allow-missing-template-keys chunk-size= field-selector=
  filename=/f ignore-not-found kustomize=/k label-columns=/L no-headers
  output=/o output-watch-events raw= recursive/R selector=/l server-print
  show-kind show-labels show-managed-fields sort-by= subresource= template=
  watch/w watch-only
)

# Keyed by "scope:name": 1 if the flag takes a value, 0 if it is a boolean.
typeset -gA __KUBE_FLAG_ARITY
# Keyed by "scope:letter": the long name.
typeset -gA __KUBE_FLAG_SHORT

function __kube_index_flags {
  local scope=$1 spec name
  shift
  for spec in "$@"
  do
    name=${spec%%[=/]*}
    if [[ $spec == *=* ]]
    then
      __KUBE_FLAG_ARITY[$scope:$name]=1
    else
      __KUBE_FLAG_ARITY[$scope:$name]=0
    fi
    if [[ $spec == */? ]]
    then
      __KUBE_FLAG_SHORT[$scope:${spec##*/}]=$name
    fi
  done
}
__kube_index_flags global "${__KUBE_GLOBAL_FLAGS[@]}"
__kube_index_flags get "${__KUBE_GET_FLAGS[@]}"


# Reads kubectl arguments the way kubectl's flag parser (spf13/pflag) does,
# using the flags of the comma-separated scopes in $1, and normalizes each
# known flag to one "--name" or "--name=value" word. Words it cannot read
# (unknown one-letter flags, a missing value) are kept as given for kubectl
# to report.
#
# The caller declares these as local arrays, and they are filled in:
#   __kube_args     the normalized arguments
#   __kube_pos      indices in __kube_args of the positional arguments
#   __kube_pos_arg  the same positionals' indices in the original arguments
function __kube_parse_args {
  local -a scopes
  scopes=( ${(s:,:)1} )
  shift

  __kube_args=()
  __kube_pos=()
  __kube_pos_arg=()

  local -a out
  local i=1 word name val rest letter scope arity
  while (( i <= $# ))
  do
    word=${argv[i]}

    if [[ $word == -- ]]
    then
      __kube_args+=( -- )
      while (( ++i <= $# ))
      do
        __kube_args+=( "${argv[i]}" )
        __kube_pos+=( $#__kube_args )
        __kube_pos_arg+=( $i )
      done
      break
    fi

    if [[ $word == --?* ]]
    then
      name=${${word#--}%%=*}
      arity=
      for scope in $scopes
      do
        if (( ${+__KUBE_FLAG_ARITY[$scope:$name]} ))
        then
          arity=${__KUBE_FLAG_ARITY[$scope:$name]}
          break
        fi
      done

      if [[ $arity == 1 && $word != *=* ]]
      then
        if (( i < $# ))
        then
          (( i++ ))
          __kube_args+=( "--$name=${argv[i]}" )
        else
          __kube_args+=( "$word" )
        fi
      else
        __kube_args+=( "$word" )
      fi
      (( i++ ))
      continue
    fi

    if [[ $word == -?* ]]
    then
      # A group of one-letter flags. A flag that takes a value uses the rest
      # of the word, or the next word, and ends the group.
      out=()
      rest=${word#-}
      while [[ -n $rest ]]
      do
        letter=${rest[1]}
        rest=${rest[2,-1]}
        name=
        for scope in $scopes
        do
          if [[ -n ${__KUBE_FLAG_SHORT[$scope:$letter]} ]]
          then
            name=${__KUBE_FLAG_SHORT[$scope:$letter]}
            arity=${__KUBE_FLAG_ARITY[$scope:$name]}
            break
          fi
        done

        if [[ -z $name ]]
        then
          out=( "$word" )
          break
        fi

        if [[ $rest == '='* ]]
        then
          out+=( "--$name=${rest#=}" )
          rest=
        elif [[ $arity == 0 ]]
        then
          out+=( "--$name" )
        elif [[ -n $rest ]]
        then
          out+=( "--$name=$rest" )
          rest=
        elif (( i < $# ))
        then
          (( i++ ))
          out+=( "--$name=${argv[i]}" )
        else
          out=( "$word" )
        fi
      done
      __kube_args+=( "${out[@]}" )
      (( i++ ))
      continue
    fi

    __kube_args+=( "$word" )
    __kube_pos+=( $#__kube_args )
    __kube_pos_arg+=( $i )
    (( i++ ))
  done
}


function kubectl {
  local -a __kube_args __kube_pos __kube_pos_arg
  __kube_parse_args global "$@"

  local cmd at
  if (( $#__kube_pos > 0 ))
  then
    at=${__kube_pos_arg[1]}
    if [[ ${__kube_args[(I)--]} == 0 || ${__kube_args[(I)--]} -gt ${__kube_pos[1]} ]]
    then
      cmd=${argv[at]}
    fi
  fi

  if [[ -n $cmd ]] && (( $+functions[__kubectl_$cmd] ))
  then
    "__kubectl_$cmd" "${(@)argv[1,at-1]}" "${(@)argv[at+1,-1]}"
  else
    command kubectl "$@"
  fi
}


function prompt_kube_plugin() {
  local name cfg
  [[ -n "$KUBECONFIG" ]] || return
  cfg="${KUBECONFIG%%:*}"
  name="${cfg:t}"
  p10k segment -s NORMAL -r -i KUBERNETES_ICON -b black -f white -t "$name"
}


# Automatic flags for kubectl get:
# 1. "kc get foo" looks for the custom-columns template "foo.tpl" and
#    sets output format to use it if it exists.
# 2. "kc get foo -o ^bar" looks for the custom-columns template "bar.tpl"
#    and sets the output format to it if it exists.
# 3. "kc get foo -o .bar" replaces the output format with "-o json" and pipes
#    to jq automatically, passing ".bar".
# 4. "kc get foo -o @bar" looks for the formatter spec "bar.kf" and pipes
#    JSON through kubectl-formatter with the field specs from the file.
# 5. "kc get foo" sets a default --sort-by unless one was provided.
function __kubectl_get {
  # Without pipe_fail, a kubectl error piped into jq reports jq's success.
  setopt local_options pipe_fail

  local -a __kube_args __kube_pos __kube_pos_arg
  __kube_parse_args global,get "$@"

  local -a args pipe_cmd
  local i rsrc tplfile output namespace
  local has_sort_by=false
  local has_verbose=false
  local output_idx=0

  args=( "${__kube_args[@]}" )
  if (( $#__kube_pos > 0 ))
  then
    rsrc=${args[__kube_pos[1]]}
  fi

  # Flags after "--" are positional, so stop there. New flags are inserted
  # before it.
  local end=$(( ${args[(i)--]} ))
  for ((i = 1; i < end; i++))
  do
    case ${args[i]} in
      --output=*)
        # kubectl uses the last -o given.
        output_idx=$i
        ;;
      --sort-by=*)
        has_sort_by=true
        ;;
      --v=*)
        has_verbose=true
        ;;
      --namespace=*/*)
        namespace=${args[i]#--namespace=}
        namespace=${namespace//\//--}
        namespace=${namespace//_/-}
        echo "kubectl get: rewriting namespace '${args[i]#--namespace=}' -> '${namespace}'" >&2
        args[i]=--namespace=$namespace
        ;;
    esac
  done

  if (( output_idx > 0 ))
  then
    output=${args[output_idx]#--output=}
    if [[ $output == ^* ]]
    then
      tplfile="${__KUBE_TEMPLATE_DIR}/${output#^}.tpl"
      if [[ ! -f ${tplfile} ]]
      then
        echo "Error: template file not found ${tplfile}" >&2
        return 1
      fi

      args[output_idx]="--output=custom-columns-file=${tplfile}"
    elif [[ $output == @* ]]
    then
      local kffile="${__KUBE_TEMPLATE_DIR}/${output#@}.kf"
      if [[ ! -f ${kffile} ]]
      then
        echo "Error: formatter spec file not found ${kffile}" >&2
        return 1
      fi

      local -a kf_specs=()
      while IFS= read -r line; do
        [[ -z "$line" || "$line" == \#* ]] && continue
        kf_specs+=( "$line" )
      done < "$kffile"

      pipe_cmd=( "kubectl-formatter" "${kf_specs[@]}" )
      args[output_idx]="--output=json"
    elif [[ $output == .* ]]
    then
      pipe_cmd=( "jq" "-r" "$output" )
      args[output_idx]="--output=json"
    fi
  elif [[ -n ${rsrc} ]]
  then
    tplfile="${__KUBE_TEMPLATE_DIR}/${rsrc}.tpl"
    if [[ -f ${tplfile} ]]
    then
      args[end,end-1]=( "--output=custom-columns-file=${tplfile}" )
      (( end++ ))
    fi
  fi

  if [[ $has_sort_by == false ]]
  then
    if [[ $rsrc == ev ]] || [[ $rsrc == event ]] || [[ $rsrc == events ]]
    then
      args[end,end-1]=( "--sort-by=.lastTimestamp" )
    elif [[ $rsrc == no ]] || [[ $rsrc == nodes ]] || [[ $rsrc == rs ]]
    then
      args[end,end-1]=( "--sort-by=.metadata.creationTimestamp" )
    fi
  fi

  if [[ $has_verbose == true ]]
  then
    if [[ ${#pipe_cmd[@]} -eq 0 ]]
    then
      echo "+ kubectl get ${args[@]}" >&2
    else
      echo "+ kubectl get ${args[@]} | ${pipe_cmd[@]}" >&2
    fi
  fi

  if [[ ${#pipe_cmd[@]} -eq 0 ]]
  then
    command kubectl get "${args[@]}"
  else
    command kubectl get "${args[@]}" | "${pipe_cmd[@]}"
  fi
}


function _kt {
  local -a configs
  local dir
  for dir in "${KUBE_CONFIG_DIRS[@]}"
  do
    [[ -d "$dir" ]] || continue
    configs+=( "$dir"/*(N:t) )
  done
  _describe 'kubeconfig' configs
}
compdef _kt kt
