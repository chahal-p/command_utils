#!/usr/bin/env bash

function _complete_cu.vars.create() {
  local cur="${COMP_WORDS[COMP_CWORD]}"
  COMPREPLY=( $(compgen -W "--var" -- "$cur") )
}
complete -F _complete_cu.vars.create cu.vars.create

function _complete_cu.vars.delete() {
  local cur="${COMP_WORDS[COMP_CWORD]}"
  COMPREPLY=( $(compgen -W "--var" -- "$cur") )
}
complete -F _complete_cu.vars.delete cu.vars.delete
