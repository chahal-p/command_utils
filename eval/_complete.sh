#!/usr/bin/env bash
function _complete_cu.eval() {
  local cur="${COMP_WORDS[COMP_CWORD]}"
  COMPREPLY=( $(compgen -W "-c --confirmation -v --verbose --serialized_args" -- "$cur") )
}
complete -F _complete_cu.eval cu.eval

function _complete_cu.eval.with_lock() {
  local cur="${COMP_WORDS[COMP_CWORD]}"
  COMPREPLY=( $(compgen -W "--lock_id --timeout" -- "$cur") )
}
complete -F _complete_cu.eval.with_lock cu.eval.with_lock
