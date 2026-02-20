#!/usr/bin/env bash

CU_SUCCESS=0
CU_ERROR=1
CU_ERROR_USAGE=2
CU_ERROR_NOT_FOUND=40
CU_ERROR_PERMISSION=41
CU_ERROR_NOT_EXECUTABLE=126
CU_ERROR_COMMAND_NOT_FOUND=127
CU_ERROR_INVALID_ARGUMENT=128
CU_ERROR_COMMAND_TERMINATED=130

function cu.errors.echo() {
  [ ${#@} -gt 0 ] || return 0
  echo -e "\e[01;31m${@}\e[0m" >&2
}

function cu.errors.die() {
  local exit_code=${1:-$CU_ERROR}
  shift
  cu.errors.echo "${@}"
  exit $exit_code
}

function cu.errors.die_usage() {
  cu.errors.die $CU_ERROR_USAGE "${@}"
}

function cu.errors.die_not_found() {
  cu.errors.die $CU_ERROR_NOT_FOUND "${@}"
}

function cu.errors.assert() {
  [ ${#@} -eq 2 ] || { cu.errors.echo "Usage: cu.errors.assert <expected_exit_code> <actual_exit_code>"; return 1; }
  [ ${1} -eq ${2} ] && return 0 || return 1
}

function cu.errors.is_success() {
  cu.errors.assert $CU_SUCCESS $1
}

function cu.errors.is_error() {
  cu.errors.is_success $1 && return 1 || return 0
}

function cu.errors.is_not_found() {
  cu.errors.assert $CU_ERROR_NOT_FOUND $1
}
