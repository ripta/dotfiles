# Hint at completion to favor local files
__git_files() {
    _wanted files expl 'local files' _files
}

# fuzzy-switch to a git worktree. git-switch-worktree prints the chosen path;
# this wrapper does the cd that the subprocess itself can't.
function gsw() {
  local dir
  dir="$(git-switch-worktree)" || return
  cd "${dir}"
}
