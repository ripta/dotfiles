function y2j() {
    python -c 'import sys, yaml, json; json.dump(yaml.load(sys.stdin), sys.stdout)'
}

function yq() {
    y2j | jq "$@"
}
