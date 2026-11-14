# pf is a project finder for ~/projects. `pf pick` prints the chosen path.
# This wrapper does the cd that the subprocess itself can't. Bare `pf` and
# `pf cd [query]` pick a project and cd into it. Everything else goes to the
# script.
function pf() {
  if (( $# == 0 )) || [[ $1 == cd ]]; then
    [[ $1 == cd ]] && shift
    local dir
    dir="$(command pf pick "$@")" || return
    cd "${dir}"
  else
    command pf "$@"
  fi
}
