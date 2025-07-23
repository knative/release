#!/usr/bin/env bash


for repo in $(yq '.[] | .name' repos.yaml); do
  cat <<EOF >".github/workflows/${repo/\//-}.yaml"
# Copyright 2025 The Knative Authors.
# SPDX-License-Identifier: Apache-2.0

# This file is automagically generation from ./hack/update-workflows.sh

name: '$repo'

on:
  schedule:
    - cron: '0 13 * * 1-5' # 6am Pacific, weekdays.

  workflow_dispatch:
    inputs:
      release:
        type: string
        required: false
        description: Release Version

jobs:
  releasability:
    uses: ./.github/workflows/releasability.yaml
    with:
      repo: ${repo}
      release: \${{ inputs.release }}
      post-to-slack: \${{ github.event_name != 'schedule' }}
    secrets: inherit
EOF
done
