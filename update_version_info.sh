#!/bin/bash

OVERLAY_VERSION=$(curl -sX GET "https://raw.githubusercontent.com/hydazz/docker-baseimage-alpine/main/version_info.json" | jq -r .overlay_version)
MONO_VERSION=$(grep <package_versions.txt -E "mono-runtime.*?-" | sed -n 1p | cut -c 14- | sed -E 's/-r.*//g')

OLD_OVERLAY_VERSION=$(jq <version_info.json -r .overlay_version)
OLD_MONO_VERSION=$(jq <version_info.json -r .mono_version)

sed -i \
	-e "s/${OLD_OVERLAY_VERSION}/${OVERLAY_VERSION}/g" \
	-e "s/${OLD_MONO_VERSION}/${MONO_VERSION}/g" \
	README.md

NEW_VERSION_INFO="overlay_version|mono_version
${OVERLAY_VERSION}|${MONO_VERSION}"

jq -Rn '
( input  | split("|") ) as $keys |
( inputs | split("|") ) as $vals |
[[$keys, $vals] | transpose[] | {key:.[0],value:.[1]}] | from_entries
' <<<"$NEW_VERSION_INFO" >version_info.json
