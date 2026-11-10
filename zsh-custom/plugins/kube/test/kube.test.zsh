#!/usr/bin/env zsh
#
# Tests for the kube plugin. Run with: zsh -f zsh-custom/plugins/kube/test/kube.test.zsh
#
# A stub kubectl on PATH records its arguments, so the tests check exactly
# what the plugin would have run.

emulate -R zsh

typeset -g TEST_DIR=${${(%):-%x}:A:h}
typeset -g PLUGIN=${TEST_DIR:h}/kube.plugin.zsh
typeset -g TMP=${$(mktemp -d):A}
trap 'rm -rf -- "${TMP:?}"' EXIT

mkdir -p $TMP/bin
cat > $TMP/bin/kubectl <<'EOF'
#!/bin/sh
for a in "$@"; do printf '%s\0' "$a"; done > "$KUBE_STUB_LOG"
[ -n "$KUBE_STUB_STDOUT" ] && printf '%s\n' "$KUBE_STUB_STDOUT"
[ -n "$KUBE_STUB_STDERR" ] && printf '%s\n' "$KUBE_STUB_STDERR" >&2
exit "${KUBE_STUB_EXIT:-0}"
EOF
chmod +x $TMP/bin/kubectl
path=( $TMP/bin $path )

export KUBE_STUB_LOG=$TMP/args KUBE_STUB_STDOUT= KUBE_STUB_STDERR= KUBE_STUB_EXIT=0

compdef() { : }
source $PLUGIN

typeset -gi PASSED=0 FAILED=0

pass() { (( PASSED++ )) }
fail() {
  (( FAILED++ ))
  print -ru2 -- "FAIL: $1"
  shift
  print -rlu2 -- "${@/#/  }"
}

# Usage: assert_eq <description> <expected> <actual>
assert_eq() {
  if [[ $2 == $3 ]]; then pass; else fail "$1" "expected: ${(q-)2}" "actual:   ${(q-)3}"; fi
}

# Usage: assert_ran <description> <expected kubectl args...>
# Compares against the arguments the stub kubectl last received.
assert_ran() {
  local desc=$1; shift
  local -a got
  got=( ${(0)"$(<$KUBE_STUB_LOG)"} )
  if [[ ${(j:\0:)got} == ${(j:\0:)@} ]]; then
    pass
  else
    fail "$desc" "expected: ${(j: :)${(q-)@}}" "actual:   ${(j: :)${(q-)got}}"
  fi
}

