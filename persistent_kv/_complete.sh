#!/usr/bin/env bash

_complete_cu.persistent_kv_base() {
  local OPTS="$1"
  shift
  local cur_word="${COMP_WORDS[COMP_CWORD]}"
  local prev_word="${COMP_WORDS[COMP_CWORD-1]}"
  if [[ "$prev_word" == "-n" || "$prev_word" == "--namespace" ]]; then
    COMPREPLY=( $(compgen -W "$(cu.persistent_kv.list)" -- "$cur_word") )
  elif [[ "$prev_word" == "-k" || "$prev_word" == "--key" ]]; then
    local i
    local namespace
    local record_namespace=false
    for ((i=1; i < COMP_CWORD; i++)); do
      [ "${COMP_WORDS[i]}" == "=" ] && continue
      if [[ $record_namespace == true ]]; then
        if [[ "${COMP_WORDS[i]}" != -* ]]; then
          namespace="${COMP_WORDS[i]}"
        fi
        break
      fi
      if [[ "${COMP_WORDS[i]}" == "-n" || "${COMP_WORDS[i]}" == "--namespace" ]]; then
        record_namespace=true
      fi
    done
    [ -n "$namespace" ] && COMPREPLY=( $(compgen -W "$(cu.persistent_kv.list -n "$namespace")" -- "$cur_word") )
  else
    COMPREPLY=( $(compgen -W "${OPTS}" -- "$cur_word") )
  fi
}

_complete_cu.persistent_kv.list() {
  _complete_cu.persistent_kv_base "-n --namespace -h --help" "$@"
}

_complete_cu.persistent_kv.get() {
  _complete_cu.persistent_kv_base "-n --namespace -k --key -h --help" "$@"
}

_complete_cu.persistent_kv.set() {
  _complete_cu.persistent_kv_base "-n --namespace -k --key -v --value -f --force --etag -h --help" "$@"
}

_complete_cu.persistent_kv.delete() {
  _complete_cu.persistent_kv_base "-n --namespace -k --key --delete_namespace -h --help" "$@"
}

_complete_cu.persistent_kv.chmod() {
  _complete_cu.persistent_kv_base "-n --namespace -k --key -m --mode -h --help" "$@"
}

_complete_cu.persistent_kv.chown() {
  _complete_cu.persistent_kv_base "-n --namespace -k --key -o --owner -g --group -h --help" "$@"
}

_complete_cu.persistent_kv.configure() {
  local OPTS="-e --editor -p --print_path -h --help"
  local cur_word="${COMP_WORDS[COMP_CWORD]}"
  local prev_word="${COMP_WORDS[COMP_CWORD-1]}"
  if [[ "$prev_word" == "-e" || "$prev_word" == "--editor" ]]; then
    COMPREPLY=( $(compgen -c -- "$cur_word") )
  else
    COMPREPLY=( $(compgen -W "${OPTS}" -- "$cur_word") )
  fi
}

complete -F _complete_cu.persistent_kv.list cu.persistent_kv.list
complete -F _complete_cu.persistent_kv.get cu.persistent_kv.get
complete -F _complete_cu.persistent_kv.set cu.persistent_kv.set
complete -F _complete_cu.persistent_kv.delete cu.persistent_kv.delete
complete -F _complete_cu.persistent_kv.chmod cu.persistent_kv.chmod
complete -F _complete_cu.persistent_kv.chown cu.persistent_kv.chown
complete -F _complete_cu.persistent_kv.configure cu.persistent_kv.configure
