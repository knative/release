# Knative Release

This document includes the roster, instructions and timetable to perform a
Knative release.

For each release cycle, we dedicate a team of two individuals, one from Eventing
and one from Serving, to shepherd the release process. Participation is
voluntary and based on good faith. We are only expected to participate during
our local office hour.

---

# Roster

We seed this rotation with all approvers from all the Serving and Eventing
workgroups, excluding productivity. If you are no longer active in Knative, or
if you are contributing on personal capacity and do not have time to contribute
in the rotation, feel free to send a PR to remove yourself.

## Serving

This roster is seeded with all approvers from Serving workgroups, plus additional volunteers.

- dprotaso
- julz
- nak3
- psschwei
- ZhiminXiang

## Eventing

This roster is seeded with all approvers from Eventing workgroups, plus additional volunteers.

- evankanderson
- lionelvillard
- matzew

## Client roster

This roster is seeded with approvers from the Client workgroups.

- dsimansk
- rhuss

## Schedule

| Release | Release Date | Serving        | Eventing            | PKG cut    | Unpin repos
| ------- | ------------ | -------------- | --------------------| ---------- | -----------
| v1.4    | 2022-04-19   | nader-ziada    | ikvmw               | 2022-04-12 | 2022-04-20
| v1.5    | 2022-05-31   | dprotaso       | lionelvillard       | 2022-05-24 | 2022-06-01
| v1.6    | 2022-07-12   | ZhiminXiang    | evankanderson       | 2022-07-05 | 2022-07-13
| v1.7    | 2022-08-23   | dprotaso       | matzew              | 2022-08-16 | 2022-08-24
| v1.8    | 2022-10-04   | nak3           | lionelvillard       | 2022-09-27 | 2022-10-05
| v1.9    | 2022-11-15   | psschwei       | evankanderson       | 2022-11-08 | 2022-11-16

---

# Instructions

Below you'll find the instructions to release a `knative.dev` repository.

