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
-e --editor	Open provided text editor to write a log
-l --list	List all log entries found in .ql directory
-s --search	Search all log entries with a search term
-v --view	View a log entry with a given log filename
-h --help	Show help
```

### Examples

A longer log entry with heading and body

```sh
ql 'I went to a supermarket' 'I bought 10 apples' 'Keywords: apples, supermarket'
=> writing 19032023.log
   +       73 bytes
```

A log entry using a text editor. `ql` formats the given text into log format.
```sh
ql -e vim

> /temp_log_file
> I went to a supermarket
>
> I bought 10 apples
>
> Keywords: apples, supermarket

=> writing 19032023.log
   +       73 bytes
```

Search logs with a search term

```sh
ql -s apples
=> search logs with "apples"
19032023 ~ 10:18        I went to a supermarket
19032023 ~
19032023 ~      I bought 10 apples
19032023 ~      Keywords: apples, supermarket
```

List all logs

```sh
ql -l
19032023.log
```

View a log

```
ql -v 19032023.log
10:18	I went to a supermarket

	I bought 10 apples

	Keywords: apples, supermarket
```
