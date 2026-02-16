#!/usr/bin/env bash

if [[ "${BASH_VERSINFO[0]}" -lt 5 ]]
then
  echo 'bash version 5 or higher is required for command_utils'
  return
fi

IFS=' ' read -r _ python_version <<< $(python3 -V)
IFS='.' read -r python_version_major python_version_minor python_version_patch <<< $python_version

if [[ "${python_version_major}" -lt 3 || ("${python_version_major}" -eq 3 && "${python_version_minor}" -lt 11) ]]
then
  echo 'python version 3.11 or higher is required for command_utils'
  return
fi

function cu.pathadd() {
  local p="$(realpath "$1")"
  [[ ":$PATH:" == *":$p:"* ]] || export PATH="$p:$PATH"
}

cu.pathadd "${HOME}/.local/bin"

if [ -f "$HOME/.bashrc" ]
then
  function cu.reload-bashrc() {
    source "$HOME/.bashrc"
  }
  alias reload-bashrc='cu.reload-bashrc'
fi

function cu.quiet_source() {
  which "$1" > /dev/null || return 1
  source "$1"
}

cu.quiet_source _cu.completes.bash

function cu.python.venv-activate() {
  test -d ~/.python-venv || { echo 'Creating new venv'; cu.python -m venv ~/.python-venv;}
  source ~/.python-venv/bin/activate
}

source <(cu.persistent_source.print_sourceable --sh bash)
