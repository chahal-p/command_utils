#!/usr/bin/env bash

function _complete_cu.date.from-epoch() {
  local cur="${COMP_WORDS[COMP_CWORD]}"
  COMPREPLY=( $(compgen -W "--out-utc --nanoseconds --microseconds --milliseconds --seconds" -- "$cur") )
}
complete -F _complete_cu.date.from-epoch cu.date.from-epoch

function _complete_cu.date.to-epoch() {
  local cur="${COMP_WORDS[COMP_CWORD]}"
  COMPREPLY=( $(compgen -W "--date --out-nanoseconds --out-microseconds --out-milliseconds --out-seconds" -- "$cur") )
}
complete -F _complete_cu.date.to-epoch cu.date.to-epoch

function _complete_cu.date.add_sub() {
  local cur="${COMP_WORDS[COMP_CWORD]}"
  COMPREPLY=( $(compgen -W "add subtract --date --nanoseconds --microseconds --milliseconds --seconds --minutes --hours --days --out-utc" -- "$cur") )
}
complete -F _complete_cu.date.add_sub cu.date.add_sub

function _complete_cu.date.add() {
  local cur="${COMP_WORDS[COMP_CWORD]}"
  COMPREPLY=( $(compgen -W "--date --nanoseconds --microseconds --milliseconds --seconds --minutes --hours --days --out-utc" -- "$cur") )
}
complete -F _complete_cu.date.add cu.date.add

function _complete_cu.date.subtract() {
  local cur="${COMP_WORDS[COMP_CWORD]}"
  COMPREPLY=( $(compgen -W "--date --nanoseconds --microseconds --milliseconds --seconds --minutes --hours --days --out-utc" -- "$cur") )
}
complete -F _complete_cu.date.subtract cu.date.subtract
