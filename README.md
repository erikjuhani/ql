# ql

Quickly write user logs with datestamp (HH:mm).

## Installation

Easiest way to install `ql` is with [shm](https://github.com/erikjuhani/shm).

To install `shm` run either one of these oneliners:

curl:

```sh
curl -sSL https://raw.githubusercontent.com/erikjuhani/shm/main/shm.sh | sh
```

wget:

```sh
wget -qO- https://raw.githubusercontent.com/erikjuhani/shm/main/shm.sh | sh
```

then run:

```sh
shm get erikjuhani/ql
```

to get the latest version of `ql`.

## Usage

```sh
ql <entry> [-l | --list] [-s | --search <search_term>] [-v | --view <log_filename>] [-h | --help]
```

### Options

```sh
-l --list	List all log entries found in .ql directory
-s --search	Search all log entries with a search term
-v --view	View a log entry with given
-h --help	Show help
```

### Examples

A longer log entry with heading and body

```sh
ql 'I went to a supermarket' 'I bought 10 apples' 'Keywords: apples, supermarket'
```

Search logs with a search term

```sh
ql -s 'apples'
```

List all logs

```sh
ql -l
```

View a log

```
ql -v 28022023
```
