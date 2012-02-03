VERSION="0.1.1"
CONFIG=./deploy.conf
LOG=/tmp/provision.log
KEYS=./keys
ARGS="$@"
TEST=1
REF=
ENV=
USER=$2
REMOTEPATH=
PROJECTNAME=
INSTANCE=
TEST=0
REF=
ENV=
POSTDEPLOY=

invoke() {
  $@ $ARGS
}

#
# Abort with <msg>
#

abort() {
  echo
  echo "  $@" 1>&2
  echo
  exit 1
}

hr() {
  echo "============================================================="
}

#
# Log <msg>.
#

log() {
  echo ""
  echo "  ○ $@"
  echo ""
}

#
# Set configuration file <path>.
#

set_config_path() {
  test -f $1 || abort invalid --config path
  CONFIG=$1
}

#
# Check if config <section> exists.
#

config_section() {
  grep "^\[$1" $CONFIG &> /dev/null
}

#
# Get config value by <key>.
#

config_get() {
  local key=$1
  test -n "$key" \
    && grep "^\[$ENV" -A 20 $CONFIG \
    | grep "^$key" \
    | head -n 1 \
    | cut -d ' ' -f 2-999
}

#
# Output version.
#

version() {
  echo $VERSION
}

#
# Run the given remote <cmd>.
#

run() {
  local url="$1@`config_get host`"
  shift
  local key=`config_get key`
  if test -n "$key"; then
    local shell="ssh -i $key $url"
  else
    local shell="ssh $url"
  fi
  echo $shell "\"$@\"" >> $LOG
  $shell $@
}

#
# Launch an interactive ssh console session.
#

console() {
  local url="$PROJECTNAME@`config_get host`"
  local key=`config_get key`
  if test -n "$key"; then
    local shell="ssh -i $key $url"
  else
    local shell="ssh $url"
  fi
  echo $shell
  exec $shell
}

#
# Run a script remotely
#

script() {
  local url="$1@`config_get host`"
  local shell="ssh $url"
  $shell 'bash -s' < "$2"
}

template() {
  { echo "cat <<EOFNOREALLY"
   cat "$@"
   echo "EOFNOREALLY"
  } | sh > "/tmp/templated.sh"

  script $USER "/tmp/templated.sh"
  rm /tmp/templated.sh
}

#
# Output config or [key].
#

config() {
  if test $# -eq 0; then
    cat $CONFIG
  else
    config_get $1
  fi
}

#
# Execute hook <name> relative to the path configured.
#

hook() {
  if [[ `config_get stack` != 'node' ]]; then return 0; fi
  local path=$REMOTEPATH
  local cmd=$1
  test -n "$cmd" || abort hook name required
  if test -n "$cmd"; then
    log "executing \`$cmd\`"
    run $PROJECTNAME "cd $path/current; \
      SHARED=\"$path/shared\" \
      $cmd 2>&1 | tee -a $LOG; \
      exit \${PIPESTATUS[0]}"
    test $? -eq 0
  fi
}
