#!/usr/bin/env bash
function _complete_cu.openssl.decode-cert() {
  local cur="${COMP_WORDS[COMP_CWORD]}"
  COMPREPLY=( $(compgen -d -f -W "-f --file --inform" -- "$cur") )
}
complete -F _complete_cu.openssl.decode-cert cu.openssl.decode-cert

function _complete_cu.openssl.decode-csr() {
  local cur="${COMP_WORDS[COMP_CWORD]}"
  COMPREPLY=( $(compgen -d -f -W "-f --file --inform" -- "$cur") )
}
complete -F _complete_cu.openssl.decode-csr cu.openssl.decode-csr

function _complete_cu.openssl.decode-crl() {
  local cur="${COMP_WORDS[COMP_CWORD]}"
  COMPREPLY=( $(compgen -d -f -W "-f --file" -- "$cur") )
}
complete -F _complete_cu.openssl.decode-crl cu.openssl.decode-crl

function _complete_cu.openssl.decode-key() {
  local cur="${COMP_WORDS[COMP_CWORD]}"
  COMPREPLY=( $(compgen -d -f -W "-f --file --inform --type" -- "$cur") )
}
complete -F _complete_cu.openssl.decode-key cu.openssl.decode-key

function _complete_cu.openssl.decode-asn1() {
  local cur="${COMP_WORDS[COMP_CWORD]}"
  COMPREPLY=( $(compgen -d -f -W "-f --file --inform" -- "$cur") )
}
complete -F _complete_cu.openssl.decode-asn1 cu.openssl.decode-asn1

function _complete_cu.openssl.tbs-extract() {
  local cur="${COMP_WORDS[COMP_CWORD]}"
  COMPREPLY=( $(compgen -d -f -W "-f --file --inform -o --outfile" -- "$cur") )
}
complete -F _complete_cu.openssl.tbs-extract cu.openssl.tbs-extract

function _complete_cu.openssl.signature-extract() {
  local cur="${COMP_WORDS[COMP_CWORD]}"
  COMPREPLY=( $(compgen -d -f -W "-f --file --inform -o --outfile" -- "$cur") )
}
complete -F _complete_cu.openssl.signature-extract cu.openssl.signature-extract

function _complete_cu.openssl.convert-x509-der-to-pem() {
  local cur="${COMP_WORDS[COMP_CWORD]}"
  COMPREPLY=( $(compgen -d -f -W "-f --file -o --outfile" -- "$cur") )
}
complete -F _complete_cu.openssl.convert-x509-der-to-pem cu.openssl.convert-x509-der-to-pem

function _complete_cu.openssl.convert-x509-pem-to-der() {
  local cur="${COMP_WORDS[COMP_CWORD]}"
  COMPREPLY=( $(compgen -d -f -W "-f --file -o --outfile" -- "$cur") )
}
complete -F _complete_cu.openssl.convert-x509-pem-to-der cu.openssl.convert-x509-pem-to-der

function _complete_cu.openssl.publickey-extract() {
  local cur="${COMP_WORDS[COMP_CWORD]}"
  COMPREPLY=( $(compgen -d -f -W "-f --file -o --outfile --inform --outform" -- "$cur") )
}
complete -F _complete_cu.openssl.publickey-extract cu.openssl.publickey-extract
