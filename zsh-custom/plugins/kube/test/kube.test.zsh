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
    fail "$desc" "expected: ${(q-)@}" "actual:   ${(q-)got}"
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


print "passed: $PASSED, failed: $FAILED"
(( FAILED == 0 ))
