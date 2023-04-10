#!/usr/bin/env bash


start_marker="<!-- autogen start -->"
end_marker="<!-- autogen end -->"

sed -i '' "/${start_marker}/,/${end_marker}/d" TIMELINE.md

echo "${start_marker}" >> TIMELINE.md
for repo in $(yq '.[] | .name' repos.yaml); do

repo_no_prefix=${repo/knative\/}
repo_no_prefix=${repo_no_prefix/knative-sandbox\/}

  cat <<EOF >> TIMELINE.md
[${repo_no_prefix}-version-badge]: https://img.shields.io/github/release-pre/${repo}.svg?sort=semver
[${repo_no_prefix}-release-badge]: https://github.com/knative/release/workflows/${repo}/badge.svg
[${repo_no_prefix}-release-page]: https://github.com/${repo}/releases
[${repo_no_prefix}-release-workflow]: https://github.com/knative/release/actions/workflows/${repo/\//-}.yaml
[${repo_no_prefix}-nightly-badge]: https://prow.knative.dev/badge.svg?jobs=nightly_${repo_no_prefix}_main_periodic
[${repo_no_prefix}-nightly-page]: https://prow.knative.dev?job=nightly_${repo_no_prefix}_main_periodic
[${repo_no_prefix}-prow-badge]: https://prow.knative.dev/badge.svg?jobs=release_${repo_no_prefix}_main_periodic
[${repo_no_prefix}-prow-job]: https://prow.knative.dev?job=release_${repo_no_prefix}_main_periodic

EOF
done
echo "${end_marker}" >> TIMELINE.md

