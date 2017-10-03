alias kc='kubectl'
alias kcs='kubectl --namespace kube-system'

alias kccc='kubectl config current-context'
alias kcuc='kubectl config use-context'

alias kca='kubectl apply'
alias kcd='kubectl delete'
alias kci='kubectl cluster-info'

alias kcdd='kubectl describe deployment'
alias kcde='kubectl describe endpoints'
alias kcdn='kubectl describe node'
alias kcdp='kubectl describe pod'
alias kcds='kubectl describe svc'

alias kcgd='kubectl get deployment -o wide'
alias kcge='kubectl get endpoints -o wide'
alias kcgn='kubectl get node -o wide '
alias kcgp='kubectl get pod -o wide'
alias kcgs='kubectl get svc -o wide'

function kcx() {
  kubectl exec -it "$@" sh
}

function kcstat() {
  for n in $(kubectl get node | tail -n +2 | awk '{ print $1 }')
  do
    echo $n
    echo -e "$(kubectl describe node $node | grep -A 4 'Allocated resources')\n"
  done
}
