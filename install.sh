#!/usr/bin/env bash

if [[ "${BASH_VERSINFO[0]}" -lt 5 ]]
then
  echo 'bash version 5 or higher is required for command_utils'
  return
fi

IFS=' ' read -r _ python_version <<< $(python3 -V)
IFS='.' read -r python_version_major python_version_minor python_version_patch <<< $python_version

if [[ "${python_version_major}" -lt 3 || ("${python_version_major}" -eq 3 && "${python_version_minor}" -lt 11) ]]
then
  echo 'python version 3.11 or higher is required for command_utils'
  return
fi

function error_echo() {
  echo -e "\e[01;31m${@}\e[0m"
}

function usage() {
  echo "Usage: $(basename $0) [options]"
  echo "Options:"
  echo "  -h, --help          Show this help message"
  echo "  --installation_path Path where the file will be installed, default is /usr/local/bin"
}

FLAGS_installation_path="/usr/local/bin"


while [[ $# -gt 0 ]]; do
  arg="$1"
  shift
  val=""
  value_found=0
  if [[ $# -gt 0 ]] && [[ ! "$1" == -* ]]; then
    val="$1"
    value_found=1
  fi
  case "$arg" in
    -h|--help)
      usage
      exit 0
      ;;
    --installation_path)
      [ "$value_found" -eq 0 ] && { echo "No value given for $arg" >&2; exit 2; }
      shift || exit 1
      FLAGS_installation_path="$val"
      ;;
    --installation_path=*)
      val="${arg#--installation_path=}"
      FLAGS_installation_path="$val"
      ;;
    *)
      echo "Unrecognized arguments: $arg" >&2
      exit 2
      ;;
  esac
done

install=(
"__init__"
"arrays"
"checks"
"command"
"conversion"
"copy"
"cu_install"
"date"
"errors"
"input"
"install_alias"
"numbers"
"openssl"
"persistent_kv"
"persistent_source"
"python"
"strings"
"sync"
"utils"
"vars"
"workflows"
)

echo '#!/usr/bin/env bash' > "/tmp/_cu.completes.bash_${USER}"

# Create command_utils directory
COMMAND_UTILS_DIR_PATH="${HOME}/.command_utils"
[[ "$(whoami)" == "root" ]] && {
  [ -d /usr/local/share ] || mkdir -m 755 -p /usr/local/share || exit
  COMMAND_UTILS_DIR_PATH="/usr/local/share/command_utils"
}
[ -d "${COMMAND_UTILS_DIR_PATH}" ] || mkdir -m 755 "${COMMAND_UTILS_DIR_PATH}" || exit
################################

function install_persistent_kv_configs() {
  [ -f "${FLAGS_installation_path%/}/_cu.persistent_kv.configs" ] && {
    echo "Persistent KV already configured, skipping configs installation. Use cu.persistent_kv.configure to reconfigure."
    return 1
  }
  [ -d "${COMMAND_UTILS_DIR_PATH}" ] || {
    echo "Something went wrong, command_utils directory not found."
    exit 1
  }

  local storage_path="${COMMAND_UTILS_DIR_PATH}/persistent_kv_storage"
  [ -d "${storage_path}" ] || mkdir -m 1777 "${storage_path}" || exit
  bash persistent_kv/_cu.persistent_kv.install_configs "cu_install/cu.install" "$FLAGS_installation_path" "${storage_path}" || exit
}

for x in "${install[@]}"
do
  for f in "./$x"/*
  do
    [ "$f" == "./$x/*" ] && continue
    p="$(realpath "$f")"
    bn="$(basename "$p")"
    [[ "$bn" == "_complete.sh" ]] && continue
    bash cu_install/cu.install --installation_path "$FLAGS_installation_path" --file "$p" || exit
    [[ "$bn" == "_cu.persistent_kv.install_configs" ]] && install_persistent_kv_configs
  done
  if [ -f "./$x/_complete.sh" ]
  then
    cat ./$x/_complete.sh | grep -v ^#.*$ >> "/tmp/_cu.completes.bash_${USER}"
  fi
done
bash cu_install/cu.install --installation_path "$FLAGS_installation_path" --name "_cu.completes.bash" --file "/tmp/_cu.completes.bash_${USER}" || exit
exit 0
