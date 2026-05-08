#!/usr/bin/env bash

function _complete_cu.command() {
  local cur="${COMP_WORDS[COMP_CWORD]}"
  COMPREPLY=( $(compgen -f -W "-c --confirm -v --verbose -l --line -t --timeout -s --signal -k --kill_after --lock_file --nonblock -h --help" -- "$cur") )
}
complete -F _complete_cu.command cu.command
