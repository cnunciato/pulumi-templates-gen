#!/bin/bash

set -o errexit -o pipefail
source ./scripts/common.sh

read -p "cloud: " cloud
read -p "lang: " lang

test_dir="dist-next/serverless-test-${cloud}-${lang}"

pulumi -C "$test_dir" destroy --yes || true
pulumi -C "$test_dir" stack rm --yes || true
rm -rf "$test_dir"
mkdir -p "$test_dir"

pushd "$test_dir"

    if [ "$cloud" == "gcp" ]; then
        pulumi new "../../dist/serverless-${cloud}-${lang}" -c "gcp:project=pulumi-development"
    else
        pulumi new "../../dist/serverless-${cloud}-${lang}"
    fi

    code .
popd
