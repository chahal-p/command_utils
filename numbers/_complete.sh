#!/usr/bin/env bash

function _complete_cu.numbers.convert() {
  local cur="${COMP_WORDS[COMP_CWORD]}"
  COMPREPLY=( $(compgen -W "-h --help ascii-to-char bin-to-dec bin-to-hex char-to-ascii dec-to-bin dec-to-hex dec-to-oct hex-to-bin hex-to-dec oct-to-bin oct-to-dec" -- "$cur") )
}

complete -F _complete_cu.numbers.convert cu.numbers.convert