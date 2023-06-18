#!/usr/bin/env sh

set -e

readonly QL_DIR="${HOME}/.ql"

help() {
  cat <<EOF
ql
Quickly write logs with datestamp (HH:mm). The logs are created under $HOME/.ql
folder. 

USAGE
	ql <entry> [-e | --editor <editor>] [-l | --list] [-s | --search <search_term>] [-v | --view <log_filename>] [-h | --help]

OPTIONS
	-e --editor	Open provided text editor to write a log
	-l --list	List all log entries found in .ql directory
	-s --search	Search all log entries with a search term
	-v --view	View a log entry with a given log filename
	-h --help	Show help

EXAMPLES
	A longer log entry with heading and body.
	ql 'I went to a supermarket' 'I bought 10 apples' 'Keywords: apples, supermarket'
	=> writing 19032023.log
	   +       73 bytes

	A log entry using a text editor.
	ql -e vim

	> /temp_log_file
	> I went to a supermarket
	>
	> I bought 10 apples
	>
	> Keywords: apples, supermarket

	=> writing 19032023.log
	   +       73 bytes

	Search logs with a search term
	ql -s apples
	=> search logs with "apples"
	I bought 10 apples
	Keywords: apples, supermarket

	List all logs
	ql -l
	28022023.log

	View a log
	ql -v 28022023.log
	10:18	I went to a supermarket

		I bought 10 apples

		Keywords: apples, supermarket

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
  grep -irh --color=always "$1" "${QL_DIR}" | sed 's/^\t*//'
  exit
}

list() {
  ls -1 -t -U "${QL_DIR}"
  exit
}

view() {
  cat "${QL_DIR}/$1"
  exit
}

write_log() {
  readonly timestamp="$(date '+%H:%M')"

  raw_head="$1"
  head="$(printf "%s	%b\n" "${timestamp}" "$1")"
  head="$(print "${head}" | fold -s | sed '2,$s/^/\t/')"

  print "${head}\n" >> "${QL_DIR}/${filename}"

  shift

  body="$(printf "%b\n\n" "$@")"
  body="$(print "${body}" | fold -s | sed 's/^/\t/')"

  print "${body}\n" >> "${QL_DIR}/${filename}"
  print "   + $(printf "%s%s" "${raw_head}" "${body}" | wc -c) bytes"

  exit 0
}

ql() {
  [ "$#" -eq 0 ] && help

  [ ! -d "${QL_DIR}" ] && {
    mkdir "${QL_DIR}"
  }

  for arg; do
    case "$arg" in
     -e | --editor) [ -z "$2" ] && err "option $arg takes one argument" || editor="$2";;
     -l | --list) [ -n "$2" ] && err "option $arg takes no arguments" || list ;;
     -s | --search) [ -z "$2" ] && err "option $arg takes one argument" || search "$2" ;;
     -v | --view) [ -z "$2" ] && err "option $arg takes one argument" || view "$2" ;;
     -h | --help) help ;;
      -*) err "Unknown option $arg" ;;
    esac
  done

  readonly filename="$(date '+%d%m%Y').log"

  print "=> writing ${filename}"

  if [ -n "${editor}" ]; then
    temp_log_file="$(mktemp)"

    command "${editor}" "${temp_log_file}"

    log_content="$(cat "${temp_log_file}")"

    rm "${temp_log_file}"

    [ -z "${log_content}" ] && err "empty log"

    write_log "${log_content}"
  fi

  write_log "$@"
}

ql "$@"
