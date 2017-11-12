#!/bin/bash

bakcmd="cp"
while getopts ":D" opt; do
  case $opt in
    D)
      bakcmd="mv";;
    ?)
      echo "backup: Invalid option '$OPTARG'."
      exit 1;;
  esac
done

shift $((OPTIND - 1))

pathname="$1"
if [ -z "$pathname" ]; then
  echo "Usage: backup file" >&2
  exit 1
fi

if [ ! -e "$pathname" ]; then
  echo "backup: $pathname: No such file or directory"
  exit 1
fi

directory=$(dirname "$1")
filename=$(basename "$1")

backup="$directory/.$filename.bak"
attempt="$backup"
let i=0;
while [ -e "$attempt" ]; do
  let i=i+1;
  attempt="$backup$i"
done
echo "backup: creating backup file $attempt" >&2

$bakcmd "$pathname" "$attempt"
