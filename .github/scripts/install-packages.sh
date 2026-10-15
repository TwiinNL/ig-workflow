#!/usr/bin/env bash
# Installs the dependencies that are not on the FHIR package registry into the local
# package cache (~/.fhir/packages), after checking the pinned sha-256 of each tarball.
# Fails when a download fails or a checksum differs. Run before SUSHI, in CI and locally.
# An existing cache entry for the same name and version is replaced.
set -euo pipefail

cache="${FHIR_PACKAGE_CACHE:-$HOME/.fhir/packages}"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

install() {
  local name="$1" version="$2" url="$3" sha="$4"
  local tgz="$tmp/$name#$version.tgz"
  curl -sSfL -o "$tgz" "$url"
  local actual
  actual="$(shasum -a 256 "$tgz" | cut -d' ' -f1)"
  if [ "$actual" != "$sha" ]; then
    echo "::error::$name#$version: sha-256 $actual, expected $sha ($url)" >&2
    exit 1
  fi
  local dir="$cache/$name#$version"
  rm -rf "$dir"
  mkdir -p "$dir"
  tar xzf "$tgz" -C "$dir"
  echo "Installed $name#$version (sha-256 $sha)"
}

install nl.twiin.fhir.r4.notifications 0.1.1-draft \
  https://fhir.twiin.nl/ig/notifications/0.1.1-draft/package.tgz \
  cec58f60184740ec51994b44c5ae4ddc42b870576ff20cfc831f9a47a183f2fd
