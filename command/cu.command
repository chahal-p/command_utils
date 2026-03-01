#!/usr/bin/env bash

source cu.errors_lib.bash

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

parsed_args=$(pflags parse --name "$(basename "$0")" --usage "$(basename "$0") [options...] -- <command> [args...]" ---- \
  -s c -l confirm -t bool -h "Show command and ask for confirmation before running" -- \
  -s v -l verbose -t bool -h "Show command and run" -- \
  -s t -l timeout -t number --default '' -h "Timeout for the command. Once the timeout is reached, the specified signal will be sent to the command" -- \
  -s s -l signal -t string --default 'SIGKILL' -h "Signal to send to the command when the timeout is reached. Default is SIGKILL" -- \
  -s k -l kill_after -t number --default '' -h "Time to wait after sending the signal before killing the command. If not specified, wait indefinitely for the signal to be processed" -- \
  -l lock_file -t string --default '' -h "Lock file to use for locking. If not specified, no locking will be acquired\n By default, the lock is exclusive" -- \
  -l lock_timeout -t number --default '' -h "Timeout for acquiring the lock. If not specified, wait indefinitely for the lock" -- \
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

[[ "${#@}" -gt 0 ]] && cu.errors.die_usage "Unknown arguments: ${@}"
[[ "${#cmd_and_args[@]}" -eq 0 ]] && cu.errors.die_usage "No command provided"

[[ "$FLAGS_verbose" == "true" || "$FLAGS_confirm" == "true" ]] && echo "Command: $(format_command "${cmd_and_args[@]}")"

[ "$FLAGS_confirm" == "true" ] && { cu.confirm "Confirm command" || exit; }

if [[ -n "$FLAGS_timeout" && -n "$FLAGS_lock_file" ]]; then
  exec _cu.command.timeout "$FLAGS_timeout" "$FLAGS_signal" "$FLAGS_kill_after" _cu.command.lock "$FLAGS_lock_file" "$FLAGS_lock_timeout" "${cmd_and_args[@]}"
elif [[ -n "$FLAGS_timeout" ]]; then
  exec _cu.command.timeout "$FLAGS_timeout" "$FLAGS_signal" "$FLAGS_kill_after" "${cmd_and_args[@]}"
elif [[ -n "$FLAGS_lock_file" ]]; then
  exec _cu.command.lock "$FLAGS_lock_file" "$FLAGS_lock_timeout" "${cmd_and_args[@]}"
else
  exec "${cmd_and_args[@]}"
fi
