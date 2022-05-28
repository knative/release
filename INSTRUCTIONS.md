# Instructions for how to cut a Knative release

We release the components of [Knative every 6 weeks](README.md#release-schedule).

Each component needs to be updated to use the latest version of all shared dependencies before being released. The instructions and checklists in this document will help ensure all operations are completed and done in the proper order.

- [Instructions for how to cut a Knative release](#instructions-for-how-to-cut-a-knative-release)
  - [Release prep checklists](#release-prep-checklists)
    - [First week of release rotation](#first-week-of-release-rotation)
    - [14 days prior to release](#14-days-prior-to-release)
    - [7 days prior - first batch of repos](#7-days-prior---first-batch-of-repos)
    - [1 day prior to release](#1-day-prior-to-release)
  - [Day of the release](#day-of-the-release)
    - [Second batch of repos](#second-batch-of-repos)
    - [Third batch of repos](#third-batch-of-repos)
    - [Fourth batch of repos](#fourth-batch-of-repos)
    - [Last batch of repos](#last-batch-of-repos)
  - [Post-release checklists](#post-release-checklists)
  - [Release procedures](#release-procedures)
    - [Notes](#notes)
    - [Sequence of operations](#sequence-of-operations)
    - [Releasability check](#releasability-check)
    - [Build health](#build-health)
    - [Dependency check](#dependency-check)
    - [Cutting a branch](#cutting-a-branch)
      - [Exceptions](#exceptions)
      - [How to cut a branch](#how-to-cut-a-branch)
      - [Cutting a branch for supporting repos](#cutting-a-branch-for-supporting-repos)
      - [What could go wrong?](#what-could-go-wrong)
    - [Automation check](#automation-check)
      - [Release job](#release-job)
      - [Nightly job](#nightly-job)
    - [Release notes](#release-notes)
  - [Administrative work](#administrative-work)
    - [Permissions for release leads](#permissions-for-release-leads)
    - [Creating a release Slack channel](#creating-a-release-slack-channel)
  - [List of all repos to release](#list-of-all-repos-to-release)
    - [First batch, supporting repos](#first-batch-supporting-repos)
    - [Second batch repos](#second-batch-repos)
    - [Third batch repos](#third-batch-repos)
    - [Fourth batch repos](#fourth-batch-repos)
    - [Last batch repos](#last-batch-repos)
    - [Special repos](#special-repos)

## Release prep checklists
### First week of release rotation
| Checklist      | Repos |
| ----------- | ----------- |
| [checklist](https://github.com/knative/release/issues/new?assignees=knative/knative-release-leads&template=1-release-first-week-rotation.yaml)  |  |

### 14 days prior to release
| Checklist      | Repos |
| ----------- | ----------- |
| [checklist](https://github.com/knative/release/issues/new?assignees=knative/knative-release-leads&template=2-release-14-days-prior-checklist.yaml)  |  |

### 7 days prior - first batch of repos
| Checklist      | Repos |
| ----------- | ----------- |
| [checklist](https://github.com/knative/release/issues/new?assignees=knative/knative-release-leads&template=3-release-7-days-prior-checklist.yaml)  | [repos](#first-batch-supporting-repos)  |

### 1 day prior to release
| Checklist      | Repos |
| ----------- | ----------- |
| [checklist](https://github.com/knative/release/issues/new?assignees=knative/knative-release-leads&template=4-release-1-day-prior-checklist.yaml) |  |

## Day of the release
The release starts on the first day of the [release schedule](README.md#release-schedule).

🚨 **NOTE:** It is not required that all repos in the included sub-sections be released on the same day the release is scheduled to start. The pipeline outlined below will take time to complete and it is ok for the release to take days. The scheduled release date indicates the beginning of this process.

### Second batch of repos
| Checklist      | Repos |
| ----------- | ----------- |
| [checklist](https://github.com/knative/release/issues/new?assignees=knative/knative-release-leads&template=3-release-7-days-prior-first-batch-checklist.yaml) | [repos](#second-batch-repos) |

### Third batch of repos
| Checklist      | Repos |
| ----------- | ----------- |
| [checklist](https://github.com/knative/release/issues/new?assignees=knative/knative-release-leads&template=6-release-third-batch-checklist.yaml) | [repos](#third-batch-repos) |

### Fourth batch of repos
| Checklist      | Repos |
| ----------- | ----------- |
| [checklist](https://github.com/knative/release/issues/new?assignees=knative/knative-release-leads&template=7-release-fourth-batch-checklist.yaml) | [repos](#fourth-batch-repos) |

### Last batch of repos
| Checklist      | Repos |
| ----------- | ----------- |
| [checklist](https://github.com/knative/release/issues/new?assignees=knative/knative-release-leads&template=8-release-last-batch-checklist.yaml) | [repos](#last-batch-repos) |

## Post-release checklists

<!-- ### Homebrew updates

#### homebrew-client -->

After the client release, the [Homebrew tap](https://github.com/knative/homebrew-client) needs to be updated with the new release:

* Copy `kn.rb` to the `kn@${PREV_RELEASE}.rb` with `$PREV_RELEASE` to be replace with the latest release (e.g. `0.19`).
* In `kn@${PREV_RELEASE}.rb` replace `class Kn` with `class KnAT${PREV_RELEASE_DIGITS}`, e.g `class KnAT019` for an previous release `0.19`.
* In `kn.rb`
  - Replace the old version number in `v` with the released version (e.g. `v = "v0.20.0"`)
  - Replace the `sha256` checksums with the values from the [client release page](https://github.com/knative/client/releases). The checksums have been released, too (e.g. [checksums.txt](https://github.com/knative/client/releases/download/v0.22.0/checksums.txt))

Open a PR and merge the changes. Prow is not enabled for the homebrew repo, so the merge needs to be performed manually.

<!-- #### homebrew-kn-plugins -->

Similar to the client repo, the [client plugin's Homebrew repo](https://github.com/knative-sandbox/homebrew-kn-plugins) needs to be updated
for the the plugins supported after their repos have successfully created a release.

Currently the following plugins are available with their own formulas:

* [kn-plugin-admin](https://github.com/knative-sandbox/kn-plugin-admin) is managed via the `admin.rb` formula
* [kn-plugin-source-kafka](https://github.com/knative-sandbox/kn-plugin-source-kafka) is managed via `source-kafka.rb` formula
* [kn-plugin-source-kamelet](https://github.com/knative-sandbox/kn-plugin-source-kamelet) is managed via `source-kamelet.rb` formula
* [kn-plugin-quickstart](https://github.com/knative-sandbox/kn-plugin-quickstart/) is managed via `quickstart.rb` formula
* [kn-plugin-event](https://github.com/knative-sandbox/kn-plugin-event) is managed via `event.rb` formula

<!-- ### Update release schedule -->

We maintain a list of current (and future) releases in the [Community repo](https://github.com/knative/community/blob/main/mechanics/RELEASE-SCHEDULE.md). When a new release goes out, an older one will almost always fall out of support. We should update the release schedule accordingly by opening a PR against the community repo. See [here](https://github.com/knative/community/pull/991/files) for an example.

<!-- ### Communication -->

Announce the release in Knative Slack on the #general and #operations channels.

---

## Release procedures
### Notes
We have a few repos inside of Knative that are not handled in the standard
process at the moment. They might have additional dependencies or depend on the
releases existing. These [special repos are to be excluded](#special-repos) from the release process.

### Sequence of operations
For each repo, do:
  - [dependency check](#dependency-check)
  - [releasability check](#releasability-check)
  - [automation check](#automation-check)
  - [release notes](#release-notes)


for which repository extra steps needs to be performed.
- Cutting a new branch starting from main for the release (e.g.
  `release-0.20`)
- Execute the job on Prow that builds the code from the release branch, tags the
  revision, publishes the images, publishes the yaml artifacts and generates the
  Github release.

Most of the above steps are automated, although in some situations it might be
necessary to perform some of them manually.

### Releasability check
At this point, you can proceed with the releasability check. A releasability
check is executed periodically and posts the result on the Slack release channel
and it fails if the dependencies are not properly aligned. If you don't want to
wait, you can manually execute the
[Releasability workflow](https://github.com/knative/serving/actions?query=workflow%3AReleasability).

If the releasability reports NO-GO, probably there is some deps misalignment,
hence you need to go back to the previous step and check the dependencies,
otherwise, you're ready to proceed.

If there are changes, then it's NO-GO, otherwise it's GO.

**NOTE:** The releasability check will not work on dot releases and there is a potential for false positives.

1) Bump the release version in the source [knative-releasability.yaml](https://github.com/knative-sandbox/knobots/blob/main/workflow-templates/knative-releasability.yaml) file. to this release version by opening a PR. [Example PR](https://github.com/knative-sandbox/knobots/pull/170).

These changes will be propagated to the rest of Knative in the next round of
workflow syncs.

1) Check that it has indeed propagated and if not the sync will have to manually triggered.

### Build health
Check the build on main passes

Before beginning, check if the repository is in a good shape and the builds pass
consistently. **This is required** because the Prow job that builds the release
artifacts will execute all the various tests (build, unit, e2e) and, if
something goes wrong, you will probably need to restart this process from the
beginning.

For any problems in a specific repo, get in touch with the relevant WG leads to
fix them.

### Dependency check
Aligning the dependencies

In general the release dependency order is something like the following (as of
v0.20). Note: `buoy check` will fail if the dependencies are not yet ready.

- Aligning the `knative.dev` dependencies to the other release versions on
  main (except hack, which has no dependencies)

In order to align the `knative.dev` dependencies, knobots will perform PRs like
[this](https://github.com/knative/eventing/pull/4713) for each repo, executing
the command `./hack/update-deps.sh --upgrade --release 0.20` and committing all
the content.

- If no dependency bump PR is available, manually trigger the generation of these PRs starting the
  [Knobots Auto Update Deps](https://github.com/knative-sandbox/knobots/actions/workflows/auto-update-deps.yaml)
  and wait for the PR to pop in the repo you need. Note you have to change the
  field `If true, send update PRs even for deps changes that don't change vendor.
  Use this only for releases.` to true, because in some cases there no code changes in the vendor.
- Check the `go.mod` to ensure hashes point to commit hash at the head of the release branch of the dependency repo
  - For the _support_ repos (`hack`, `pkg`, etc) you should see the
  dependency version pointing at a revision which should match the `HEAD` of the
  release branch. E.g. `knative.dev/pkg v0.0.0-20210112143930-acbf2af596cf`
  points at the revision `acbf2af596cf`, which is the `HEAD` of the
  `release-0.20` branch in `pkg` repo.
  - For the _release_ repos, you should see the dependency version pointing at the
  version tag. E.g. `knative.dev/eventing v0.20.0` points at the tag `v0.20.0`
  in the `eventing` repo.


**Note**: Make sure to wait for the Eventing release to be published before updating the dependnecies for the next batch of repos. This will make the dependency in go.mod look like `knative.dev/eventing v0.31.0` instead of `knative.dev/eventing v0.30.1-0.20220419135228-39eef14419d8`.

### Cutting a branch

#### Exceptions

For some repositories some extra manual validation and updates need to be performed before the release branch is cut.

- knative/client
  - (optional) Check that [CHANGELOG.adoc](https://github.com/knative/client/blob/main/CHANGELOG.adoc) contains a section about the release, i.e. the top-level "(Unreleased)" section should be changed to point to the upcoming release version and number. It's not critical if the changelog is aligned after the release in retrospective.

  - If the validation fails, the fix should be trivial and could be either performed by the release leads or the client team.

- knative-sandbox/kn-plugin-quickstart
  - Update the version numbers of Serving / Kourier / Eventing in [pkg/install/install.go](https://github.com/knative-sandbox/kn-plugin-quickstart/blob/main/pkg/install/install.go#L25-L27) so that the plugin will use the just-released versions.

#### How to cut a branch
Now you're ready to cut the `release-x.y` branch. This can be done by using
the GitHub UI:

1. Click on the branch selection box at the top level page of the repository.

   ![Click the branch selection box](images/github-branch.png)

2. Search for the correct `release-x.y` branch name for the release.

   ![Search for the expected release branch name](images/github-branch-search.png)

3. Click "Create branch: release-x.y".

   ![Click create branch: release-x.y](images/github-branch-create.png)

Otherwise, you can do it by hand on your local machine.


#### Cutting a branch for supporting repos
<!-- ### 1. Cut release branches of supporting repos -->

- Step 1) todo fixme

The supporting repos are the base repos where we have common code and common
scripts. For these repos (except **hack**), we follow the same release process as
explained in [release a repository](#release-a-repository), but no prow job is
executed, hence no git tag and Github release are produced.

🚨 **NOTE:** The supporting repos must be released in the correct order, so you need to check if
the [dependencies should be updated](#aligning-the-dependencies) after each repo release.

First repo that needs to be released is **hack**. As mentioned, **hack** is
special because it has no dependencies and hence there's no releasability
checks, just ensure there are no outstanding PRs and
[cut a release branch](#cut-the-branch).

- [knative/hack](https://github.com/knative/hack)

After **hack** release branch has been cut, follow the
[release a repository](#release-a-repository) guide for the following repos
skipping the prow job part:

#### What could go wrong?

In case you cut a branch before it was ready (e.g. some deps misalignment, a
failing test, etc), then follow the steps below:

1. Mark the broken release as a `pre-release`
1. Create a dot release by waiting until the job triggers (once a week on Tue) or [on demand](https://github.com/knative/test-infra/blob/main/guides/manual_release.md#creating-a-dot-release-on-demand).
1. Repeat the steps for a release for the new dot release



### Automation check
#### Release job
The Prow job
- Wait for [release automation](#the-prow-job) to kick in (runs on a 2 hour
interval).

- Once the release automation passed, it will create a release tag in
the repository.

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

#### Nightly job
 Verify nightly release automation is intact

The automation used to cut the actual releases is the very same as the
automation used to cut nightly releases. Verify via testgrid that all relevant
nightly releases are passing. If they are not coordinate with the relevant WG
leads to fix them.

### Release notes
- Enhance the respective tags with the collected release-notes
using the GitHub UI.

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

## Administrative work
### Permissions for release leads
During a release, the release leads for that cycle need to be given all the permissions to perform the tasks needed for a release. Likewise, permissions for leads from the previous release cycle need to be revoked.

Adding and removing the leads can be done in at the same time, or in a two-step process:

- check if the new leads are included in these two files in the `Knative Release Leads` section:
  - [knative/community/main/peribolos/knative.yaml#Knative Release Leads](https://github.com/knative/community/blob/e635686d46366906af861c409978c2c55990a10e/peribolos/knative.yaml#L878)
  - [knative/community/main/peribolos/knative-sandbox.yaml#Knative Release Leads](https://github.com/knative/community/blob/e635686d46366906af861c409978c2c55990a10e/peribolos/knative-sandbox.yaml#L739)
  - if not, open a PR like [this one](https://github.com/knative/community/pull/209) to grant permissions.
  - be sure to run `/hack/update-codegen.sh` so leads are added to the OWNERS files as well.
- ensure the leads from the prior release are removed; can be done in the same PR, or separately.

### Creating a release Slack channel

Ask someone from the TOC to create a **release-`#`** Slack channel that will be used to help manage this release.

## List of all repos to release
### First batch, supporting repos

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
**eventing**, etc) to become "releasable" by the end of the week.
This is signaled via the Slack report of releasability posted to the **release-`#`**
channel every morning (5am PST, M-F).

### Second batch repos
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


### Third batch repos
| Repo                                                                                          | Release                                                                                                                                                                           | Releasability                                                                                                | Nightly                                                                                                      |
| --------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------ |
| [knative.dev/eventing-ceph](https://github.com/knative-sandbox/eventing-ceph)                 | [![Releases](https://img.shields.io/github/release-pre/knative-sandbox/eventing-ceph.svg?sort=semver)](https://github.com/knative-sandbox/eventing-ceph/releases)                 | [![Releasability](https://github.com/knative-sandbox/eventing-ceph/workflows/Releasability/badge.svg)](https://github.com/knative-sandbox/eventing-ceph/actions/workflows/knative-releasability.yaml)         | [![Nightly](https://prow.knative.dev/badge.svg?jobs=nightly_eventing-ceph_main_periodic)](https://prow.knative.dev?job=nightly_eventing-ceph_main_periodic)         |
| [knative.dev/eventing-kogito](https://github.com/knative-sandbox/eventing-kogito) | [![Releases](https://img.shields.io/github/release-pre/knative-sandbox/eventing-kogito.svg?sort=semver)](https://github.com/knative-sandbox/eventing-kogito/releases) | [![Releasability](https://github.com/knative-sandbox/eventing-kogito/workflows/Releasability/badge.svg)](https://github.com/knative-sandbox/eventing-kogito/actions/workflows/knative-releasability.yaml) | [![Nightly](https://prow.knative.dev/badge.svg?jobs=nightly_eventing-kogito_main_periodic)](https://prow.knative.dev?job=nightly_eventing-kogito_main_periodic) |
| [knative.dev/eventing-rabbitmq](https://github.com/knative-sandbox/eventing-rabbitmq)         | [![Releases](https://img.shields.io/github/release-pre/knative-sandbox/eventing-rabbitmq.svg?sort=semver)](https://github.com/knative-sandbox/eventing-rabbitmq/releases)         | [![Releasability](https://github.com/knative-sandbox/eventing-rabbitmq/workflows/Releasability/badge.svg)](https://github.com/knative-sandbox/eventing-rabbitmq/actions/workflows/knative-releasability.yaml)     | [![Nightly](https://prow.knative.dev/badge.svg?jobs=nightly_eventing-rabbitmq_main_periodic)](https://prow.knative.dev?job=nightly_eventing-rabbitmq_main_periodic)     |
| [knative.dev/sample-source](https://github.com/knative-sandbox/sample-source)                 | [![Releases](https://img.shields.io/github/release-pre/knative-sandbox/sample-source.svg?sort=semver)](https://github.com/knative-sandbox/sample-source/releases)                 | [![Releasability](https://github.com/knative-sandbox/sample-source/workflows/Releasability/badge.svg)](https://github.com/knative-sandbox/sample-source/actions/workflows/knative-releasability.yaml)         | [![Nightly](https://prow.knative.dev/badge.svg?jobs=nightly_sample-source_main_periodic)](https://prow.knative.dev?job=nightly_sample-source_main_periodic)         |

### Fourth batch repos

| Repo                                                                              | Release                                                                                                                                                               | Releasability                                                                                          | Nightly                                                                                                |
| --------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------ |
| [knative.dev/client](https://github.com/knative/client)     | [![Releases](https://img.shields.io/github/release-pre/knative/client.svg?sort=semver)](https://github.com/knative/client/releases)     | [![Releasability](https://github.com/knative/client/workflows/Releasability/badge.svg)](https://github.com/knative/client/actions/workflows/knative-releasability.yaml)   | [![Nightly](https://prow.knative.dev/badge.svg?jobs=nightly_client_main_periodic)](https://prow.knative.dev?job=nightly_client_main_periodic) |
| [knative.dev/eventing-kafka](https://github.com/knative-sandbox/eventing-kafka)               | [![Releases](https://img.shields.io/github/release-pre/knative-sandbox/eventing-kafka.svg?sort=semver)](https://github.com/knative-sandbox/eventing-kafka/releases)               | [![Releasability](https://github.com/knative-sandbox/eventing-kafka/workflows/Releasability/badge.svg)](https://github.com/knative-sandbox/eventing-kafka/actions/workflows/knative-releasability.yaml)        | [![Nightly](https://prow.knative.dev/badge.svg?jobs=nightly_eventing-kafka_main_periodic)](https://prow.knative.dev?job=nightly_eventing-kafka_main_periodic)        |
| [knative.dev/eventing-redis](https://github.com/knative-sandbox/eventing-redis)   | [![Releases](https://img.shields.io/github/release-pre/knative-sandbox/eventing-redis.svg?sort=semver)](https://github.com/knative-sandbox/eventing-redis/releases)   | [![Releasability](https://github.com/knative-sandbox/eventing-redis/workflows/Releasability/badge.svg)](https://github.com/knative-sandbox/eventing-redis/actions/workflows/knative-releasability.yaml)  | [![Nightly](https://prow.knative.dev/badge.svg?jobs=nightly_eventing-redis_main_periodic)](https://prow.knative.dev?job=nightly_eventing-redis_main_periodic)  |
| [knative.dev/eventing-github](https://github.com/knative-sandbox/eventing-github) | [![Releases](https://img.shields.io/github/release-pre/knative-sandbox/eventing-github.svg?sort=semver)](https://github.com/knative-sandbox/eventing-github/releases) | [![Releasability](https://github.com/knative-sandbox/eventing-github/workflows/Releasability/badge.svg)](https://github.com/knative-sandbox/eventing-github/actions/workflows/knative-releasability.yaml) | [![Nightly](https://prow.knative.dev/badge.svg?jobs=nightly_eventing-github_main_periodic)](https://prow.knative.dev?job=nightly_eventing-github_main_periodic) |
| [knative.dev/eventing-gitlab](https://github.com/knative-sandbox/eventing-gitlab) | [![Releases](https://img.shields.io/github/release-pre/knative-sandbox/eventing-gitlab.svg?sort=semver)](https://github.com/knative-sandbox/eventing-gitlab/releases) | [![Releasability](https://github.com/knative-sandbox/eventing-gitlab/workflows/Releasability/badge.svg)](https://github.com/knative-sandbox/eventing-gitlab/actions/workflows/knative-releasability.yaml) | [![Nightly](https://prow.knative.dev/badge.svg?jobs=nightly_eventing-gitlab_main_periodic)](https://prow.knative.dev?job=nightly_eventing-gitlab_main_periodic) |

### Last batch repos

| Repo                                                                                                | Release                                                                                                                                                                                 | Releasability                                                                                                   | Nightly                                                                                                         |
| --------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------- |
| [knative.dev/eventing-kafka-broker](https://github.com/knative-sandbox/eventing-kafka-broker) | [![Releases](https://img.shields.io/github/release-pre/knative-sandbox/eventing-kafka-broker.svg?sort=semver)](https://github.com/knative-sandbox/eventing-kafka-broker/releases) | [![Releasability](https://github.com/knative-sandbox/eventing-kafka-broker/workflows/Releasability/badge.svg)](https://github.com/knative-sandbox/eventing-kafka-broker/actions/workflows/knative-releasability.yaml) | [![Nightly](https://prow.knative.dev/badge.svg?jobs=nightly_eventing-kafka-broker_main_periodic)](https://prow.knative.dev?job=nightly_eventing-kafka-broker_main_periodic) |
| [knative.dev/eventing-autoscaler-keda](https://github.com/knative-sandbox/eventing-autoscaler-keda) | [![Releases](https://img.shields.io/github/release-pre/knative-sandbox/eventing-autoscaler-keda.svg?sort=semver)](https://github.com/knative-sandbox/eventing-autoscaler-keda/releases) | [![Releasability](https://github.com/knative-sandbox/eventing-autoscaler-keda/workflows/Releasability/badge.svg)](https://github.com/knative-sandbox/eventing-autoscaler-keda/actions/workflows/knative-releasability.yaml) | [![Nightly](https://prow.knative.dev/badge.svg?jobs=nightly_eventing-autoscaler-keda_main_periodic)](https://prow.knative.dev?job=nightly_eventing-autoscaler-keda_main_periodic) |
| [knative.dev/kn-plugin-admin](https://github.com/knative-sandbox/kn-plugin-admin) | [![Releases](https://img.shields.io/github/release-pre/knative-sandbox/kn-plugin-admin.svg?sort=semver)](https://github.com/knative-sandbox/kn-plugin-admin/releases) | [![Releasability](https://github.com/knative-sandbox/kn-plugin-admin/workflows/Releasability/badge.svg)](https://github.com/knative-sandbox/kn-plugin-admin/actions/workflows/knative-releasability.yaml) | [![Nightly](https://prow.knative.dev/badge.svg?jobs=nightly_kn-plugin-admin_main_periodic)](https://prow.knative.dev?job=nightly_kn-plugin-admin_main_periodic) |
| [knative.dev/kn-plugin-event](https://github.com/knative-sandbox/kn-plugin-event) | [![Releases](https://img.shields.io/github/release-pre/knative-sandbox/kn-plugin-event.svg?sort=semver)](https://github.com/knative-sandbox/kn-plugin-event/releases) | [![Releasability](https://github.com/knative-sandbox/kn-plugin-event/workflows/Releasability/badge.svg)](https://github.com/knative-sandbox/kn-plugin-event/actions/workflows/knative-releasability.yaml) | [![Nightly](https://prow.knative.dev/badge.svg?jobs=nightly_kn-plugin-event_main_periodic)](https://prow.knative.dev?job=nightly_kn-plugin-event_main_periodic) |
| [knative.dev/kn-plugin-source-kafka](https://github.com/knative-sandbox/kn-plugin-source-kafka) | [![Releases](https://img.shields.io/github/release-pre/knative-sandbox/kn-plugin-source-kafka.svg?sort=semver)](https://github.com/knative-sandbox/kn-plugin-source-kafka/releases) | [![Releasability](https://github.com/knative-sandbox/kn-plugin-source-kafka/workflows/Releasability/badge.svg)](https://github.com/knative-sandbox/kn-plugin-source-kafka/actions/workflows/knative-releasability.yaml) | [![Nightly](https://prow.knative.dev/badge.svg?jobs=nightly_kn-plugin-source-kafka_main_periodic)](https://prow.knative.dev?job=nightly_kn-plugin-source-kafka_main_periodic) |
| [knative.dev/kn-plugin-source-kamelet](https://github.com/knative-sandbox/kn-plugin-source-kamelet) | [![Releases](https://img.shields.io/github/release-pre/knative-sandbox/kn-plugin-source-kamelet.svg?sort=semver)](https://github.com/knative-sandbox/kn-plugin-source-kamelet/releases) | [![Releasability](https://github.com/knative-sandbox/kn-plugin-source-kamelet/workflows/Releasability/badge.svg)](https://github.com/knative-sandbox/kn-plugin-source-kamelet/actions/workflows/knative-releasability.yaml) | [![Nightly](https://prow.knative.dev/badge.svg?jobs=nightly_kn-plugin-source-kamelet_main_periodic)](https://prow.knative.dev?job=nightly_kn-plugin-source-kamelet_main_periodic) |
| [knative.dev/kn-plugin-quickstart](https://github.com/knative-sandbox/kn-plugin-quickstart) | [![Releases](https://img.shields.io/github/release-pre/knative-sandbox/kn-plugin-quickstart.svg?sort=semver)](https://github.com/knative-sandbox/kn-plugin-quickstart/releases) | [![Releasability](https://github.com/knative-sandbox/kn-plugin-quickstart/workflows/Releasability/badge.svg)](https://github.com/knative-sandbox/kn-plugin-quickstart/actions/workflows/knative-releasability.yaml) | [![Nightly](https://prow.knative.dev/badge.svg?jobs=nightly_kn-plugin-quickstart_main_periodic)](https://prow.knative.dev?job=nightly_kn-plugin-quickstart_main_periodic) |

### Special repos
| Repo                                                        | Release                                                                                                                                 | Releasability                                                                           | Nightly                                                                               |
| ----------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------- |
| [knative.dev/operator](https://github.com/knative/operator) | [![Releases](https://img.shields.io/github/release-pre/knative/operator.svg?sort=semver)](https://github.com/knative/operator/releases) | [![Releasability](https://github.com/knative/operator/workflows/Releasability/badge.svg)](https://github.com/knative/operator/actions/workflows/knative-releasability.yaml) | [![Nightly](https://prow.knative.dev/badge.svg?jobs=nightly_operator_main_periodic)](https://prow.knative.dev?job=nightly_operator_main_periodic) |
| [knative.dev/docs](https://github.com/knative/docs)       | N/A      | N/A    | N/A                                                                                   |