For more information on the timetable, jump to the [Timetable](#timetable)
paragraph.

## Release a repository

Releasing a repository includes:

- Aligning the `knative.dev` dependencies to the other release versions on
  main (except hack, which has no dependencies)
- For some repositories some additional validation need to be performed before a release can be cut. Check [special repository checks](#special-repository-actions) for which repository extra steps needs to be performed.
- Creating a new branch starting from main for the release (e.g.
  `release-0.20`)
- Execute the job on Prow that builds the code from the release branch, tags the
  revision, publishes the images, publishes the yaml artifacts and generates the
  Github release.

Most of the above steps are automated, although in some situations it might be
necessary to perform some of them manually.

### Check the build on main passes

Before beginning, check if the repository is in a good shape and the builds pass
consistently. **This is required** because the Prow job that builds the release
artifacts will execute all the various tests (build, unit, e2e) and, if
something goes wrong, you will probably need to restart this process from the
beginning.

For any problems in a specific repo, get in touch with the relevant WG leads to
fix them.

### Aligning the dependencies

In order to align the `knative.dev` dependencies, knobots will perform PRs like
[this](https://github.com/knative/eventing/pull/4713) for each repo, executing
the command `./hack/update-deps.sh --upgrade --release 0.20` and committing all
the content.

If no dependency bump PR is available, you can either:

- Manually trigger the generation of these PRs starting the
  [Knobots Auto Update Deps](https://github.com/knative-sandbox/knobots/actions/workflows/auto-update-deps.yaml)
  and wait for the PR to pop in the repo you need. Note you have to change the
  field `If true, send update PRs even for deps changes that don't change vendor. Use this only for releases.`
  to true, because in some cases there no code changes in the vendor.
- Execute the script below on your machine:

```shell
RELEASE=0.20
REPO=git@github.com:knative/example.git

tmpdir=$(dirname $(mktemp -u))
cd ${tmpdir}
git clone ${REPO}
cd "$(basename "${REPO}" .git)"

./hack/update-deps.sh --upgrade --release ${RELEASE}
./hack/update-codegen.sh

# If there are no changes, you can go to the next step without committing any change.
# Otherwise, commit all the changes
git status
```
- Commit the changes and send a PR against the `main` branch. Before doing so, check whether some additional, manual updates are required, that you can also add to this PR (to save some roundtrips). Section [Special repository actions](#special-repository-actions) contains the repository specific instructions (if any).

### Special repository actions

For some repositories some extra manual validation and updates need to be performed before the release branch is cut:

#### knative/client

* Update the version numbers of Serving and Eventing in [test/presubmit-integration-tests-latest-release.sh](https://github.com/knative/client/blob/main/test/presubmit-integration-tests-latest-release.sh#L20-L21) so that the integration test is already running against the just released serving and eventing versions.
* (optional) Check that [CHANGELOG.adoc](https://github.com/knative/client/blob/main/CHANGELOG.adoc) contains a section about the release, i.e. the top-level "(Unreleased)" section should be changed to point to the upcoming release version and number. It's not critical if the changelog is aligned after the release in retrospective.

If the validation fails, the fix should be trivial and could be either performed by the release leads or the client team.

#### knative-sandbox/kn-plugin-quickstart

* Update the version numbers of Serving / Kourier / Eventing in [pkg/install/install.go](https://github.com/knative-sandbox/kn-plugin-quickstart/blob/main/pkg/install/install.go#L25-L27) so that the plugin will use the just-released versions.

### Releasability

At this point, you can proceed with the releasability check. A releasability
check is executed periodically and posts the result on the Slack release channel
and it fails if the dependencies are not properly aligned. If you don't want to
wait, you can manually execute the
[Releasability workflow](https://github.com/knative/serving/actions?query=workflow%3AReleasability).

If the releasability reports NO-GO, probably there is some deps misalignment,
hence you need to go back to the previous step and check the dependencies,
otherwise, you're ready to proceed.

You can execute the releasability check locally using
[**buoy**](https://github.com/knative/test-infra/tree/main/buoy):

```bash
RELEASE=0.20
REPO=git@github.com:knative/example.git

tmpdir=$(dirname $(mktemp -u))
cd ${tmpdir}
git clone ${REPO}
cd "$(basename "${REPO}" .git)"

if buoy check go.mod --domain knative.dev --release ${RELEASE} --verbose; then
  git checkout -b release-${RELEASE}
  ./hack/update-deps.sh --upgrade --release ${RELEASE}
  git status
fi
```

If there are changes, then it's NO-GO, otherwise it's GO.

NOTE: The releasability check will not work on dot releases and there is a potential for false positives.

### Just one last check before cutting

After the dependencies are aligned and releasability is ready to GO, perform one
last check manually that every `knative.dev` in the `go.mod` file is properly
configured:

- For the _support_ repos (`hack`, `pkg`, etc) you should see the
  dependency version pointing at a revision which should match the `HEAD` of the
  release branch. E.g. `knative.dev/pkg v0.0.0-20210112143930-acbf2af596cf`
  points at the revision `acbf2af596cf`, which is the `HEAD` of the
  `release-0.20` branch in `pkg` repo.
- For the _release_ repos, you should see the dependency version pointing at the
  version tag. E.g. `knative.dev/eventing v0.20.0` points at the tag `v0.20.0`
  in the `eventing` repo.

### Cut the branch

Now you're ready to create the `release-x.y` branch. This can be done by using
the GitHub UI:

1. Click on the branch selection box at the top level page of the repository.

   ![Click the branch selection box](images/github-branch.png)

1. Search for the correct `release-x.y` branch name for the release.

   ![Search for the expected release branch name](images/github-branch-search.png)

1. Click "Create branch: release-x.y".

   ![Click create branch: release-x.y](images/github-branch-create.png)

Otherwise, you can do it by hand on your local machine.

### The Prow job

After a `release-x.y` branch exists, a 4 hourly prow job will build the code
from the release branch, tag the revision, publish the images, publish the yaml
artifacts and generate the Github release. Update the description of the release
with the release notes collected.

You can manually trigger the release:

1. Navigate to https://prow.knative.dev/

   ![Prow homepage](images/prow-home.png)

1. Search for the `*-auto-release` job for the repository.

   ![Search Prow for the repo and select the auto-release](images/prow-search.png)

1. Rerun the auto-release job.

   ![Rerun Prow Auto Release](images/prow-rerun.png)

### Verify nightly release automation is intact

The automation used to cut the actual releases is the very same as the
automation used to cut nightly releases. Verify via testgrid that all relevant
nightly releases are passing. If they are not coordinate with the relevant WG
leads to fix them.

### What could go wrong?

In case you cut a branch before it was ready (e.g. some deps misalignment, a
failing test, etc), then follow the steps below:

1. Mark the broken release as a `pre-release`
1. Create a dot release
1. Repeat the steps for a release for the new dot release


---

# Timetable

We release the components of Knative every 6 weeks. All of these components must
be moved to the latest "release" of all shared dependencies prior to each
release.

## First week of the rotation

### Make sure you have the right permission

Check to make sure you already are in the "Knative Release Leads" team in
https://github.com/knative/community/blob/main/peribolos/knative.yaml and
https://github.com/knative/community/blob/main/peribolos/knative-sandbox.yaml
. If not, send a PR like
[this one](https://github.com/knative/community/pull/209) to grant yourself some
super power. Ensure to run `/hack/update-codegen.sh` to add yourself to the owner
files as well, as part of the PR.

### Create a release Slack channel

Ask someone from the TOC to create a **release-`#`** Slack channel that will be
used to help manage this release.

## 14 days prior to the release

### Update the Knative releasability defaults

Update the defaults in
[knative-releasability.yaml](https://github.com/knative-sandbox/knobots/blob/main/workflow-templates/knative-releasability.yaml)
to this release [sample PR](https://github.com/knative-sandbox/knobots/pull/170).

These changes will be propagated to the rest of Knative in the next round of
workflow syncs. Check to ensure that it has indeed propagated and if not the sync will have to manually triggered.

### Announce the imminent `pkg` cut

Announce on **#general** that `pkg` will be cut in a week.

## 7 days prior to the release

### Cut release branches of supporting repos

The supporting repos are the base repos where we have common code and common
scripts. For these repos (except **hack**), we follow the same release process as
explained in [release a repository](#release-a-repository), but no prow job is
executed, hence no git tag and Github release are produced.

First repo that needs to be released is **hack**. As mentioned, **hack** is
special because it has no dependencies and hence there's no releasability
checks, just ensure there are no outstanding PRs and
[create a release branch](#cut-the-branch).

- [knative/hack](https://github.com/knative/hack)

After **hack** release branch has been cut, follow the
[release a repository](#release-a-repository) guide for the following repos
skipping the prow job part:

| Repo                                                            | Releasability                                                                             |
| --------------------------------------------------------------- | ----------------------------------------------------------------------------------------- |
| [knative.dev/pkg](https://github.com/knative/pkg)               | [![Releasability](https://github.com/knative/pkg/workflows/Releasability/badge.svg)](https://github.com/knative/pkg/actions/workflows/knative-releasability.yaml)        |

After **pkg** repo has their release branch cut, follow
the [release a repository](#release-a-repository) guide for the following repos
skipping the prow job part:

| Repo                                                                              | Releasability                                                                                          |
| --------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------ |
| [knative.dev/networking](https://github.com/knative/networking)                   | [![Releasability](https://github.com/knative/networking/workflows/Releasability/badge.svg)](https://github.com/knative/networking/actions/workflows/knative-releasability.yaml)              |
| [knative.dev/caching](https://github.com/knative/caching)                         | [![Releasability](https://github.com/knative/caching/workflows/Releasability/badge.svg)](https://github.com/knative/caching/actions/workflows/knative-releasability.yaml)                 |
| [knative.dev/reconciler-test](https://github.com/knative-sandbox/reconciler-test) | [![Releasability](https://github.com/knative-sandbox/reconciler-test/workflows/Releasability/badge.svg)](https://github.com/knative-sandbox/reconciler-test/actions/workflows/knative-releasability.yaml) |

After **reconciler-test** repo has been cut, follow the
[release a repository](#release-a-repository) guide for the following repos
skipping the prow job part:

| Repo                                                                                | Releasability                                                                                           |
| ----------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------- |
| [knative.dev/control-protocol](https://github.com/knative-sandbox/control-protocol) | [![Releasability](https://github.com/knative-sandbox/control-protocol/workflows/Releasability/badge.svg)](https://github.com/knative-sandbox/control-protocol/actions/workflows/knative-releasability.yaml) |

Automation will propagate these updates to all the downstream repos in the next
few cycles. The goal is to have the first wave of repo releases (**serving**,
**eventing**, etc) to become "releasable" by the end of the week. This is
signaled via the Slack report of releasability posted to the **release-`#`**
channel every morning (5am PST, M-F).

### Announce the imminent release cut

Announce on **#general** that the release will be cut in a week and that
additional caution should be used when merging big changes.

### Check nightly builds

Check the status of the nightly builds for each repo. If they are failing,
reach out the respective WG leads to investigate.

### Collect release-notes

Make a new HackMD release notes document.
[last release notes document](https://hackmd.io/cJwvzJ4eRVeqqiXzOPtxsA), empty
it out and send it to the WG leads of the respective project (serving or
eventing) to fill in. Coordinate with both serving and eventing leads.

Each repo has a `Release Notes` GitHub Action workflow. This can be used to
generate the starting point for the release notes. See an example in
[Eventing](https://github.com/knative/eventing/actions?query=workflow%3A%22Release+Notes%22).
The default starting and ending SHAs will work if running out of the `main`
branch, or you can determine the correct starting and ending SHAs for the script
to run.

## 1 day prior to the release

### Confirm readiness

Confirm with the respective WG leads that the release is imminent and obtain
green light.

### Check nightly builds

Check the status of the nightly builds for each repo. If they are failing,
reach out the respective WG leads to investigate.

## Day of the release

Follow the [release a repository](#release-a-repository) instructions for each
repo. Wait for [release automation](#the-prow-job) to kick in (runs on a 2 hour
interval). Once the release automation passed, it will create a release tag in
the repository. Enhance the respective tags with the collected release-notes
using the GitHub UI.

**NOTE:** The release day does not mean one has to release everything. The 
pipeline outlined below will take time to complete and it is ok for the release
to take days. The day of the release marks the beginning of this process.

In general the release dependency order is something like the following (as of
v0.20). Note: `buoy check` will fail if the dependencies are not yet ready.

First:

| Repo                                                                                  | Release                                                                                                                                                                   | Releasability                                                                                            | Nightly                                                                                                  |
| ------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------- |
| [knative.dev/serving](https://github.com/knative/serving)                             | [![Releases](https://img.shields.io/github/release-pre/knative/serving.svg?sort=semver)](https://github.com/knative/serving/releases)                                     | [![Releasability](https://github.com/knative/serving/workflows/Releasability/badge.svg)](https://github.com/knative/serving/actions/workflows/knative-releasability.yaml)                   | [![Nightly](https://prow.knative.dev/badge.svg?jobs=nightly_serving_main_periodic)](https://prow.knative.dev?job=nightly_serving_main_periodic)                   |
| [knative.dev/net-certmanager](https://github.com/knative-sandbox/net-certmanager)     | [![Releases](https://img.shields.io/github/release-pre/knative-sandbox/net-certmanager.svg?sort=semver)](https://github.com/knative-sandbox/net-certmanager/releases)     | [![Releasability](https://github.com/knative-sandbox/net-certmanager/workflows/Releasability/badge.svg)](https://github.com/knative-sandbox/net-certmanager/actions/workflows/knative-releasability.yaml)   | [![Nightly](https://prow.knative.dev/badge.svg?jobs=nightly_net-certmanager_main_periodic)](https://prow.knative.dev?job=nightly_net-certmanager_main_periodic)   |
| [knative.dev/net-contour](https://github.com/knative-sandbox/net-contour)             | [![Releases](https://img.shields.io/github/release-pre/knative-sandbox/net-contour.svg?sort=semver)](https://github.com/knative-sandbox/net-contour/releases)             | [![Releasability](https://github.com/knative-sandbox/net-contour/workflows/Releasability/badge.svg)](https://github.com/knative-sandbox/net-contour/actions/workflows/knative-releasability.yaml)       | [![Nightly](https://prow.knative.dev/badge.svg?jobs=nightly_net-contour_main_periodic)](https://prow.knative.dev?job=nightly_net-contour_main_periodic)       |
| [knative.dev/net-http01](https://github.com/knative-sandbox/net-http01)               | [![Releases](https://img.shields.io/github/release-pre/knative-sandbox/net-http01.svg?sort=semver)](https://github.com/knative-sandbox/net-http01/releases)               | [![Releasability](https://github.com/knative-sandbox/net-http01/workflows/Releasability/badge.svg)](https://github.com/knative-sandbox/net-http01/actions/workflows/knative-releasability.yaml)        | [![Nightly](https://prow.knative.dev/badge.svg?jobs=nightly_net-http01_main_periodic)](https://prow.knative.dev?job=nightly_net-http01_main_periodic)        |
| [knative.dev/net-istio](https://github.com/knative-sandbox/net-istio)                 | [![Releases](https://img.shields.io/github/release-pre/knative-sandbox/net-istio.svg?sort=semver)](https://github.com/knative-sandbox/net-istio/releases)                 | [![Releasability](https://github.com/knative-sandbox/net-istio/workflows/Releasability/badge.svg)](https://github.com/knative-sandbox/net-istio/actions/workflows/knative-releasability.yaml)         | [![Nightly](https://prow.knative.dev/badge.svg?jobs=nightly_net-istio_main_periodic)](https://prow.knative.dev?job=nightly_net-istio_main_periodic)         |
| [knative.dev/net-kourier](https://github.com/knative-sandbox/net-kourier)             | [![Releases](https://img.shields.io/github/release-pre/knative-sandbox/net-kourier.svg?sort=semver)](https://github.com/knative-sandbox/net-kourier/releases)             | [![Releasability](https://github.com/knative-sandbox/net-kourier/workflows/Releasability/badge.svg)](https://github.com/knative-sandbox/net-kourier/actions/workflows/knative-releasability.yaml)       | [![Nightly](https://prow.knative.dev/badge.svg?jobs=nightly_net-kourier_main_periodic)](https://prow.knative.dev?job=nightly_net-kourier_main_periodic)       |
| [knative.dev/net-gateway-api](https://github.com/knative-sandbox/net-gateway-api)             | [![Releases](https://img.shields.io/github/release-pre/knative-sandbox/net-gateway-api.svg?sort=semver)](https://github.com/knative-sandbox/net-gateway-api/releases)             | [![Releasability](https://github.com/knative-sandbox/net-gateway-api/workflows/Releasability/badge.svg)](https://github.com/knative-sandbox/net-gateway-api/actions/workflows/knative-releasability.yaml)       | [![Nightly](https://prow.knative.dev/badge.svg?jobs=nightly_net-gateway-api_main_periodic)](https://prow.knative.dev?job=nightly_net-gateway-api_main_periodic)       |
| [knative.dev/eventing](https://github.com/knative/eventing)                           | [![Releases](https://img.shields.io/github/release-pre/knative/eventing.svg?sort=semver)](https://github.com/knative/eventing/releases)                                   | [![Releasability](https://github.com/knative/eventing/workflows/Releasability/badge.svg)](https://github.com/knative/eventing/actions/workflows/knative-releasability.yaml)                  | [![Nightly](https://prow.knative.dev/badge.svg?jobs=nightly_eventing_main_periodic)](https://prow.knative.dev?job=nightly_eventing_main_periodic)                  |
| [knative.dev/sample-controller](https://github.com/knative-sandbox/sample-controller) | [![Releases](https://img.shields.io/github/release-pre/knative-sandbox/sample-controller.svg?sort=semver)](https://github.com/knative-sandbox/sample-controller/releases) | [![Releasability](https://github.com/knative-sandbox/sample-controller/workflows/Releasability/badge.svg)](https://github.com/knative-sandbox/sample-controller/actions/workflows/knative-releasability.yaml) | [![Nightly](https://prow.knative.dev/badge.svg?jobs=nightly_sample-controller_main_periodic)](https://prow.knative.dev?job=nightly_sample-controller_main_periodic) |

After **eventing**:

| Repo                                                                                          | Release                                                                                                                                                                           | Releasability                                                                                                | Nightly                                                                                                      |
| --------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------ |
| [knative.dev/eventing-ceph](https://github.com/knative-sandbox/eventing-ceph)                 | [![Releases](https://img.shields.io/github/release-pre/knative-sandbox/eventing-ceph.svg?sort=semver)](https://github.com/knative-sandbox/eventing-ceph/releases)                 | [![Releasability](https://github.com/knative-sandbox/eventing-ceph/workflows/Releasability/badge.svg)](https://github.com/knative-sandbox/eventing-ceph/actions/workflows/knative-releasability.yaml)         | [![Nightly](https://prow.knative.dev/badge.svg?jobs=nightly_eventing-ceph_main_periodic)](https://prow.knative.dev?job=nightly_eventing-ceph_main_periodic)         |
| [knative.dev/eventing-kogito](https://github.com/knative-sandbox/eventing-kogito) | [![Releases](https://img.shields.io/github/release-pre/knative-sandbox/eventing-kogito.svg?sort=semver)](https://github.com/knative-sandbox/eventing-kogito/releases) | [![Releasability](https://github.com/knative-sandbox/eventing-kogito/workflows/Releasability/badge.svg)](https://github.com/knative-sandbox/eventing-kogito/actions/workflows/knative-releasability.yaml) | [![Nightly](https://prow.knative.dev/badge.svg?jobs=nightly_eventing-kogito_main_periodic)](https://prow.knative.dev?job=nightly_eventing-kogito_main_periodic) |
| [knative.dev/eventing-natss](https://github.com/knative-sandbox/eventing-natss)               | [![Releases](https://img.shields.io/github/release-pre/knative-sandbox/eventing-natss.svg?sort=semver)](https://github.com/knative-sandbox/eventing-natss/releases)               | [![Releasability](https://github.com/knative-sandbox/eventing-natss/workflows/Releasability/badge.svg)](https://github.com/knative-sandbox/eventing-natss/actions/workflows/knative-releasability.yaml)        | [![Nightly](https://prow.knative.dev/badge.svg?jobs=nightly_eventing-natss_main_periodic)](https://prow.knative.dev?job=nightly_eventing-natss_main_periodic)        |
| [knative.dev/eventing-rabbitmq](https://github.com/knative-sandbox/eventing-rabbitmq)         | [![Releases](https://img.shields.io/github/release-pre/knative-sandbox/eventing-rabbitmq.svg?sort=semver)](https://github.com/knative-sandbox/eventing-rabbitmq/releases)         | [![Releasability](https://github.com/knative-sandbox/eventing-rabbitmq/workflows/Releasability/badge.svg)](https://github.com/knative-sandbox/eventing-rabbitmq/actions/workflows/knative-releasability.yaml)     | [![Nightly](https://prow.knative.dev/badge.svg?jobs=nightly_eventing-rabbitmq_main_periodic)](https://prow.knative.dev?job=nightly_eventing-rabbitmq_main_periodic)     |
| [knative.dev/sample-source](https://github.com/knative-sandbox/sample-source)                 | [![Releases](https://img.shields.io/github/release-pre/knative-sandbox/sample-source.svg?sort=semver)](https://github.com/knative-sandbox/sample-source/releases)                 | [![Releasability](https://github.com/knative-sandbox/sample-source/workflows/Releasability/badge.svg)](https://github.com/knative-sandbox/sample-source/actions/workflows/knative-releasability.yaml)         | [![Nightly](https://prow.knative.dev/badge.svg?jobs=nightly_sample-source_main_periodic)](https://prow.knative.dev?job=nightly_sample-source_main_periodic)         |

After both **eventing** and **serving**:

| Repo                                                                              | Release                                                                                                                                                               | Releasability                                                                                          | Nightly                                                                                                |
| --------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------ |
| [knative.dev/client](https://github.com/knative/client)     | [![Releases](https://img.shields.io/github/release-pre/knative/client.svg?sort=semver)](https://github.com/knative/client/releases)     | [![Releasability](https://github.com/knative/client/workflows/Releasability/badge.svg)](https://github.com/knative/client/actions/workflows/knative-releasability.yaml)   | [![Nightly](https://prow.knative.dev/badge.svg?jobs=nightly_client_main_periodic)](https://prow.knative.dev?job=nightly_client_main_periodic) |
| [knative.dev/eventing-kafka](https://github.com/knative-sandbox/eventing-kafka)               | [![Releases](https://img.shields.io/github/release-pre/knative-sandbox/eventing-kafka.svg?sort=semver)](https://github.com/knative-sandbox/eventing-kafka/releases)               | [![Releasability](https://github.com/knative-sandbox/eventing-kafka/workflows/Releasability/badge.svg)](https://github.com/knative-sandbox/eventing-kafka/actions/workflows/knative-releasability.yaml)        | [![Nightly](https://prow.knative.dev/badge.svg?jobs=nightly_eventing-kafka_main_periodic)](https://prow.knative.dev?job=nightly_eventing-kafka_main_periodic)        |
| [knative.dev/eventing-redis](https://github.com/knative-sandbox/eventing-redis)   | [![Releases](https://img.shields.io/github/release-pre/knative-sandbox/eventing-redis.svg?sort=semver)](https://github.com/knative-sandbox/eventing-redis/releases)   | [![Releasability](https://github.com/knative-sandbox/eventing-redis/workflows/Releasability/badge.svg)](https://github.com/knative-sandbox/eventing-redis/actions/workflows/knative-releasability.yaml)  | [![Nightly](https://prow.knative.dev/badge.svg?jobs=nightly_eventing-redis_main_periodic)](https://prow.knative.dev?job=nightly_eventing-redis_main_periodic)  |
| [knative.dev/eventing-github](https://github.com/knative-sandbox/eventing-github) | [![Releases](https://img.shields.io/github/release-pre/knative-sandbox/eventing-github.svg?sort=semver)](https://github.com/knative-sandbox/eventing-github/releases) | [![Releasability](https://github.com/knative-sandbox/eventing-github/workflows/Releasability/badge.svg)](https://github.com/knative-sandbox/eventing-github/actions/workflows/knative-releasability.yaml) | [![Nightly](https://prow.knative.dev/badge.svg?jobs=nightly_eventing-github_main_periodic)](https://prow.knative.dev?job=nightly_eventing-github_main_periodic) |
| [knative.dev/eventing-gitlab](https://github.com/knative-sandbox/eventing-gitlab) | [![Releases](https://img.shields.io/github/release-pre/knative-sandbox/eventing-gitlab.svg?sort=semver)](https://github.com/knative-sandbox/eventing-gitlab/releases) | [![Releasability](https://github.com/knative-sandbox/eventing-gitlab/workflows/Releasability/badge.svg)](https://github.com/knative-sandbox/eventing-gitlab/actions/workflows/knative-releasability.yaml) | [![Nightly](https://prow.knative.dev/badge.svg?jobs=nightly_eventing-gitlab_main_periodic)](https://prow.knative.dev?job=nightly_eventing-gitlab_main_periodic) |

Lastly:

| Repo                                                                                                | Release                                                                                                                                                                                 | Releasability                                                                                                   | Nightly                                                                                                         |
| --------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------- |
| [knative.dev/eventing-kafka-broker](https://github.com/knative-sandbox/eventing-kafka-broker) | [![Releases](https://img.shields.io/github/release-pre/knative-sandbox/eventing-kafka-broker.svg?sort=semver)](https://github.com/knative-sandbox/eventing-kafka-broker/releases) | [![Releasability](https://github.com/knative-sandbox/eventing-kafka-broker/workflows/Releasability/badge.svg)](https://github.com/knative-sandbox/eventing-kafka-broker/actions/workflows/knative-releasability.yaml) | [![Nightly](https://prow.knative.dev/badge.svg?jobs=nightly_eventing-kafka-broker_main_periodic)](https://prow.knative.dev?job=nightly_eventing-kafka-broker_main_periodic) |
| [knative.dev/eventing-autoscaler-keda](https://github.com/knative-sandbox/eventing-autoscaler-keda) | [![Releases](https://img.shields.io/github/release-pre/knative-sandbox/eventing-autoscaler-keda.svg?sort=semver)](https://github.com/knative-sandbox/eventing-autoscaler-keda/releases) | [![Releasability](https://github.com/knative-sandbox/eventing-autoscaler-keda/workflows/Releasability/badge.svg)](https://github.com/knative-sandbox/eventing-autoscaler-keda/actions/workflows/knative-releasability.yaml) | [![Nightly](https://prow.knative.dev/badge.svg?jobs=nightly_eventing-autoscaler-keda_main_periodic)](https://prow.knative.dev?job=nightly_eventing-autoscaler-keda_main_periodic) |
| [knative.dev/kn-plugin-admin](https://github.com/knative-sandbox/kn-plugin-admin) | [![Releases](https://img.shields.io/github/release-pre/knative-sandbox/kn-plugin-admin.svg?sort=semver)](https://github.com/knative-sandbox/kn-plugin-admin/releases) | [![Releasability](https://github.com/knative-sandbox/kn-plugin-admin/workflows/Releasability/badge.svg)](https://github.com/knative-sandbox/kn-plugin-admin/actions/workflows/knative-releasability.yaml) | [![Nightly](https://prow.knative.dev/badge.svg?jobs=nightly_kn-plugin-admin_main_periodic)](https://prow.knative.dev?job=nightly_kn-plugin-admin_main_periodic) |
| [knative.dev/kn-plugin-event](https://github.com/knative-sandbox/kn-plugin-event) | [![Releases](https://img.shields.io/github/release-pre/knative-sandbox/kn-plugin-event.svg?sort=semver)](https://github.com/knative-sandbox/kn-plugin-event/releases) | [![Releasability](https://github.com/knative-sandbox/kn-plugin-event/workflows/Releasability/badge.svg)](https://github.com/knative-sandbox/kn-plugin-event/actions/workflows/knative-releasability.yaml) | [![Nightly](https://prow.knative.dev/badge.svg?jobs=nightly_kn-plugin-event_main_periodic)](https://prow.knative.dev?job=nightly_kn-plugin-event_main_periodic) |
| [knative.dev/kn-plugin-source-kafka](https://github.com/knative-sandbox/kn-plugin-source-kafka) | [![Releases](https://img.shields.io/github/release-pre/knative-sandbox/kn-plugin-source-kafka.svg?sort=semver)](https://github.com/knative-sandbox/kn-plugin-source-kafka/releases) | [![Releasability](https://github.com/knative-sandbox/kn-plugin-source-kafka/workflows/Releasability/badge.svg)](https://github.com/knative-sandbox/kn-plugin-source-kafka/actions/workflows/knative-releasability.yaml) | [![Nightly](https://prow.knative.dev/badge.svg?jobs=nightly_kn-plugin-source-kafka_main_periodic)](https://prow.knative.dev?job=nightly_kn-plugin-source-kafka_main_periodic) |
| [knative.dev/kn-plugin-source-kamelet](https://github.com/knative-sandbox/kn-plugin-source-kamelet) | [![Releases](https://img.shields.io/github/release-pre/knative-sandbox/kn-plugin-source-kamelet.svg?sort=semver)](https://github.com/knative-sandbox/kn-plugin-source-kamelet/releases) | [![Releasability](https://github.com/knative-sandbox/kn-plugin-source-kamelet/workflows/Releasability/badge.svg)](https://github.com/knative-sandbox/kn-plugin-source-kamelet/actions/workflows/knative-releasability.yaml) | [![Nightly](https://prow.knative.dev/badge.svg?jobs=nightly_kn-plugin-source-kamelet_main_periodic)](https://prow.knative.dev?job=nightly_kn-plugin-source-kamelet_main_periodic) |
| [knative.dev/kn-plugin-quickstart](https://github.com/knative-sandbox/kn-plugin-quickstart) | [![Releases](https://img.shields.io/github/release-pre/knative-sandbox/kn-plugin-quickstart.svg?sort=semver)](https://github.com/knative-sandbox/kn-plugin-quickstart/releases) | [![Releasability](https://github.com/knative-sandbox/kn-plugin-quickstart/workflows/Releasability/badge.svg)](https://github.com/knative-sandbox/kn-plugin-quickstart/actions/workflows/knative-releasability.yaml) | [![Nightly](https://prow.knative.dev/badge.svg?jobs=nightly_kn-plugin-quickstart_main_periodic)](https://prow.knative.dev?job=nightly_kn-plugin-quickstart_main_periodic) |

We have a few repos inside of Knative that are not handled in the standard
process at the moment. They might have additional dependencies or depend on the
releases existing. **Skip these**. Special cases are:

| Repo                                                        | Release                                                                                                                                 | Releasability                                                                           | Nightly                                                                               |
| ----------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------- |
| [knative.dev/operator](https://github.com/knative/operator) | [![Releases](https://img.shields.io/github/release-pre/knative/operator.svg?sort=semver)](https://github.com/knative/operator/releases) | [![Releasability](https://github.com/knative/operator/workflows/Releasability/badge.svg)](https://github.com/knative/operator/actions/workflows/knative-releasability.yaml) | [![Nightly](https://prow.knative.dev/badge.svg?jobs=nightly_operator_main_periodic)](https://prow.knative.dev?job=nightly_operator_main_periodic) |
| [knative.dev/docs](https://github.com/knative/docs)       | N/A      | N/A    | N/A                                                                                   |

## Post-release work

### Homebrew updates

#### homebrew-client

After the client release, the [Homebrew tap](https://github.com/knative/homebrew-client) needs to be updated with the new release:

* Copy `kn.rb` to the `kn@${PREV_RELEASE}.rb` with `$PREV_RELEASE` to be replace with the latest release (e.g. `0.19`).
* In `kn@${PREV_RELEASE}.rb` replace `class Kn` with `class KnAT${PREV_RELEASE_DIGITS}`, e.g `class KnAT019` for an previous release `0.19`.
* In `kn.rb`
  - Replace the old version number in `v` with the released version (e.g. `v = "v0.20.0"`)
  - Replace the `sha256` checksums with the values from the [client release page](https://github.com/knative/client/releases). The checksums have been released, too (e.g. [checksums.txt](https://github.com/knative/client/releases/download/v0.22.0/checksums.txt))

Create a PR and merge the changes. Prow is not enabled for the homebrew repo, so the merge needs to be performed manually.

#### homebrew-kn-plugins

Similar to the client repo, the [client plugin's Homebrew repo](https://github.com/knative-sandbox/homebrew-kn-plugins) needs to be updated
for the the plugins supported after their repos have successfully created a release.

Currently the following plugins are available with their own formulas:

* [kn-plugin-admin](https://github.com/knative-sandbox/kn-plugin-admin) is managed via the `admin.rb` formula
* [kn-plugin-source-kafka](https://github.com/knative-sandbox/kn-plugin-source-kafka) is managed via `source-kafka.rb` formula
* [kn-plugin-source-kamelet](https://github.com/knative-sandbox/kn-plugin-source-kamelet) is managed via `source-kamelet.rb` formula
* [kn-plugin-quickstart](https://github.com/knative-sandbox/kn-plugin-quickstart/) is managed via `quickstart.rb` formula

The artifact checksums can be found on the respective release pages. Once the
PR is merged, [cut a new branch](#cut-the-branch). There is no automation after
this, so you're done here.

### Final checks & transition to the next release leads

1. Add the release to the [release table](https://github.com/knative/community/blob/main/mechanics/RELEASE-SCHEDULE.md)

1. Watch for the PR like [this one](https://github.com/knative/test-infra/pull/2670)
to enable dot releases on the new releases and approve it. These are create by the Prow
https://prow.knative.dev/?job=ci-knative-prow-jobs-syncer

1. Send a PR like [this one](https://github.com/knative/community/pull/619) to
grant ACLs for the next release leads, and to remove yourself from the rotation.
Include the next release leads in the PR as a reminder.

1. Send a PR like [this one](https://github.com/knative-sandbox/knobots/pull/152/files) to
bump knobots auto release workflow to the next release.

