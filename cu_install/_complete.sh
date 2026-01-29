#!/usr/bin/env bash
function _complete_cu.install() {
  local cur="${COMP_WORDS[COMP_CWORD]}"
  COMPREPLY=( $(compgen -W "--name --content --file --quiet" -- "$cur") )
}
complete -F _complete_cu.install cu.install

function _complete_cu.uninstall() {
  local cur="${COMP_WORDS[COMP_CWORD]}"
  COMPREPLY=( $(compgen -W "--name" -- "$cur") )
}
complete -F _complete_cu.uninstall cu.uninstall
