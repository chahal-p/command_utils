#!/usr/bin/env bash

_complete_cu.persistent_kv.list() {
  local OPTS="-n --namespace -h --help"
  local cur_word="${COMP_WORDS[COMP_CWORD]}"
  local prev_word="${COMP_WORDS[COMP_CWORD-1]}"
  if [[ "$prev_word" == "-n" || "$prev_word" == "--namespace" ]]; then
    COMPREPLY=( $(compgen -W "$(cu.persistent_kv.list)" -- "$cur_word") )
  else
    COMPREPLY=( $(compgen -W "${OPTS}" -- "$cur_word") )
  fi
}

complete -F _complete_cu.persistent_kv.list cu.persistent_kv.list
