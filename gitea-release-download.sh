#!/bin/bash
#
# A script to download an artifact from the latest Gitea release for a project.
#
# ORG_PROJ is the pair of URL components for organization/projectName in Github URL
# example: https://gitea.com/gitea/act_runner/releases
#   ORG_PROJ would be "gitea/act_runner"
#
# OUT_NAME is the filename (may include path) to which the downloaded file will be written

ORG_PROJ=${1}
SUFFIX=${2}
OUT_NAME=${3}

usage() {
  echo "$0 ORG_PROJ SUFFIX OUT_NAME"
  echo "    ORG_PROJ - organization/projectname"
  echo "    SUFFIX   - trailing part of rpm name: eg, linux-amd64 or linux-arm64.xz"
  echo "    OUT_NAME - name of file to write to disk"

}

if [ -z ${ORG_PROJ} ]; then
  usage
  exit 1
fi

if [ -z ${SUFFIX} ]; then
  usage
  exit 2
fi

if [ -z ${OUT_NAME} ]; then
  usage
  exit 3
fi

API="https://gitea.com/api/v1/repos/${ORG_PROJ}/releases/latest"
RPM_URLS=$(curl -sL ${API} | jq -r '.assets[].browser_download_url' | grep -E "${SUFFIX}$" | sort -r)
for URL in ${RPM_URLS}; do
  # WARNING: in case of multiple matches, this only installs the first (hopefully the newest, given the reverse sort)
  echo "execute: curl -L -o \"${OUT_NAME}\" \"${URL}\""
  curl -L -o "${OUT_NAME}" "${URL}"
  break
done
