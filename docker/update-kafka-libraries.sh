#!/bin/sh
# Preserve byte-identical publisher jars and their embedded licenses/notices.
set -eu
lock=$1
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT HUP INT TERM
count=0
while IFS='|' read -r old new url checksum; do
  case "$old" in ''|'#'*) continue ;; esac
  case "$old$new" in *'/'*|*'..'*) exit 1 ;; esac
  case "$url" in https://repo.maven.apache.org/maven2/*) ;; *) exit 1 ;; esac
  test -f "/opt/kafka/libs/$old"
  test ! -e "/opt/kafka/libs/$new"
  wget -O "$work/$new" "$url"
  echo "$checksum  $work/$new" | sha512sum -c -
  count=$((count+1))
done < "$lock"
test "$count" -eq 25
while IFS='|' read -r old new url checksum; do
  case "$old" in ''|'#'*) continue ;; esac
  mv "$work/$new" "/opt/kafka/libs/$new"
  rm "/opt/kafka/libs/$old"
done < "$lock"
