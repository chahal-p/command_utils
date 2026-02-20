#!/usr/bin/env bash

internal_args=()
while [[ $# -gt 0 ]]; do
  [[ "$1" == "--" ]] && { shift; break; }
  internal_args+=("$1")
  shift
done

cmd_and_args=()
while [[ $# -gt 0 ]]; do
  cmd_and_args+=("$1")
  shift
done

parsed_args=$(pflags parse --name "$(basename "$0")" ---- \
  -s c -l confirm -t bool -h "Show command and ask for confirmation before running" -- \
  -s v -l verbose -t bool -h "Show command and run" -- \
  -l lock_file -t string --default '' -h "Lock file to use for locking. If not specified, no locking will be acquired\n By default, the lock is exclusive" -- \
  ---- "${internal_args[@]}") || exit

eval set -- "${parsed_args}"

while [[ $# -gt 0 ]]; do
  [[ "$1" == "--" ]] && { shift; break; }
  case $1 in
    --help)
      printf '%s' "$2"
      exit 0
      ;;
    *)
      arg_name="${1#-}"
      arg_name="${arg_name#-}"
      eval "FLAGS_${arg_name}='${2//\'/\'\\\'\'}'"
      shift 2
      ;;
  esac
done

function format_arg() {
  local arg="$1"
  if [[ "$arg" == *\ * ]] ||
      [[ "$arg" == *\$* ]] ||
      [[ "$arg" == *\`* ]] ||
      [[ "$arg" == *\\* ]] ||
      [[ "$arg" == *\&* ]] ||
      [[ "$arg" == *\'* ]] ||
      [[ "$arg" == *\"* ]] ||
      [[ "$arg" == *\!* ]] ||
      [[ "$arg" == *\#* ]] ||
      [[ "$arg" == *\(* ]] ||
      [[ "$arg" == *\)* ]] ||
      [[ "$arg" == *\{* ]] ||
      [[ "$arg" == *\}* ]] ||
      [[ "$arg" == *\[* ]] ||
      [[ "$arg" == *\]* ]] ||
      [[ "$arg" == *\** ]] ||
      [[ "$arg" == *\%* ]] ||
      [[ "$arg" == *\?* ]]
  then
    cu.strings.quoted "$arg"
    exit 0
  fi
  printf '%s' "$arg"
}

function format_command() {
  local cmd=()
  for arg in "$@"; do
    cmd+=("$(format_arg "$arg")")
  done
  cu.strings.join ' ' "${cmd[@]}"
}

[[ "${#@}" -gt 0 ]] && { echo "Unknown arguments: ${@}"; exit 2; }
[[ "${#cmd_and_args[@]}" -eq 0 ]] && { echo "No command provided"; exit 1; }

[[ "$FLAGS_verbose" == "true" || "$FLAGS_confirm" == "true" ]] && echo "Command: $(format_command "${cmd_and_args[@]}")"

[ "$FLAGS_confirm" == "true" ] && { cu.confirm "Confirm command" || exit 1; }

if [[ -n "$FLAGS_lock_file" ]]; then
  [ -f "$FLAGS_lock_file" ] || { echo "Lock file does not exist" >&2; exit 1; }
  [ -r "$FLAGS_lock_file" ] || { echo "Lock file is not readable" >&2; exit 1; }
  exec 200<"$FLAGS_lock_file"
  cu.lock --fd 200 || { echo "Failed to acquire lock" >&2; exit 1; }
fi

command "${cmd_and_args[@]}"
