---
name: Knative Release Checklist
about: This checklist tracks tasks and repo releases for a Knative release.
title: "Release v1.XX"
assignees: knative-release-leads
---

# Timeline of a Knative release

We release each repository of `knative.dev` roughly every 3 months. Please check the [release schedule](https://github.com/knative/release/blob/main/README.md#release-schedule) to calculate when to start work on each checkpoint of a release timeline.

## Repos to be released

- All repos to be released are listed in this document
- Each repo indicates its releasability and other statuses, when applicable
- Each repo needs to be successfully updated to use the latest version of all dependencies **before** cutting its release branch

### T-minus 30 days

- [ ] Release leads have been updated for the upcoming release (see [procedure](https://github.com/knative/release/blob/main/PROCEDURES.md#permissions-for-release-leads))
  - See workflow to check rollout: [![Owner Workflow](https://github.com/knative/release/actions/workflows/check-owners.yaml/badge.svg)](https://github.com/knative/release/actions/workflows/check-owners.yaml)

### T-minus 14 days

- [ ] Update release version in the following workflows

  - [ ] Releasability (see: [procedure](https://github.com/knative/release/blob/main/PROCEDURES.md#updating-the-releasability-defaults))
  - [ ] Update Dependency (see: [procedure](https://github.com/knative/release/blob/main/PROCEDURES.md#bump-dependencies-in-auto-update-job))

- [ ] An announcement has been made in the [**#knative**](https://app.slack.com/client/T08PSQ7BQ/C04LGHDR9K7) Slack channel that [`knative.dev/pkg`](https://github.com/knative/pkg) will be released in a week

### T-minus 7 days - releasing supporting repos

Guidance on [releasing a repository](https://github.com/knative/release/blob/main/PROCEDURES.md#releasing-a-repository).

- [ ] An announcement has been made in the [**#knative**](https://app.slack.com/client/T08PSQ7BQ/C04LGHDR9K7) Slack channel that the cut of [`knative.dev/pkg`](https://github.com/knative/pkg) is imminent
- [ ] Check the status of the nightly builds. See the badge against each core repo in Phase 1. Let the [working group leads](https://github.com/knative/community/blob/main/working-groups/WORKING-GROUPS.md) know about failures and ask them to investigate.Repeat this process throughout the week. This should not be a blocker to start cutting the supporting repositories mentioned below.

Notes

- Some of the supporting repos can be cut in parallel. Refer [Aligning dependencies](https://github.com/knative/release/blob/main/PROCEDURES.md/#Aligning-dependencies).
- The release branch for each supporting repos must be done only after the branch for their dependencies is cut.

#### Cut Supporting Repositories

- [knative/hack](https://github.com/knative/hack)
  - [ ] Branch Cut
- [knative/pkg](https://github.com/knative/pkg)
  - [ ] Dependencies up to date - [![releasabilty][pkg-release-badge]][pkg-release-workflow]
  - [ ] Branch Cut
- [knative/networking](https://github.com/knative/networking)
  - [ ] Dependencies up to date - [![releasabilty][networking-release-badge]][networking-release-workflow]
  - [ ] Branch Cut
- [knative/caching](https://github.com/knative/caching)
  - [ ] Dependencies up to date - [![releasabilty][caching-release-badge]][caching-release-workflow]
  - [ ] Branch Cut
- [knative-extensions/reconciler-test](https://github.com/knative-extensions/reconciler-test)
  - [ ] Dependencies up to date - [![releasabilty][reconciler-test-release-badge]][reconciler-test-release-workflow]
  - [ ] Branch Cut

### T-minus 1 day

- [ ] Obtained ACK from each [working group lead](https://github.com/knative/community/blob/main/working-groups/WORKING-GROUPS.md) that the release is imminent and is green-lighted.

- [ ] Re-check for status of the nightly releases and notify [working group leads](https://github.com/knative/community/blob/main/working-groups/WORKING-GROUPS.md) of failures. Repeat until all are passing.

### Release Day(s)

- If no acknowledgement is received from any of the WGL, send another message on slack and start working on the release after sometime.
- Review the [PROCEDURE](https://github.com/knative/release/blob/main/PROCEDURES.md#releasing-a-repository) on how to release a repo.
  Notes
- It is not required that all repos in the included sub-sections be released on the same day the release is scheduled to start.
- The release notes of a dependency are not a blocker for proceeding to cut a release for a repo.
- The prow job web page is very slow to respond and you need to click only once to rerun the job.
- Some repos can be released in parallel.Refer [Aligning dependencies](https://github.com/knative/release/blob/main/PROCEDURES.md#Aligning-dependencies).

#### Phase 1 - Core Repositories _(Can be started after all the supporting repos have been successfully released)_

- [knative/serving](https://github.com/knative/serving)
  - [ ] Nightly Job [![Nightly][serving-nightly-badge]][serving-nightly-page]
  - [ ] Dependencies up to date - [![releasabilty][serving-release-badge]][serving-release-workflow]
  - [ ] Branch Cut
  - [ ] Release
    - Prow Release Job [![Prow][serving-prow-badge]][serving-prow-job]
    - Latest Version [![Releases][serving-version-badge]][serving-release-page]
  - [ ] Release Notes ([run workflow][release-note-workflow])
- [knative/eventing](https://github.com/knative/eventing)
  - [ ] Nightly Job [![Nightly][eventing-nightly-badge]][eventing-nightly-page]
  - [ ] Dependencies up to date - [![releasabilty][eventing-release-badge]][eventing-release-workflow]
  - [ ] Branch Cut
  - [ ] Release
    - Prow Release Job [![Prow][eventing-prow-badge]][eventing-prow-job]
    - Latest Version [![Releases][eventing-version-badge]][eventing-release-page]
  - [ ] Release Notes ([run workflow][release-note-workflow])
- [knative-extensions/net-contour](https://github.com/knative-extensions/net-contour)
  - [ ] Nightly Job [![Nightly][net-contour-nightly-badge]][net-contour-nightly-page]
  - [ ] Dependencies up to date - [![releasabilty][net-contour-release-badge]][net-contour-release-workflow]
  - [ ] Branch Cut
  - [ ] Release
    - Prow Release [![Releases][net-contour-prow-badge]][net-contour-prow-job]
    - Latest Version [![Releases][net-contour-version-badge]][net-contour-release-page]
  - [ ] Release Notes ([run workflow][release-note-workflow])
- [knative-extensions/net-gateway-api](https://github.com/knative-extensions/net-gateway-api)
  - [ ] Nightly Job [![Nightly][net-gateway-api-nightly-badge]][net-gateway-api-nightly-page]
  - [ ] Dependencies up to date - [![releasabilty][net-gateway-api-release-badge]][net-gateway-api-release-workflow]
  - [ ] Branch Cut
  - [ ] Release https://app.slack.com/client/T08PSQ7BQ/C050X5BGNNS
    - Prow Release [![Releases][net-gateway-api-prow-badge]][net-gateway-api-prow-job]
    - Latest Version [![Releases][net-gateway-api-version-badge]][net-gateway-api-release-page]
  - [ ] Release Notes ([run workflow][release-note-workflow])
- [knative-extensions/net-istio](https://github.com/knative-extensions/net-istio)
  - [ ] Nightly Job [![Nightly][net-istio-nightly-badge]][net-istio-nightly-page]
  - [ ] Dependencies up to date - [![releasabilty][net-istio-release-badge]][net-istio-release-workflow]
  - [ ] Branch Cut
  - [ ] Release
    - Prow Release [![Releases][net-istio-prow-badge]][net-istio-prow-job]
    - Latest Version [![Releases][net-istio-version-badge]][net-istio-release-page]
  - [ ] Release Notes ([run workflow][release-note-workflow])
- [knative-extensions/net-kourier](https://github.com/knative-extensions/net-kourier)
  - [ ] Nightly Job [![Nightly][net-kourier-nightly-badge]][net-kourier-nightly-page]
  - [ ] Dependencies up to date - [![releasabilty][net-kourier-release-badge]][net-kourier-release-workflow]
  - [ ] Branch Cut
  - [ ] Release
    - Prow Release [![Releases][net-kourier-prow-badge]][net-kourier-prow-job]
    - Latest Version [![Releases][net-kourier-version-badge]][net-kourier-release-page]
  - [ ] Release Notes ([run workflow][release-note-workflow])
- [knative-extensions/sample-controller](https://github.com/knative-extensions/sample-controller)
  - [ ] Nightly Job [![Nightly][sample-controller-nightly-badge]][sample-controller-nightly-page]
  - [ ] Dependencies up to date - [![releasabilty][sample-controller-release-badge]][sample-controller-release-workflow]
  - [ ] Branch Cut
  - [ ] Release
    - Prow Release [![Releases][sample-controller-prow-badge]][sample-controller-prow-job]
    - Latest Version [![Releases][sample-controller-version-badge]][sample-controller-release-page]
  - [ ] Release Notes ([run workflow][release-note-workflow])

#### Phase 2 - Eventing Dependant Repositories _(Can be started after `knative/eventing` has been successfully released)_

- [knative-extensions/eventing-ceph](https://github.com/knative-extensions/eventing-ceph)
  - [ ] Nightly Job [![Nightly][eventing-ceph-nightly-badge]][eventing-ceph-nightly-page]
  - [ ] Dependencies up to date - [![releasabilty][eventing-ceph-release-badge]][eventing-ceph-release-workflow]
  - [ ] Branch Cut
  - [ ] Release
    - Prow Release Job [![Prow][eventing-ceph-prow-badge]][eventing-ceph-prow-job]
    - Latest Version [![Releases][eventing-ceph-version-badge]][eventing-ceph-release-page]
  - [ ] Release Notes ([run workflow][release-note-workflow])
- [knative-extensions/eventing-kogito](https://github.com/knative-extensions/eventing-kogito)
  - [ ] Nightly Job [![Nightly][eventing-kogito-nightly-badge]][eventing-kogito-nightly-page]
  - [ ] Dependencies up to date - [![releasabilty][eventing-kogito-release-badge]][eventing-kogito-release-workflow]
  - [ ] Branch Cut
  - [ ] Release
    - Prow Release Job [![Prow][eventing-kogito-prow-badge]][eventing-kogito-prow-job]
    - Latest Version [![Releases][eventing-kogito-version-badge]][eventing-kogito-release-page]
  - [ ] Release Notes ([run workflow][release-note-workflow])
- [knative-extensions/eventing-rabbitmq](https://github.com/knative-extensions/eventing-rabbitmq)
  - [ ] Nightly Job [![Nightly][eventing-rabbitmq-nightly-badge]][eventing-rabbitmq-nightly-page]
  - [ ] Dependencies up to date - [![releasabilty][eventing-rabbitmq-release-badge]][eventing-rabbitmq-release-workflow]
  - [ ] Branch Cut
  - [ ] Release
    - Prow Release Job [![Prow][eventing-rabbitmq-prow-badge]][eventing-rabbitmq-prow-job]
    - Latest Version [![Releases][eventing-rabbitmq-version-badge]][eventing-rabbitmq-release-page]
  - [ ] Release Notes ([run workflow][release-note-workflow])
- [knative-extensions/sample-source](https://github.com/knative-extensions/sample-source)
  - [ ] Nightly Job [![Nightly][sample-source-nightly-badge]][sample-source-nightly-page]
  - [ ] Dependencies up to date - [![releasabilty][sample-source-release-badge]][sample-source-release-workflow]
  - [ ] Branch Cut
  - [ ] Release
    - Prow Release Job [![Prow][sample-source-prow-badge]][sample-source-prow-job]
    - Latest Version [![Releases][sample-source-version-badge]][sample-source-release-page]
  - [ ] Release Notes ([run workflow][release-note-workflow])

#### Phase 3 - Sub-Supporting Repositories _(Can be started after `knative/eventing` & `knative/serving` have been successfully released)_

- [knative/client-pkg](https://github.com/knative/client-pkg)
  - [ ] Nightly Job [n/a]
  - [ ] Dependencies up to date - [![releasabilty][client-pkg-release-badge]][client-pkg-release-workflow]
  - [ ] Branch Cut

#### Phase 4 - Client-pkg Dependant Repositories _(Can be started after `knative/client-pkg` has been successfully released)_

- [knative/client](https://github.com/knative/client)
  - [ ] Nightly Job [![Nightly][client-nightly-badge]][client-nightly-page]
  - [ ] Dependencies up to date - [![releasabilty][client-release-badge]][client-release-workflow]
  - [ ] Branch Cut
  - [ ] Release
    - Prow Release Job [![Prow][client-prow-badge]][client-prow-job]
    - Latest Version [![Releases][client-version-badge]][client-release-page]
  - [ ] Release Notes ([run workflow][release-note-workflow])
- [knative-extensions/eventing-kafka-broker](https://github.com/knative-extensions/eventing-kafka-broker)
  - [ ] Nightly Job [![Nightly][eventing-kafka-broker-nightly-badge]][eventing-kafka-broker-nightly-page]
  - [ ] Dependencies up to date - [![releasabilty][eventing-kafka-broker-release-badge]][eventing-kafka-broker-release-workflow]
  - [ ] Branch Cut
  - [ ] Release
    - Prow Release Job [![Prow][eventing-kafka-broker-prow-badge]][eventing-kafka-broker-prow-job]
    - Latest Version [![Releases][eventing-kafka-broker-version-badge]][eventing-kafka-broker-release-page]
  - [ ] Release Notes ([run workflow][release-note-workflow])
- [knative-extensions/eventing-redis](https://github.com/knative-extensions/eventing-redis)
  - [ ] Nightly Job [![Nightly][eventing-redis-nightly-badge]][eventing-redis-nightly-page]
  - [ ] Dependencies up to date - [![releasabilty][eventing-redis-release-badge]][eventing-redis-release-workflow]
  - [ ] Branch Cut
  - [ ] Release
    - Prow Release Job [![Prow][eventing-redis-prow-badge]][eventing-redis-prow-job]
    - Latest Version [![Releases][eventing-redis-version-badge]][eventing-redis-release-page]
  - [ ] Release Notes ([run workflow][release-note-workflow])
- [knative-extensions/eventing-github](https://github.com/knative-extensions/eventing-github)
  - [ ] Nightly Job [![Nightly][eventing-github-nightly-badge]][eventing-github-nightly-page]
  - [ ] Dependencies up to date - [![releasabilty][eventing-github-release-badge]][eventing-github-release-workflow]
  - [ ] Branch Cut
  - [ ] Release
    - Prow Release Job [![Prow][eventing-github-prow-badge]][eventing-github-prow-job]
    - Latest Version [![Releases][eventing-github-version-badge]][eventing-github-release-page]
  - [ ] Release Notes ([run workflow][release-note-workflow])
- [knative-extensions/eventing-gitlab](https://github.com/knative-extensions/eventing-gitlab)
  - [ ] Nightly Job [![Nightly][eventing-gitlab-nightly-badge]][eventing-gitlab-nightly-page]
  - [ ] Dependencies up to date - [![releasabilty][eventing-gitlab-release-badge]][eventing-gitlab-release-workflow]
  - [ ] Branch Cut
  - [ ] Release
    - Prow Release Job [![Prow][eventing-gitlab-prow-badge]][eventing-gitlab-prow-job]
    - Latest Version [![Releases][eventing-gitlab-version-badge]][eventing-gitlab-release-page]
  - [ ] Release Notes ([run workflow][release-note-workflow])
- [knative-extensions/eventing-natss](https://github.com/knative-extensions/eventing-natss)
  - [ ] Nightly Job [![Nightly][eventing-natss-nightly-badge]][eventing-natss-nightly-page]
  - [ ] Dependencies up to date - [![releasabilty][eventing-natss-release-badge]][eventing-natss-release-workflow]
  - [ ] Branch Cut
  - [ ] Release
    - Prow Release Job [![Prow][eventing-natss-prow-badge]][eventing-natss-prow-job]
    - Latest Version [![Releases][eventing-natss-version-badge]][eventing-natss-release-page]
  - [ ] Release Notes ([run workflow][release-note-workflow])

#### Phase 5 - Remaining Repositories _(Can be started after all the previous repos has been successfully released)_

- [knative-extensions/eventing-istio](https://github.com/knative-extensions/eventing-istio)
  - [ ] Nightly Job [![Nightly][eventing-istio-nightly-badge]][eventing-istio-nightly-page]
  - [ ] Dependencies up to date - [![releasabilty][eventing-istio-release-badge]][eventing-istio-release-workflow]
  - [ ] Branch Cut
  - [ ] Release
    - Prow Release Job [![Prow][eventing-istio-prow-badge]][eventing-istio-prow-job]
    - Latest Version [![Releases][eventing-istio-version-badge]][eventing-istio-release-page]
  - [ ] Release Notes ([run workflow][release-note-workflow])
- [knative-extensions/eventing-autoscaler-keda](https://github.com/knative-extensions/eventing-autoscaler-keda)
  - [ ] Nightly Job [![Nightly][eventing-autoscaler-keda-nightly-badge]][eventing-autoscaler-keda-nightly-page]
  - [ ] Dependencies up to date - [![releasabilty][eventing-autoscaler-keda-release-badge]][eventing-autoscaler-keda-release-workflow]
  - [ ] Branch Cut
  - [ ] Release
    - Prow Release Job [![Prow][eventing-autoscaler-keda-prow-badge]][eventing-autoscaler-keda-prow-job]
    - Latest Version [![Releases][eventing-autoscaler-keda-version-badge]][eventing-autoscaler-keda-release-page]
  - [ ] Release Notes ([run workflow][release-note-workflow])
- [knative-extensions/kn-plugin-admin](https://github.com/knative-extensions/kn-plugin-admin)
  - [ ] Nightly Job [![Nightly][kn-plugin-admin-nightly-badge]][kn-plugin-admin-nightly-page]
  - [ ] Dependencies up to date - [![releasabilty][kn-plugin-admin-release-badge]][kn-plugin-admin-release-workflow]
  - [ ] Branch Cut
  - [ ] Release
    - Prow Release Job [![Prow][kn-plugin-admin-prow-badge]][kn-plugin-admin-prow-job]
    - Latest Version [![Releases][kn-plugin-admin-version-badge]][kn-plugin-admin-release-page]
  - [ ] Release Notes ([run workflow][release-note-workflow])
- [knative-extensions/kn-plugin-event](https://github.com/knative-extensions/kn-plugin-event)
  - [ ] Nightly Job [![Nightly][kn-plugin-event-nightly-badge]][kn-plugin-event-nightly-page]
  - [ ] Dependencies up to date - [![releasabilty][kn-plugin-event-release-badge]][kn-plugin-event-release-workflow]
  - [ ] Branch Cut
  - [ ] Release
    - Prow Release Job [![Prow][kn-plugin-event-prow-badge]][kn-plugin-event-prow-job]
    - Latest Version [![Releases][kn-plugin-event-version-badge]][kn-plugin-event-release-page]
  - [ ] Release Notes ([run workflow][release-note-workflow])
- [knative-extensions/kn-plugin-source-kafka](https://github.com/knative-extensions/kn-plugin-source-kafka)
  - [ ] Nightly Job [![Nightly][kn-plugin-source-kafka-nightly-badge]][kn-plugin-source-kafka-nightly-page]
  - [ ] Dependencies up to date - [![releasabilty][kn-plugin-source-kafka-release-badge]][kn-plugin-source-kafka-release-workflow]
  - [ ] Branch Cut
  - [ ] Release
    - Prow Release Job [![Prow][kn-plugin-source-kafka-prow-badge]][kn-plugin-source-kafka-prow-job]
    - Latest Version [![Releases][kn-plugin-source-kafka-version-badge]][kn-plugin-source-kafka-release-page]
  - [ ] Release Notes ([run workflow][release-note-workflow])
- [knative-extensions/kn-plugin-source-kamelet](https://github.com/knative-extensions/kn-plugin-source-kamelet)
  - [ ] Nightly Job [![Nightly][kn-plugin-source-kamelet-nightly-badge]][kn-plugin-source-kamelet-nightly-page]
  - [ ] Dependencies up to date - [![releasabilty][kn-plugin-source-kamelet-release-badge]][kn-plugin-source-kamelet-release-workflow]
  - [ ] Branch Cut
  - [ ] Release
    - Prow Release Job [![Prow][kn-plugin-source-kamelet-prow-badge]][kn-plugin-source-kamelet-prow-job]
    - Latest Version [![Releases][kn-plugin-source-kamelet-version-badge]][kn-plugin-source-kamelet-release-page]
  - [ ] Release Notes ([run workflow][release-note-workflow])
- [knative-extensions/kn-plugin-quickstart](https://github.com/knative-extensions/kn-plugin-quickstart)
  - [ ] Nightly Job [![Nightly][kn-plugin-quickstart-nightly-badge]][kn-plugin-quickstart-nightly-page]
  - [ ] Dependencies up to date - [![releasabilty][kn-plugin-quickstart-release-badge]][kn-plugin-quickstart-release-workflow]
  - [ ] Branch Cut
  - [ ] Release
    - Prow Release Job [![Prow][kn-plugin-quickstart-prow-badge]][kn-plugin-quickstart-prow-job]
    - Latest Version [![Releases][kn-plugin-quickstart-version-badge]][kn-plugin-quickstart-release-page]
  - [ ] Release Notes ([run workflow][release-note-workflow])
- [knative/func](https://github.com/knative/func)
  - [ ] Nightly Job [![Nightly][func-nightly-badge]][func-nightly-page]
  - [ ] Dependencies up to date - [![releasabilty][func-release-badge]][func-release-workflow]
  - [ ] Branch Cut
  - [ ] Release
    - Prow Release Job [![Prow][func-prow-badge]][func-prow-job]
    - Latest Version [![Releases][func-version-badge]][func-release-page]
  - [ ] Release Notes ([run workflow][release-note-workflow])

#### Final Phase

- [ ] Talk to Vincent (Operator WG Lead) and have him cut (or help you cut) the [knative/operator](https://github.com/knative/operator) [![Releases][operator-version-badge]][operator-release-page]
- [ ] Knative Client Homebrew has been updated (see [procedure](https://github.com/knative/release/blob/main/PROCEDURES.md#homebrew-client))
- [ ] Knative Client Plugins Homebrew has been updated (see [procedure](https://github.com/knative/release/blob/main/PROCEDURES.md#homebrew-kn-plugins))

### Post Release - after operator is cut

- [ ] Release the knative.dev/docs (see [procedure](https://github.com/knative/release/blob/main/PROCEDURES.md#releasing-a-new-version-of-the-knative-documentation))
- [ ] Release schedule has been updated in [RELEASE-SCHEDULE.md](https://github.com/knative/community/blob/main/mechanics/RELEASE-SCHEDULE.md) and [README.md](https://github.com/knative/release/blob/main/README.md)
- [ ] Collect release notes into the blog post and publish it (see [procedure](https://github.com/knative/release/blob/main/PROCEDURES.md#updating-the-release-schedule))
- [ ] Knobots update-deps job has been bumped to the next release version (see [procedure](https://github.com/knative/release/blob/main/PROCEDURES.md#bump-dependencies-in-auto-update-job))
- [ ] An announcement was made in the [**#knative**](https://app.slack.com/client/T08PSQ7BQ/C04LGHDR9K7) Slack channels that the new Knative release is out
- [ ] Document any change(s) needed to improve the release process

[release-note-workflow]: https://github.com/knative/release/actions/workflows/release-note.yaml

<!-- autogen start -->
[caching-version-badge]: https://img.shields.io/github/release-pre/knative/caching.svg?sort=semver
[caching-release-badge]: https://github.com/knative/release/actions/workflows/knative-caching.yaml/badge.svg
[caching-release-page]: https://github.com/knative/caching/releases
[caching-release-workflow]: https://github.com/knative/release/actions/workflows/knative-caching.yaml
[caching-nightly-badge]: https://prow.knative.dev/badge.svg?jobs=nightly_caching_main_periodic
[caching-nightly-page]: https://prow.knative.dev?job=nightly_caching_main_periodic
[caching-prow-badge]: https://prow.knative.dev/badge.svg?jobs=release_caching_main_periodic
[caching-prow-job]: https://prow.knative.dev?job=release_caching_main_periodic

[client-version-badge]: https://img.shields.io/github/release-pre/knative/client.svg?sort=semver
[client-release-badge]: https://github.com/knative/release/actions/workflows/knative-client.yaml/badge.svg
[client-release-page]: https://github.com/knative/client/releases
[client-release-workflow]: https://github.com/knative/release/actions/workflows/knative-client.yaml
[client-nightly-badge]: https://prow.knative.dev/badge.svg?jobs=nightly_client_main_periodic
[client-nightly-page]: https://prow.knative.dev?job=nightly_client_main_periodic
[client-prow-badge]: https://prow.knative.dev/badge.svg?jobs=release_client_main_periodic
[client-prow-job]: https://prow.knative.dev?job=release_client_main_periodic

[client-pkg-version-badge]: https://img.shields.io/github/release-pre/knative/client-pkg.svg?sort=semver
[client-pkg-release-badge]: https://github.com/knative/release/actions/workflows/knative-client-pkg.yaml/badge.svg
[client-pkg-release-page]: https://github.com/knative/client-pkg/releases
[client-pkg-release-workflow]: https://github.com/knative/release/actions/workflows/knative-client-pkg.yaml
[client-pkg-nightly-badge]: https://prow.knative.dev/badge.svg?jobs=nightly_client-pkg_main_periodic
[client-pkg-nightly-page]: https://prow.knative.dev?job=nightly_client-pkg_main_periodic
[client-pkg-prow-badge]: https://prow.knative.dev/badge.svg?jobs=release_client-pkg_main_periodic
[client-pkg-prow-job]: https://prow.knative.dev?job=release_client-pkg_main_periodic

[eventing-version-badge]: https://img.shields.io/github/release-pre/knative/eventing.svg?sort=semver
[eventing-release-badge]: https://github.com/knative/release/actions/workflows/knative-eventing.yaml/badge.svg
[eventing-release-page]: https://github.com/knative/eventing/releases
[eventing-release-workflow]: https://github.com/knative/release/actions/workflows/knative-eventing.yaml
[eventing-nightly-badge]: https://prow.knative.dev/badge.svg?jobs=nightly_eventing_main_periodic
[eventing-nightly-page]: https://prow.knative.dev?job=nightly_eventing_main_periodic
[eventing-prow-badge]: https://prow.knative.dev/badge.svg?jobs=release_eventing_main_periodic
[eventing-prow-job]: https://prow.knative.dev?job=release_eventing_main_periodic

[func-version-badge]: https://img.shields.io/github/release-pre/knative/func.svg?sort=semver
[func-release-badge]: https://github.com/knative/release/actions/workflows/knative-func.yaml/badge.svg
[func-release-page]: https://github.com/knative/func/releases
[func-release-workflow]: https://github.com/knative/release/actions/workflows/knative-func.yaml
[func-nightly-badge]: https://prow.knative.dev/badge.svg?jobs=nightly_func_main_periodic
[func-nightly-page]: https://prow.knative.dev?job=nightly_func_main_periodic
[func-prow-badge]: https://prow.knative.dev/badge.svg?jobs=release_func_main_periodic
[func-prow-job]: https://prow.knative.dev?job=release_func_main_periodic

[networking-version-badge]: https://img.shields.io/github/release-pre/knative/networking.svg?sort=semver
[networking-release-badge]: https://github.com/knative/release/actions/workflows/knative-networking.yaml/badge.svg
[networking-release-page]: https://github.com/knative/networking/releases
[networking-release-workflow]: https://github.com/knative/release/actions/workflows/knative-networking.yaml
[networking-nightly-badge]: https://prow.knative.dev/badge.svg?jobs=nightly_networking_main_periodic
[networking-nightly-page]: https://prow.knative.dev?job=nightly_networking_main_periodic
[networking-prow-badge]: https://prow.knative.dev/badge.svg?jobs=release_networking_main_periodic
[networking-prow-job]: https://prow.knative.dev?job=release_networking_main_periodic

[pkg-version-badge]: https://img.shields.io/github/release-pre/knative/pkg.svg?sort=semver
[pkg-release-badge]: https://github.com/knative/release/actions/workflows/knative-pkg.yaml/badge.svg
[pkg-release-page]: https://github.com/knative/pkg/releases
[pkg-release-workflow]: https://github.com/knative/release/actions/workflows/knative-pkg.yaml
[pkg-nightly-badge]: https://prow.knative.dev/badge.svg?jobs=nightly_pkg_main_periodic
[pkg-nightly-page]: https://prow.knative.dev?job=nightly_pkg_main_periodic
[pkg-prow-badge]: https://prow.knative.dev/badge.svg?jobs=release_pkg_main_periodic
[pkg-prow-job]: https://prow.knative.dev?job=release_pkg_main_periodic

[serving-version-badge]: https://img.shields.io/github/release-pre/knative/serving.svg?sort=semver
[serving-release-badge]: https://github.com/knative/release/actions/workflows/knative-serving.yaml/badge.svg
[serving-release-page]: https://github.com/knative/serving/releases
[serving-release-workflow]: https://github.com/knative/release/actions/workflows/knative-serving.yaml
[serving-nightly-badge]: https://prow.knative.dev/badge.svg?jobs=nightly_serving_main_periodic
[serving-nightly-page]: https://prow.knative.dev?job=nightly_serving_main_periodic
[serving-prow-badge]: https://prow.knative.dev/badge.svg?jobs=release_serving_main_periodic
[serving-prow-job]: https://prow.knative.dev?job=release_serving_main_periodic

[operator-version-badge]: https://img.shields.io/github/release-pre/knative/operator.svg?sort=semver
[operator-release-badge]: https://github.com/knative/release/actions/workflows/knative-operator.yaml/badge.svg
[operator-release-page]: https://github.com/knative/operator/releases
[operator-release-workflow]: https://github.com/knative/release/actions/workflows/knative-operator.yaml
[operator-nightly-badge]: https://prow.knative.dev/badge.svg?jobs=nightly_operator_main_periodic
[operator-nightly-page]: https://prow.knative.dev?job=nightly_operator_main_periodic
[operator-prow-badge]: https://prow.knative.dev/badge.svg?jobs=release_operator_main_periodic
[operator-prow-job]: https://prow.knative.dev?job=release_operator_main_periodic

[eventing-autoscaler-keda-version-badge]: https://img.shields.io/github/release-pre/knative-extensions/eventing-autoscaler-keda.svg?sort=semver
[eventing-autoscaler-keda-release-badge]: https://github.com/knative/release/actions/workflows/knative-extensions-eventing-autoscaler-keda.yaml/badge.svg
[eventing-autoscaler-keda-release-page]: https://github.com/knative-extensions/eventing-autoscaler-keda/releases
[eventing-autoscaler-keda-release-workflow]: https://github.com/knative/release/actions/workflows/knative-extensions-eventing-autoscaler-keda.yaml
[eventing-autoscaler-keda-nightly-badge]: https://prow.knative.dev/badge.svg?jobs=nightly_eventing-autoscaler-keda_main_periodic
[eventing-autoscaler-keda-nightly-page]: https://prow.knative.dev?job=nightly_eventing-autoscaler-keda_main_periodic
[eventing-autoscaler-keda-prow-badge]: https://prow.knative.dev/badge.svg?jobs=release_eventing-autoscaler-keda_main_periodic
[eventing-autoscaler-keda-prow-job]: https://prow.knative.dev?job=release_eventing-autoscaler-keda_main_periodic

[eventing-ceph-version-badge]: https://img.shields.io/github/release-pre/knative-extensions/eventing-ceph.svg?sort=semver
[eventing-ceph-release-badge]: https://github.com/knative/release/actions/workflows/knative-extensions-eventing-ceph.yaml/badge.svg
[eventing-ceph-release-page]: https://github.com/knative-extensions/eventing-ceph/releases
[eventing-ceph-release-workflow]: https://github.com/knative/release/actions/workflows/knative-extensions-eventing-ceph.yaml
[eventing-ceph-nightly-badge]: https://prow.knative.dev/badge.svg?jobs=nightly_eventing-ceph_main_periodic
[eventing-ceph-nightly-page]: https://prow.knative.dev?job=nightly_eventing-ceph_main_periodic
[eventing-ceph-prow-badge]: https://prow.knative.dev/badge.svg?jobs=release_eventing-ceph_main_periodic
[eventing-ceph-prow-job]: https://prow.knative.dev?job=release_eventing-ceph_main_periodic

[eventing-github-version-badge]: https://img.shields.io/github/release-pre/knative-extensions/eventing-github.svg?sort=semver
[eventing-github-release-badge]: https://github.com/knative/release/actions/workflows/knative-extensions-eventing-github.yaml/badge.svg
[eventing-github-release-page]: https://github.com/knative-extensions/eventing-github/releases
[eventing-github-release-workflow]: https://github.com/knative/release/actions/workflows/knative-extensions-eventing-github.yaml
[eventing-github-nightly-badge]: https://prow.knative.dev/badge.svg?jobs=nightly_eventing-github_main_periodic
[eventing-github-nightly-page]: https://prow.knative.dev?job=nightly_eventing-github_main_periodic
[eventing-github-prow-badge]: https://prow.knative.dev/badge.svg?jobs=release_eventing-github_main_periodic
[eventing-github-prow-job]: https://prow.knative.dev?job=release_eventing-github_main_periodic

[eventing-gitlab-version-badge]: https://img.shields.io/github/release-pre/knative-extensions/eventing-gitlab.svg?sort=semver
[eventing-gitlab-release-badge]: https://github.com/knative/release/actions/workflows/knative-extensions-eventing-gitlab.yaml/badge.svg
[eventing-gitlab-release-page]: https://github.com/knative-extensions/eventing-gitlab/releases
[eventing-gitlab-release-workflow]: https://github.com/knative/release/actions/workflows/knative-extensions-eventing-gitlab.yaml
[eventing-gitlab-nightly-badge]: https://prow.knative.dev/badge.svg?jobs=nightly_eventing-gitlab_main_periodic
[eventing-gitlab-nightly-page]: https://prow.knative.dev?job=nightly_eventing-gitlab_main_periodic
[eventing-gitlab-prow-badge]: https://prow.knative.dev/badge.svg?jobs=release_eventing-gitlab_main_periodic
[eventing-gitlab-prow-job]: https://prow.knative.dev?job=release_eventing-gitlab_main_periodic

[eventing-istio-version-badge]: https://img.shields.io/github/release-pre/knative-extensions/eventing-istio.svg?sort=semver
[eventing-istio-release-badge]: https://github.com/knative/release/actions/workflows/knative-extensions-eventing-istio.yaml/badge.svg
[eventing-istio-release-page]: https://github.com/knative-extensions/eventing-istio/releases
[eventing-istio-release-workflow]: https://github.com/knative/release/actions/workflows/knative-extensions-eventing-istio.yaml
[eventing-istio-nightly-badge]: https://prow.knative.dev/badge.svg?jobs=nightly_eventing-istio_main_periodic
[eventing-istio-nightly-page]: https://prow.knative.dev?job=nightly_eventing-istio_main_periodic
[eventing-istio-prow-badge]: https://prow.knative.dev/badge.svg?jobs=release_eventing-istio_main_periodic
[eventing-istio-prow-job]: https://prow.knative.dev?job=release_eventing-istio_main_periodic

[eventing-kafka-broker-version-badge]: https://img.shields.io/github/release-pre/knative-extensions/eventing-kafka-broker.svg?sort=semver
[eventing-kafka-broker-release-badge]: https://github.com/knative/release/actions/workflows/knative-extensions-eventing-kafka-broker.yaml/badge.svg
[eventing-kafka-broker-release-page]: https://github.com/knative-extensions/eventing-kafka-broker/releases
[eventing-kafka-broker-release-workflow]: https://github.com/knative/release/actions/workflows/knative-extensions-eventing-kafka-broker.yaml
[eventing-kafka-broker-nightly-badge]: https://prow.knative.dev/badge.svg?jobs=nightly_eventing-kafka-broker_main_periodic
[eventing-kafka-broker-nightly-page]: https://prow.knative.dev?job=nightly_eventing-kafka-broker_main_periodic
[eventing-kafka-broker-prow-badge]: https://prow.knative.dev/badge.svg?jobs=release_eventing-kafka-broker_main_periodic
[eventing-kafka-broker-prow-job]: https://prow.knative.dev?job=release_eventing-kafka-broker_main_periodic

[eventing-kogito-version-badge]: https://img.shields.io/github/release-pre/knative-extensions/eventing-kogito.svg?sort=semver
[eventing-kogito-release-badge]: https://github.com/knative/release/actions/workflows/knative-extensions-eventing-kogito.yaml/badge.svg
[eventing-kogito-release-page]: https://github.com/knative-extensions/eventing-kogito/releases
[eventing-kogito-release-workflow]: https://github.com/knative/release/actions/workflows/knative-extensions-eventing-kogito.yaml
[eventing-kogito-nightly-badge]: https://prow.knative.dev/badge.svg?jobs=nightly_eventing-kogito_main_periodic
[eventing-kogito-nightly-page]: https://prow.knative.dev?job=nightly_eventing-kogito_main_periodic
[eventing-kogito-prow-badge]: https://prow.knative.dev/badge.svg?jobs=release_eventing-kogito_main_periodic
[eventing-kogito-prow-job]: https://prow.knative.dev?job=release_eventing-kogito_main_periodic

[eventing-natss-version-badge]: https://img.shields.io/github/release-pre/knative-extensions/eventing-natss.svg?sort=semver
[eventing-natss-release-badge]: https://github.com/knative/release/actions/workflows/knative-extensions-eventing-natss.yaml/badge.svg
[eventing-natss-release-page]: https://github.com/knative-extensions/eventing-natss/releases
[eventing-natss-release-workflow]: https://github.com/knative/release/actions/workflows/knative-extensions-eventing-natss.yaml
[eventing-natss-nightly-badge]: https://prow.knative.dev/badge.svg?jobs=nightly_eventing-natss_main_periodic
[eventing-natss-nightly-page]: https://prow.knative.dev?job=nightly_eventing-natss_main_periodic
[eventing-natss-prow-badge]: https://prow.knative.dev/badge.svg?jobs=release_eventing-natss_main_periodic
[eventing-natss-prow-job]: https://prow.knative.dev?job=release_eventing-natss_main_periodic

[eventing-rabbitmq-version-badge]: https://img.shields.io/github/release-pre/knative-extensions/eventing-rabbitmq.svg?sort=semver
[eventing-rabbitmq-release-badge]: https://github.com/knative/release/actions/workflows/knative-extensions-eventing-rabbitmq.yaml/badge.svg
[eventing-rabbitmq-release-page]: https://github.com/knative-extensions/eventing-rabbitmq/releases
[eventing-rabbitmq-release-workflow]: https://github.com/knative/release/actions/workflows/knative-extensions-eventing-rabbitmq.yaml
[eventing-rabbitmq-nightly-badge]: https://prow.knative.dev/badge.svg?jobs=nightly_eventing-rabbitmq_main_periodic
[eventing-rabbitmq-nightly-page]: https://prow.knative.dev?job=nightly_eventing-rabbitmq_main_periodic
[eventing-rabbitmq-prow-badge]: https://prow.knative.dev/badge.svg?jobs=release_eventing-rabbitmq_main_periodic
[eventing-rabbitmq-prow-job]: https://prow.knative.dev?job=release_eventing-rabbitmq_main_periodic

[eventing-redis-version-badge]: https://img.shields.io/github/release-pre/knative-extensions/eventing-redis.svg?sort=semver
[eventing-redis-release-badge]: https://github.com/knative/release/actions/workflows/knative-extensions-eventing-redis.yaml/badge.svg
[eventing-redis-release-page]: https://github.com/knative-extensions/eventing-redis/releases
[eventing-redis-release-workflow]: https://github.com/knative/release/actions/workflows/knative-extensions-eventing-redis.yaml
[eventing-redis-nightly-badge]: https://prow.knative.dev/badge.svg?jobs=nightly_eventing-redis_main_periodic
[eventing-redis-nightly-page]: https://prow.knative.dev?job=nightly_eventing-redis_main_periodic
[eventing-redis-prow-badge]: https://prow.knative.dev/badge.svg?jobs=release_eventing-redis_main_periodic
[eventing-redis-prow-job]: https://prow.knative.dev?job=release_eventing-redis_main_periodic

[kn-plugin-admin-version-badge]: https://img.shields.io/github/release-pre/knative-extensions/kn-plugin-admin.svg?sort=semver
[kn-plugin-admin-release-badge]: https://github.com/knative/release/actions/workflows/knative-extensions-kn-plugin-admin.yaml/badge.svg
[kn-plugin-admin-release-page]: https://github.com/knative-extensions/kn-plugin-admin/releases
[kn-plugin-admin-release-workflow]: https://github.com/knative/release/actions/workflows/knative-extensions-kn-plugin-admin.yaml
[kn-plugin-admin-nightly-badge]: https://prow.knative.dev/badge.svg?jobs=nightly_kn-plugin-admin_main_periodic
[kn-plugin-admin-nightly-page]: https://prow.knative.dev?job=nightly_kn-plugin-admin_main_periodic
[kn-plugin-admin-prow-badge]: https://prow.knative.dev/badge.svg?jobs=release_kn-plugin-admin_main_periodic
[kn-plugin-admin-prow-job]: https://prow.knative.dev?job=release_kn-plugin-admin_main_periodic

[kn-plugin-event-version-badge]: https://img.shields.io/github/release-pre/knative-extensions/kn-plugin-event.svg?sort=semver
[kn-plugin-event-release-badge]: https://github.com/knative/release/actions/workflows/knative-extensions-kn-plugin-event.yaml/badge.svg
[kn-plugin-event-release-page]: https://github.com/knative-extensions/kn-plugin-event/releases
[kn-plugin-event-release-workflow]: https://github.com/knative/release/actions/workflows/knative-extensions-kn-plugin-event.yaml
[kn-plugin-event-nightly-badge]: https://prow.knative.dev/badge.svg?jobs=nightly_kn-plugin-event_main_periodic
[kn-plugin-event-nightly-page]: https://prow.knative.dev?job=nightly_kn-plugin-event_main_periodic
[kn-plugin-event-prow-badge]: https://prow.knative.dev/badge.svg?jobs=release_kn-plugin-event_main_periodic
[kn-plugin-event-prow-job]: https://prow.knative.dev?job=release_kn-plugin-event_main_periodic

[kn-plugin-quickstart-version-badge]: https://img.shields.io/github/release-pre/knative-extensions/kn-plugin-quickstart.svg?sort=semver
[kn-plugin-quickstart-release-badge]: https://github.com/knative/release/actions/workflows/knative-extensions-kn-plugin-quickstart.yaml/badge.svg
[kn-plugin-quickstart-release-page]: https://github.com/knative-extensions/kn-plugin-quickstart/releases
[kn-plugin-quickstart-release-workflow]: https://github.com/knative/release/actions/workflows/knative-extensions-kn-plugin-quickstart.yaml
[kn-plugin-quickstart-nightly-badge]: https://prow.knative.dev/badge.svg?jobs=nightly_kn-plugin-quickstart_main_periodic
[kn-plugin-quickstart-nightly-page]: https://prow.knative.dev?job=nightly_kn-plugin-quickstart_main_periodic
[kn-plugin-quickstart-prow-badge]: https://prow.knative.dev/badge.svg?jobs=release_kn-plugin-quickstart_main_periodic
[kn-plugin-quickstart-prow-job]: https://prow.knative.dev?job=release_kn-plugin-quickstart_main_periodic

[kn-plugin-source-kafka-version-badge]: https://img.shields.io/github/release-pre/knative-extensions/kn-plugin-source-kafka.svg?sort=semver
[kn-plugin-source-kafka-release-badge]: https://github.com/knative/release/actions/workflows/knative-extensions-kn-plugin-source-kafka.yaml/badge.svg
[kn-plugin-source-kafka-release-page]: https://github.com/knative-extensions/kn-plugin-source-kafka/releases
[kn-plugin-source-kafka-release-workflow]: https://github.com/knative/release/actions/workflows/knative-extensions-kn-plugin-source-kafka.yaml
[kn-plugin-source-kafka-nightly-badge]: https://prow.knative.dev/badge.svg?jobs=nightly_kn-plugin-source-kafka_main_periodic
[kn-plugin-source-kafka-nightly-page]: https://prow.knative.dev?job=nightly_kn-plugin-source-kafka_main_periodic
[kn-plugin-source-kafka-prow-badge]: https://prow.knative.dev/badge.svg?jobs=release_kn-plugin-source-kafka_main_periodic
[kn-plugin-source-kafka-prow-job]: https://prow.knative.dev?job=release_kn-plugin-source-kafka_main_periodic

[kn-plugin-source-kamelet-version-badge]: https://img.shields.io/github/release-pre/knative-extensions/kn-plugin-source-kamelet.svg?sort=semver
[kn-plugin-source-kamelet-release-badge]: https://github.com/knative/release/actions/workflows/knative-extensions-kn-plugin-source-kamelet.yaml/badge.svg
[kn-plugin-source-kamelet-release-page]: https://github.com/knative-extensions/kn-plugin-source-kamelet/releases
[kn-plugin-source-kamelet-release-workflow]: https://github.com/knative/release/actions/workflows/knative-extensions-kn-plugin-source-kamelet.yaml
[kn-plugin-source-kamelet-nightly-badge]: https://prow.knative.dev/badge.svg?jobs=nightly_kn-plugin-source-kamelet_main_periodic
[kn-plugin-source-kamelet-nightly-page]: https://prow.knative.dev?job=nightly_kn-plugin-source-kamelet_main_periodic
[kn-plugin-source-kamelet-prow-badge]: https://prow.knative.dev/badge.svg?jobs=release_kn-plugin-source-kamelet_main_periodic
[kn-plugin-source-kamelet-prow-job]: https://prow.knative.dev?job=release_kn-plugin-source-kamelet_main_periodic

[net-contour-version-badge]: https://img.shields.io/github/release-pre/knative-extensions/net-contour.svg?sort=semver
[net-contour-release-badge]: https://github.com/knative/release/actions/workflows/knative-extensions-net-contour.yaml/badge.svg
[net-contour-release-page]: https://github.com/knative-extensions/net-contour/releases
[net-contour-release-workflow]: https://github.com/knative/release/actions/workflows/knative-extensions-net-contour.yaml
[net-contour-nightly-badge]: https://prow.knative.dev/badge.svg?jobs=nightly_net-contour_main_periodic
[net-contour-nightly-page]: https://prow.knative.dev?job=nightly_net-contour_main_periodic
[net-contour-prow-badge]: https://prow.knative.dev/badge.svg?jobs=release_net-contour_main_periodic
[net-contour-prow-job]: https://prow.knative.dev?job=release_net-contour_main_periodic

[net-gateway-api-version-badge]: https://img.shields.io/github/release-pre/knative-extensions/net-gateway-api.svg?sort=semver
[net-gateway-api-release-badge]: https://github.com/knative/release/actions/workflows/knative-extensions-net-gateway-api.yaml/badge.svg
[net-gateway-api-release-page]: https://github.com/knative-extensions/net-gateway-api/releases
[net-gateway-api-release-workflow]: https://github.com/knative/release/actions/workflows/knative-extensions-net-gateway-api.yaml
[net-gateway-api-nightly-badge]: https://prow.knative.dev/badge.svg?jobs=nightly_net-gateway-api_main_periodic
[net-gateway-api-nightly-page]: https://prow.knative.dev?job=nightly_net-gateway-api_main_periodic
[net-gateway-api-prow-badge]: https://prow.knative.dev/badge.svg?jobs=release_net-gateway-api_main_periodic
[net-gateway-api-prow-job]: https://prow.knative.dev?job=release_net-gateway-api_main_periodic

[net-istio-version-badge]: https://img.shields.io/github/release-pre/knative-extensions/net-istio.svg?sort=semver
[net-istio-release-badge]: https://github.com/knative/release/actions/workflows/knative-extensions-net-istio.yaml/badge.svg
[net-istio-release-page]: https://github.com/knative-extensions/net-istio/releases
[net-istio-release-workflow]: https://github.com/knative/release/actions/workflows/knative-extensions-net-istio.yaml
[net-istio-nightly-badge]: https://prow.knative.dev/badge.svg?jobs=nightly_net-istio_main_periodic
[net-istio-nightly-page]: https://prow.knative.dev?job=nightly_net-istio_main_periodic
[net-istio-prow-badge]: https://prow.knative.dev/badge.svg?jobs=release_net-istio_main_periodic
[net-istio-prow-job]: https://prow.knative.dev?job=release_net-istio_main_periodic

[net-kourier-version-badge]: https://img.shields.io/github/release-pre/knative-extensions/net-kourier.svg?sort=semver
[net-kourier-release-badge]: https://github.com/knative/release/actions/workflows/knative-extensions-net-kourier.yaml/badge.svg
[net-kourier-release-page]: https://github.com/knative-extensions/net-kourier/releases
[net-kourier-release-workflow]: https://github.com/knative/release/actions/workflows/knative-extensions-net-kourier.yaml
[net-kourier-nightly-badge]: https://prow.knative.dev/badge.svg?jobs=nightly_net-kourier_main_periodic
[net-kourier-nightly-page]: https://prow.knative.dev?job=nightly_net-kourier_main_periodic
[net-kourier-prow-badge]: https://prow.knative.dev/badge.svg?jobs=release_net-kourier_main_periodic
[net-kourier-prow-job]: https://prow.knative.dev?job=release_net-kourier_main_periodic

[reconciler-test-version-badge]: https://img.shields.io/github/release-pre/knative-extensions/reconciler-test.svg?sort=semver
[reconciler-test-release-badge]: https://github.com/knative/release/actions/workflows/knative-extensions-reconciler-test.yaml/badge.svg
[reconciler-test-release-page]: https://github.com/knative-extensions/reconciler-test/releases
[reconciler-test-release-workflow]: https://github.com/knative/release/actions/workflows/knative-extensions-reconciler-test.yaml
[reconciler-test-nightly-badge]: https://prow.knative.dev/badge.svg?jobs=nightly_reconciler-test_main_periodic
[reconciler-test-nightly-page]: https://prow.knative.dev?job=nightly_reconciler-test_main_periodic
[reconciler-test-prow-badge]: https://prow.knative.dev/badge.svg?jobs=release_reconciler-test_main_periodic
[reconciler-test-prow-job]: https://prow.knative.dev?job=release_reconciler-test_main_periodic

[sample-controller-version-badge]: https://img.shields.io/github/release-pre/knative-extensions/sample-controller.svg?sort=semver
[sample-controller-release-badge]: https://github.com/knative/release/actions/workflows/knative-extensions-sample-controller.yaml/badge.svg
[sample-controller-release-page]: https://github.com/knative-extensions/sample-controller/releases
[sample-controller-release-workflow]: https://github.com/knative/release/actions/workflows/knative-extensions-sample-controller.yaml
[sample-controller-nightly-badge]: https://prow.knative.dev/badge.svg?jobs=nightly_sample-controller_main_periodic
[sample-controller-nightly-page]: https://prow.knative.dev?job=nightly_sample-controller_main_periodic
[sample-controller-prow-badge]: https://prow.knative.dev/badge.svg?jobs=release_sample-controller_main_periodic
[sample-controller-prow-job]: https://prow.knative.dev?job=release_sample-controller_main_periodic

[sample-source-version-badge]: https://img.shields.io/github/release-pre/knative-extensions/sample-source.svg?sort=semver
[sample-source-release-badge]: https://github.com/knative/release/actions/workflows/knative-extensions-sample-source.yaml/badge.svg
[sample-source-release-page]: https://github.com/knative-extensions/sample-source/releases
[sample-source-release-workflow]: https://github.com/knative/release/actions/workflows/knative-extensions-sample-source.yaml
[sample-source-nightly-badge]: https://prow.knative.dev/badge.svg?jobs=nightly_sample-source_main_periodic
[sample-source-nightly-page]: https://prow.knative.dev?job=nightly_sample-source_main_periodic
[sample-source-prow-badge]: https://prow.knative.dev/badge.svg?jobs=release_sample-source_main_periodic
[sample-source-prow-job]: https://prow.knative.dev?job=release_sample-source_main_periodic

<!-- autogen end -->
