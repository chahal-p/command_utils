#!/usr/bin/env bash

_complete_cu.persistent_source_base() {
  local OPTS=( $1 )
  local cur_word="$(printf '%q' "${COMP_WORDS[COMP_CWORD]}")"
  COMPREPLY=( $(compgen -W "${OPTS[*]}" -- "$cur_word") )
}

_complete_cu.persistent_source.list() {
  _complete_cu.persistent_source_base "--sh -h --help"
}

_complete_cu.persistent_source.get() {
  _complete_cu.persistent_source_base "-n --name --sh -h --help"
}

_complete_cu.persistent_source.add() {
  _complete_cu.persistent_source_base "-f --file -n --name -i --index --sh -h --help"
}

_complete_cu.persistent_source.print_sourceable() {
  _complete_cu.persistent_source_base "--sh -h --help"
}

_complete_cu.persistent_source.delete() {
  _complete_cu.persistent_source_base "-n --name --sh -h --help"
}

_complete_cu.persistent_source() {
  local cur_word="${COMP_WORDS[COMP_CWORD]}"
  if [ $COMP_CWORD -gt 1 ]; then
    [[ "${COMP_WORDS[1]}" =~ ^list|get|add|print_sourceable|delete$ ]] && _complete_cu.persistent_source.${COMP_WORDS[1]}
  else
    COMPREPLY=( $(compgen -W "list get add print_sourceable delete -h --help" -- "$cur_word") )
  fi
}

complete -F _complete_cu.persistent_source cu.persistent_source
