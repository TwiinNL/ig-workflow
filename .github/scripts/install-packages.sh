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

install nl.generiekefuncties.csd 1.0.0 \
  https://minvws.github.io/generiekefuncties-docs/package.tgz \
  847ea68d0ba5df6c0c2faa6a939d23f49e167401e338752d1ef72a3cf509c849

install nl.twiin.fhir.r4.notifications 0.1.0-draft \
  https://fhir.twiin.nl/ig/notifications/0.1.0-draft/package.tgz \
  bcf5baf254979caba62508179ec46739aca488adbbbfafae96f90def6a7b192c
