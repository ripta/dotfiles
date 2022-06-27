alias ts='gawk '"'"'{ print strftime("%Y-%m-%dT%H:%M:%S%z |"), $0; fflush(); }'"'"
alias tss='gawk '"'"'{ print strftime("%H:%M:%S |"), $0; fflush(); }'"'"

# CBN - column by name: print out the value of a column by the value of the first
# line in that column (i.e., the column's heading).
function cbn {
  local name=$1
  [[ -n $name ]] || {
    echo "Usage: cbn COLUMN_NAME" >&2
    echo 'cbn - column by name; like "awk {print $N}" without knowing the position N' >&2
    return
  }
  gawk -v name=$1 '
    NR==1 {
      for(i=1; i<=NF; i++) {
        if($i==name) {
          cn=i
          print $cn
          break
        }
      }
    }
    NR>1 {
      print $cn
    }
  '
}
