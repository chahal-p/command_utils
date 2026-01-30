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
"conversion"
"copy"
"cu_install"
"date"
"errors"
"eval"
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
)

echo '#!/usr/bin/env bash' > "/tmp/_cu.completes.bash_${USER}"

for x in "${install[@]}"
do
  for f in "./$x"/*
  do
    [ "$f" == "./$x/*" ] && continue
    p="$(realpath "$f")"
    bn="$(basename "$p")"
    [[ "$bn" == "_complete.sh" ]] && continue
    bash cu_install/cu.install --installation_path "$FLAGS_installation_path" --file "$p" || exit
  done
  if [ -f "./$x/_complete.sh" ]
  then
    cat ./$x/_complete.sh | grep -v ^#.*$ >> "/tmp/_cu.completes.bash_${USER}"
  fi
done
bash cu_install/cu.install --installation_path "$FLAGS_installation_path" --name "_cu.completes.bash" --file "/tmp/_cu.completes.bash_${USER}" || exit
exit 0
