#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: restore-backup file" >&2
  exit 1
fi

pathname="$1"
filename=$(basename "$pathname")
dir=$(dirname "$pathname")

backup=".$filename.bak"
attempt=backup
found_one=false
matches=($(find "$dir" -maxdepth 1 -name "$backup*" | sort -V));
if [[ ${#matches[@]} > 1 ]]; then
  echo "$matches" >&2;
fi
for othername in ${matches[@]}; do
  found_one=true
  if [ -e $pathname ]; then
    echo "restore-backup: Overwrite $pathname with $othername? [Y/n]"
  else
    echo "restore-backup: Restore $pathname from $othername? [Y/n]"
  fi
  read response
  case "$response" in
    [Yy][Ee][Ss]|[yY])
      mv -f "$othername" "$pathname"
      break;;
  esac
done
if ! $found_one; then
  echo "restore-backup: No backups found for $pathname" >&2
  exit 2
fi
