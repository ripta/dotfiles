# fuzzy process kill
function fpk() {
  local pid="$(ps -ef | sed 1d | fzf -m --header=☠️ | awk '{print $2}')"
  if [[ -n $pid ]]; then
    echo $pid | xargs kill -9
    fpk
  fi
}
