#!/bin/sh
# Install only reviewed, integrity-pinned public APKs; keep upstream signature verification.
set -eu
lock=$1
shift
arch=$(apk --print-arch)
case "$arch" in aarch64|x86_64) ;; *) echo 'Only arm64 and amd64 package pins have been reviewed' >&2; exit 1 ;; esac
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT HUP INT TERM
for package in "$@"; do
  matches=$(awk -F '|' -v a="$arch" -v p="$package" '$1 == a && $2 == p {n++} END {print n+0}' "$lock")
  test "$matches" -eq 1
  row=$(awk -F '|' -v a="$arch" -v p="$package" '$1 == a && $2 == p {print}' "$lock")
  IFS='|' read -r recorded_arch name version url checksum <<EOF
$row
EOF
  test "$recorded_arch" = "$arch" && test "$name" = "$package"
  case "$url" in "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/$arch/$name-$version.apk") ;; *) exit 1 ;; esac
  wget -O "$work/$name.apk" "$url"
  echo "$checksum  $work/$name.apk" | sha256sum -c -
done
apk add --no-cache --no-network "$work"/*.apk
for package in "$@"; do
  version=$(awk -F '|' -v a="$arch" -v p="$package" '$1 == a && $2 == p {print $3}' "$lock")
  apk info --no-network --exists "$package=$version"
done