# Usage: assert_parsed <description> <expected args...> ::: <args...>
# Parses <args> as kubectl get arguments and compares the normalized result.
# Leaves the positional indices in PARSED_POS.
typeset -ga PARSED_POS
assert_parsed() {
  local desc=$1; shift
  local -a want __kube_args __kube_pos __kube_pos_arg
  while [[ $1 != ::: ]]; do want+=( "$1" ); shift; done
  shift
  __kube_parse_args global,get "$@"
  PARSED_POS=( $__kube_pos )
  if [[ ${(j:\0:)__kube_args} == ${(j:\0:)want} && $#__kube_args == $#want ]]; then
    pass
  else
    fail "$desc" "input:    ${(j: :)${(q-)@}}" "expected: ${(j: :)${(q-)want}}" "actual:   ${(j: :)${(q-)__kube_args}}"
  fi
}

# Usage: kc_run <kubectl args...>
# Runs the plugin's kubectl in this shell; sets RC, OUT and ERR.
kc_run() {
  rm -f $KUBE_STUB_LOG
  kubectl "$@" >$TMP/out 2>$TMP/err
  RC=$?
  OUT=$(<$TMP/out)
  ERR=$(<$TMP/err)
}

typeset -g RC OUT ERR


### kt

mkdir -p $TMP/configs/sub $TMP/cwd
touch $TMP/configs/alpha $TMP/cwd/local-config
KUBE_CONFIG_DIRS=( $TMP/configs )

() {
  local KUBECONFIG=

  kt alpha >/dev/null 2>&1
  assert_eq "kt: name from a config dir" $TMP/configs/alpha $KUBECONFIG

  cd $TMP/cwd
  kt ./local-config >/dev/null 2>&1
  cd /
  assert_eq "kt: relative path is stored as absolute" $TMP/cwd/local-config $KUBECONFIG

  KUBECONFIG=unchanged
  kt does-not-exist >/dev/null 2>$TMP/err
  RC=$?
  assert_eq "kt: missing config exits 1" 1 $RC
  assert_eq "kt: missing config leaves KUBECONFIG alone" unchanged $KUBECONFIG
  assert_eq "kt: missing config explains" "Invalid KUBECONFIG: cannot find 'does-not-exist'" "$(<$TMP/err)"
}


### argument parsing
#
# Each case matches how kubectl itself (spf13/pflag) reads the arguments,
# checked against kubectl v1.32.

assert_parsed "short flag, attached value"   --output=yaml ::: -oyaml
assert_parsed "short flag, = value"          --output=yaml ::: -o=yaml
assert_parsed "short flag, separate value"   --output=yaml ::: -o yaml
assert_parsed "long flag, = value"           --output=yaml ::: --output=yaml
assert_parsed "long flag, separate value"    --output=yaml ::: --output yaml
assert_parsed "value may start with a dash"  --output=-A ::: -o -A
assert_parsed "value may contain ="          --selector=app=web ::: -lapp=web
assert_parsed "empty value"                  --output= ::: -o ''
assert_parsed "stacked booleans"             --all-namespaces --watch ::: -Aw
assert_parsed "stack ending in attached value" --all-namespaces --watch --output=name ::: -Awoname
assert_parsed "stack ending in separate value" --all-namespaces --output=name ::: -Ao name
assert_parsed "short boolean with = value"   --watch=false ::: -w=false
assert_parsed "long boolean with = value"    --watch=false ::: --watch=false
assert_parsed "global flag"                  --namespace=foo ::: -nfoo
assert_parsed "global flag, long"            --context=prod ::: --context prod
assert_parsed "verbosity"                    --v=6 ::: -v 6

assert_parsed "boolean does not take the next word" --show-kind name ::: --show-kind name
assert_eq "boolean does not take the next word: word is positional" 2 "$PARSED_POS"

assert_parsed "positionals are kept in order" pods --output=name web ::: pods -oname web
assert_eq "positionals are kept in order: indices" "1 3" "$PARSED_POS"

assert_parsed "-- ends flags" --output=yaml -- -oname ::: -oyaml -- -oname
assert_eq "-- ends flags: later words are positional" 3 "$PARSED_POS"

assert_parsed "lone dash is positional" - ::: -
assert_parsed "unknown short flag is left alone" -Ax ::: -Ax
assert_parsed "unknown long flag is boolean" --frobnicate pods ::: --frobnicate pods
assert_parsed "missing value is left for kubectl to report" pods -o ::: pods -o


### kubectl get

kc_run -n kube-system get events
assert_ran "global flag before get" get --namespace=kube-system events --sort-by=.lastTimestamp

kc_run --context prod get events
assert_ran "long global flag before get" get --context=prod events --sort-by=.lastTimestamp

kc_run get -l app=web nodes
assert_ran "flag value is not the resource" get --selector=app=web nodes --sort-by=.metadata.creationTimestamp

kc_run get --sort-by .metadata.name events
assert_ran "explicit --sort-by is kept" get --sort-by=.metadata.name events

kc_run get crds -oyaml
assert_ran "attached -o replaces the default template" get crds --output=yaml

kc_run get crds -o wide -o name
assert_ran "last -o wins, as in kubectl" get crds --output=wide --output=name

kc_run get events -- extra
assert_ran "defaults go before --" get events --sort-by=.lastTimestamp -- extra

kc_run get pods -n team/app_one
assert_ran "namespace path is rewritten" get pods --namespace=team--app-one
assert_eq "namespace path rewrite is reported" "kubectl get: rewriting namespace 'team/app_one' -> 'team--app-one'" "$ERR"

kc_run -v 6 get events
assert_ran "verbose get" get --v=6 events --sort-by=.lastTimestamp
assert_eq "verbose get echoes the command" "+ kubectl get --v=6 events --sort-by=.lastTimestamp" "$ERR"

kc_run --context prod describe pod web
assert_ran "other commands pass through unchanged" --context prod describe pod web

kc_run -n foo
assert_ran "no command passes through unchanged" -n foo

kc_run -- get pods
assert_ran "a command after -- is not handled" -- get pods


### templates

typeset -g TPL=${PLUGIN:h}/templates

() {
  local DOTFILES=/nonexistent
  kc_run get crds
  assert_ran "get: default template is found without DOTFILES" get crds --output=custom-columns-file=$TPL/crds.tpl

  kc_run get pods -o ^owners
  assert_ran "get -o ^name: named template is found without DOTFILES" get pods --output=custom-columns-file=$TPL/owners.tpl
}

kc_run get pods -o ^no-such-template
assert_eq "get -o ^name: missing template exits 1" 1 $RC
assert_eq "get -o ^name: missing template is not run" false "$( [[ -e $KUBE_STUB_LOG ]] && print true || print false )"


### exit status

KUBE_STUB_STDERR="Error from server (NotFound)" KUBE_STUB_EXIT=1 kc_run get pods/missing
assert_eq "get: kubectl failure exits non-zero" 1 $RC

if (( $+commands[jq] )); then
  KUBE_STUB_STDOUT='{"a":"b"}' kc_run get pods -o .a
  assert_eq "get -o .field: success exits 0" 0 $RC
  assert_eq "get -o .field: output is piped through jq" b "$OUT"

  KUBE_STUB_STDERR="Error from server (NotFound)" KUBE_STUB_EXIT=1 kc_run get pods/missing -o .a
  assert_eq "get -o .field: kubectl failure exits 1" 1 $RC

  KUBE_STUB_STDOUT='{"a":"b"}' kc_run get pods -o '.['
  assert_eq "get -o .field: jq failure exits non-zero" 1 "$(( RC != 0 ))"
else
  print -u2 "skip: jq not installed"
fi


print "passed: $PASSED, failed: $FAILED"
(( FAILED == 0 ))
