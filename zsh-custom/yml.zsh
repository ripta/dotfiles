function j2y() {
    python3 -c 'import sys, yaml, json; yaml.safe_dump(json.load(sys.stdin), sys.stdout, default_flow_style=False, encoding=None)'
}

function y2j() {
    python3 -c 'import sys, yaml, json; json.dump(yaml.safe_load(sys.stdin), sys.stdout, default=str)'
}

function yq() {
    y2j | jq "$@"
}
