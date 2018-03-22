function y2j() {
    python2.7 -c 'import sys, yaml, json; json.dump(yaml.load(sys.stdin), sys.stdout, default=str)'
}

function yq() {
    y2j | jq "$@"
}
