#!/usr/bin/env bash

function _complete_cu.date() {
  local cur="${COMP_WORDS[COMP_CWORD]}"
  COMPREPLY=( $(compgen -W "--out_utc --enable_fraction -h --help" -- "$cur") )
}
complete -F _complete_cu.date cu.date

function _complete_cu.date.from-epoch() {
  local cur="${COMP_WORDS[COMP_CWORD]}"
  COMPREPLY=( $(compgen -W "--out_utc --nanoseconds --microseconds --milliseconds --seconds --enable_fraction" -- "$cur") )
}
complete -F _complete_cu.date.from-epoch cu.date.from-epoch

function _complete_cu.date.to-epoch() {
  local cur="${COMP_WORDS[COMP_CWORD]}"
  COMPREPLY=( $(compgen -W "--date --out_nanoseconds --out_microseconds --out_milliseconds --out_seconds" -- "$cur") )
}
complete -F _complete_cu.date.to-epoch cu.date.to-epoch
