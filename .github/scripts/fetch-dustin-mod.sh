#!/usr/bin/env bash
set -euo pipefail

build_id="2042946"
endpoint="https://gamejolt.com/site-api/web/discover/games/builds/get-download-url/${build_id}"
response="$(curl --fail --silent --show-error --location \
  --retry 3 --retry-delay 2 \
  --data 'forceDownload:true' "${endpoint}")"
download_url="$(jq -er '.payload.url' <<< "${response}")"

mkdir -p /tmp/dustin-download /tmp/dustin-extracted mods/Dustin
curl --fail --silent --show-error --location \
  --retry 3 --retry-delay 2 \
  "${download_url}" -o /tmp/dustin-download/mod-archive

file /tmp/dustin-download/mod-archive
if unzip -tq /tmp/dustin-download/mod-archive >/dev/null 2>&1; then
  unzip -q /tmp/dustin-download/mod-archive -d /tmp/dustin-extracted
elif tar -tf /tmp/dustin-download/mod-archive >/dev/null 2>&1; then
  tar -xf /tmp/dustin-download/mod-archive -C /tmp/dustin-extracted
else
  echo "The downloaded build is not a ZIP or TAR archive." >&2
  exit 1
fi

shopt -s dotglob nullglob
entries=(/tmp/dustin-extracted/*)
if [[ ${#entries[@]} -eq 1 && -d "${entries[0]}" ]]; then
  inner_entries=("${entries[0]}"/*)
  if [[ ${#inner_entries[@]} -gt 0 ]]; then
    cp -a "${inner_entries[@]}" mods/Dustin/
  fi
elif [[ ${#entries[@]} -gt 0 ]]; then
  cp -a "${entries[@]}" mods/Dustin/
fi

echo "Fetched mod file sample:"
find mods/Dustin -type f -print | sed -n '1,80p'
test -n "$(find mods/Dustin -type f -print -quit)" || {
  echo "No mod files were extracted." >&2
  exit 1
}
