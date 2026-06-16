#!/usr/bin/env bash

_complete_cu.vars() {
  COMPREPLY=()
  local cmd="${COMP_WORDS[0]}"
  local second_arg="${COMP_WORDS[1]}"
  local cur_word="${COMP_WORDS[COMP_CWORD]}"
  local prev_word="${COMP_WORDS[COMP_CWORD-1]}"
  if [[ "$prev_word" == "$cmd" ]] ; then
    if [[ $cur_word == "-"* ]] ; then
      COMPREPLY=( $(compgen -W "-d --delete --envs -h --help" -- "$cur_word") )
    else
      COMPREPLY=( $(compgen -W "$(cu.vars | xargs)" -- "$cur_word") )
    fi
  elif [[ "$prev_word" == "--delete" || "$prev_word" == "-d" ]] ; then
    COMPREPLY=( $(compgen -W "$(cu.vars | xargs)" -- "$cur_word") )
  elif [[ "$prev_word" == "--show" ]] ; then
    COMPREPLY=( $(compgen -W "$(cu.vars | xargs)" -- "$cur_word") )
  elif [[ ! $second_arg == "-"* ]]; then
    COMPREPLY=( $(compgen -f -d -- "$cur_word") )
  fi
}
complete -F _complete_cu.vars cu.vars
