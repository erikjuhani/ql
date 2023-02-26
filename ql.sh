#!/usr/bin/env sh

set -e

readonly QL_DIR="${HOME}/.ql"

help() {
  cat <<EOF
ql
Quickly write logs with datestamp (HH:mm). The logs are created under $HOME/.ql
folder. 

USAGE
	ql <entry> [-l | --list] [-s | --search <search_term>] [-v | --view <log_filename>] [-h | --help]

OPTIONS
	-l --list	List all log entries found in .ql directory
	-s --search	Search all log entries with a search term
	-v --view	View a log entry with given
	-h --help	Show help

EXAMPLES
	A longer log entry with heading and body.
	ql 'I went to a supermarket' 'I bought 10 apples' 'Keywords: apples, supermarket'

	Search logs with a search term
	ql -s 'apples'

	List all logs
	ql -l

	View a log
	ql -v 28022023

EOF
  exit 2
}

err() {
  printf >&2 "error: %s\n" "$@"
  exit 1
}

print() {
  printf "%b\n" "$@"
}

search() {
  echo "=> search logs with \"$1\""
  grep -ir --color=always "$1" "${QL_DIR}"
  exit
}

list() {
  ls -1 "${QL_DIR}"
  exit
}

view() {
  cat "${QL_DIR}/$1.log"
  exit
}

ql() {
  [ "$#" -eq 0 ] && help

  [ ! -d "${QL_DIR}" ] && {
    mkdir "${QL_DIR}"
  }

  for arg; do
    case "$arg" in
     -l | --list) [ -n "$2" ] && err "option $arg takes no arguments" || list ;;
     -s | --search) [ -z "$2" ] && err "option $arg takes one argument" || search "$2" ;;
     -v | --view) [ -z "$2" ] && err "option $arg takes one argument" || view "$2" ;;
     -h | --help) help ;;
      -*) err "Unknown option $arg" ;;
    esac
  done

  readonly filename="$(date '+%d%m%Y').log"
  readonly timestamp="$(date '+%H:%M')"

  print "=> writing ${filename}"

  raw_head="$1"
  head="$(printf "%s	%b\n" "${timestamp}" "$1")" 

  print "${head}\n" >> "${QL_DIR}/${filename}"

  shift

  body="$(printf "	%b\n" "$@")"

  print "${body}\n" >> "${QL_DIR}/${filename}"
  print "   + $(printf "%s%s" "${raw_head}" "${body}" | wc -c) bytes"
}

ql "$@"
