function insecure-chrome() {
  TEMP_PROFILE_DIR=`mktemp -d`
  echo "Chrome data directory will be saved into $TEMP_PROFILE_DIR"
  /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --user-data-dir=$TEMP_PROFILE_DIR --ignore-certificate-errors --bwsi "$@"
}

function incognito-chrome() {
  TEMP_PROFILE_DIR=`mktemp -d`
  echo "Chrome data directory will be saved into $TEMP_PROFILE_DIR"
  /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --user-data-dir=$TEMP_PROFILE_DIR --incognito
}
