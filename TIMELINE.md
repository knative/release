
# Timeline of a Knative release

We release each repository of `knative.dev` roughly every 3 months. Please check the [release schedule](README.md#release-schedule) to calculate when to start work on each checkpoint of a release timeline.

## Repos to be released
- All repos to be released are listed in this document
- Each repo indicates its releasability and other statuses, when applicable
- Each repo needs to be successfully updated to use the latest version of all dependencies **before** cutting its release branch

## Timeline
   - [T-minus 30 days](#t-minus-30-days)
   - [T-minus 14 days](#t-minus-14-days)
   - [T-minus 7 days](#t-minus-7-days)
   - [T-minus 1 day](#t-minus-1-day)
   - [T-minus zero - day of the release](#t-minus-zero---day-of-release)
   - [Post-release](#post-release)

## T-minus 30 days
- ✅ Open a [release checklist](https://github.com/knative/release/issues/new?assignees=knative/knative-release-leads&template=release-checklist.yaml) issue.
- 📝 See these instructions for further guidance:
  - [Permissions for release leads](PROCEDURES.md#permissions-for-release-leads).

## T-minus 14 days
- Ensure that the releasability defaults have been updated.
- 📝 See instructions for guidance on [updating the releasability defaults](PROCEDURES.md#updating-the-releasability-defaults).

## T-minus 7 days - releasing supporting repos
Cut the release branch of all the [supporting repos](#supporting-repos). These are the base repos where we have common code and common scripts.

- 📄 Open a new [release notes document](PROCEDURES.md#new-release-notes-document) for the release.
- 📣 Announce on the **#general** Slack channel that the release will be cut in a week and that additional caution should be used when merging big changes.
- 👀 Verify that the [nightly release automation](PROCEDURES.md#nightly-job) is passing for each of the core `knative.dev` repos. If any is failing, reach out to the corresponding WG leads and ask them to investigate. Repeat throughout the week.

🚨 **NOTES:**

- The release branch for each supporting repos must be done **only after** the branch for their dependencies is cut.

- After each repo's release branch is cut, a dependency update might be required for the next repo in the sequence. It is doubly important to have a successful [dependency check](PROCEDURES.md#dependency-check) and subsequently [verify its releasability](PROCEDURES.md#verifying-releasability) before proceeding to cut the branch.

- Automation will trigger all the downstream repos to update their dependencies to these new versions in the next few cycles. The goal is to have the first wave of repo releases (**serving**, **eventing**, etc) become "releasable" by the scheduled [day of release](#t-minus-zero---day-of-release). This is signaled via the reporting of the [releasability](PROCEDURES.md#releasability-check) status posted to the **release-`xdotx`** Slack channel every morning (5am PST, M-F).

### Supporting repos
📝 See instructions for guidance on [Releasing a repository](PROCEDURES.md#releasing-a-repository) and follow all the steps.

| Repo   | Releasability   |
| ---------------------- | ---------------------- |
| [knative.dev/hack](https://github.com/knative/hack) | N/A |
| [knative.dev/pkg](https://github.com/knative/pkg) | [![Releasability][pkg-release-badge]][pkg-release-workflow]|
| [knative.dev/networking](https://github.com/knative/networking) | [![Releasability][networking-release-badge]][networking-release-workflow] |
| [knative.dev/caching](https://github.com/knative/caching) | [![Releasability][caching-release-badge]][caching-release-workflow] |
| [knative.dev/reconciler-test](https://github.com/knative-sandbox/reconciler-test) | [![Releasability][reconciler-test-release-badge]][reconciler-test-release-workflow] |
| [knative.dev/control-protocol](https://github.com/knative-sandbox/control-protocol) | [![Releasability][control-protocol-release-badge]][control-protocol-release-workflow] |


## T-minus 1 day
🚨 **NOTE:** Continue to verify that the [nightly release automation](PROCEDURES.md#nightly-job) is passing for each `knative.dev` repo in the subsequent phases. If any is failing at this point, reach out to the corresponding WG leads and ask them to investigate. Repeat until all are passing.

## T-minus zero - day of release
The release of the core repos starts on the first day of the release schedule.

🚨 **NOTES:**

- It is not required that all repos in the included sub-sections be released on the same day the release is scheduled to start. The pipeline outlined below will take time to complete and it is ok for the release process to progress over days.

- An extra reminder to wait for the `knative.dev/eventing` and `knative.dev/serving` releases to be **published** before running a [dependency check](PROCEDURES.md#dependency-check) and subsequently [verifying releasability](PROCEDURES.md#verifying-releasability) on the repos that depend on these two packages. This will result in their `go.mod` correctly looking like, for example, `knative.dev/eventing v0.31.0`, instead of `knative.dev/eventing v0.30.1-0.20220419135228-39eef14419d8`.

- The release notes of a dependency are not a blocker for proceeding to cut a release for a repo.

### Exceptions
We have a few repos inside of Knative that are not handled in the standard release process at the moment. They might have additional dependencies or depend on the releases existing. **Skip these:**

| Repo   | Release   | Releasability   | Nightly   |
| ---------------------- | ---------------------- | ---------------------- | ---------------------- |
| [knative.dev/operator](https://github.com/knative/operator) | [![Releases][operator-version-badge]][operator-release-page] | [![Releasability][operator-release-badge]][operator-release-workflow] | [![Nightly][operator-nightly-badge]][operator-nightly-page] |

## T-minus zero - releasing core repos
📝 See instructions for guidance on [Releasing a repository](PROCEDURES.md#releasing-a-repository) and follow all the steps.

### This group can be started after all the supporting repos have been successfully released.

| Repo   | Release   | Releasability   | Nightly   |
| ---------------------- | ---------------------- | ---------------------- | ---------------------- |
| [knative.dev/serving](https://github.com/knative/serving) | [![Releases][serving-version-badge]][serving-release-page]  | [![Releasability][serving-release-badge]][serving-release-workflow]  | [![Nightly][serving-nightly-badge]][serving-nightly-page]  |
| [knative.dev/net-certmanager](https://github.com/knative-sandbox/net-certmanager) | [![Releases][net-certmanager-version-badge]][net-certmanager-release-page]  | [![Releasability][net-certmanager-release-badge]][net-certmanager-release-workflow]  | [![Nightly][net-certmanager-nightly-badge]][net-certmanager-nightly-page]  |
| [knative.dev/net-contour](https://github.com/knative-sandbox/net-contour) | [![Releases][net-contour-version-badge]][net-contour-release-page]  | [![Releasability][net-contour-release-badge]][net-contour-release-workflow]  | [![Nightly][net-contour-nightly-badge]][net-contour-nightly-page]  |
| [knative.dev/net-gateway-api](https://github.com/knative-sandbox/net-gateway-api) | [![Releases][net-gateway-api-version-badge]][net-gateway-api-release-page]  | [![Releasability][net-gateway-api-release-badge]][net-gateway-api-release-workflow]  | [![Nightly][net-gateway-api-nightly-badge]][net-gateway-api-nightly-page]  |
| [knative.dev/net-http01](https://github.com/knative-sandbox/net-http01) | [![Releases][net-http01-version-badge]][net-http01-release-page]  | [![Releasability][net-http01-release-badge]][net-http01-release-workflow]  | [![Nightly][net-http01-nightly-badge]][net-http01-nightly-page]  |
| [knative.dev/net-istio](https://github.com/knative-sandbox/net-istio) | [![Releases][net-istio-version-badge]][net-istio-release-page]  | [![Releasability][net-istio-release-badge]][net-istio-release-workflow]  | [![Nightly][net-istio-nightly-badge]][net-istio-nightly-page]  |
| [knative.dev/net-kourier](https://github.com/knative-sandbox/net-kourier) | [![Releases][net-kourier-version-badge]][net-kourier-release-page]  | [![Releasability][net-kourier-release-badge]][net-kourier-release-workflow]  | [![Nightly][net-kourier-nightly-badge]][net-kourier-nightly-page]  |
| [knative.dev/eventing](https://github.com/knative/eventing) | [![Releases][eventing-version-badge]][eventing-release-page]  | [![Releasability][eventing-release-badge]][eventing-release-workflow]  | [![Nightly][eventing-nightly-badge]][eventing-nightly-page]  |
| [knative.dev/sample-controller](https://github.com/knative-sandbox/sample-controller) | [![Releases][sample-controller-version-badge]][sample-controller-release-page]  | [![Releasability][sample-controller-release-badge]][sample-controller-release-workflow]  | [![Nightly][sample-controller-nightly-badge]][sample-controller-nightly-page]  |



### This group can be started after `knative.dev/eventing` has been successfully published.

| Repo   | Release   | Releasability   | Nightly   |
| ---------------------- | ---------------------- | ---------------------- | ---------------------- |
| [knative.dev/eventing-ceph](https://github.com/knative-sandbox/eventing-ceph) | [![Releases][eventing-ceph-version-badge]][eventing-ceph-release-page]  | [![Releasability][eventing-ceph-release-badge]][eventing-ceph-release-workflow]  | [![Nightly][eventing-ceph-nightly-badge]][eventing-ceph-nightly-page]  |
| [knative.dev/eventing-kogito](https://github.com/knative-sandbox/eventing-kogito) | [![Releases][eventing-kogito-version-badge]][eventing-kogito-release-page]  | [![Releasability][eventing-kogito-release-badge]][eventing-kogito-release-workflow]  | [![Nightly][eventing-kogito-nightly-badge]][eventing-kogito-nightly-page]  |
| [knative.dev/eventing-rabbitmq](https://github.com/knative-sandbox/eventing-rabbitmq) | [![Releases][eventing-rabbitmq-version-badge]][eventing-rabbitmq-release-page]  | [![Releasability][eventing-rabbitmq-release-badge]][eventing-rabbitmq-release-workflow]  | [![Nightly][eventing-rabbitmq-nightly-badge]][eventing-rabbitmq-nightly-page]  |
| [knative.dev/sample-source](https://github.com/knative-sandbox/sample-source) | [![Releases][sample-source-version-badge]][sample-source-release-page]  | [![Releasability][sample-source-release-badge]][sample-source-release-workflow]  | [![Nightly][sample-source-nightly-badge]][sample-source-nightly-page]  |



### This group can be started after both `knative.dev/eventing` and `knative.dev/serving` have been successfully published.

Note that `client-pkg` is a supporting library and thus does **NOT** have a release job on Prow.

| Repo   | Release   | Releasability   | Nightly   |
| ---------------------- | ---------------------- | ---------------------- | ---------------------- |
| [knative.dev/client-pkg](https://github.com/knative/client-pkg) | n/a  | [![Releasability][client-pkg-release-badge]][client-pkg-release-workflow]  | n/a


### This group can be started after `knative.dev/client-pkg` has been successfully cut.

| Repo   | Release   | Releasability   | Nightly   |
| ---------------------- | ---------------------- | ---------------------- | ---------------------- |
| [knative.dev/client](https://github.com/knative/client) | [![Releases][client-version-badge]][client-release-page]  | [![Releasability][client-release-badge]][client-release-workflow]  | [![Nightly][client-nightly-badge]][client-nightly-page]  |
| [knative.dev/eventing-kafka](https://github.com/knative-sandbox/eventing-kafka) | [![Releases][eventing-kafka-version-badge]][eventing-kafka-release-page]  | [![Releasability][eventing-kafka-release-badge]][eventing-kafka-release-workflow]  | [![Nightly][eventing-kafka-nightly-badge]][eventing-kafka-nightly-page]  |
| [knative.dev/eventing-redis](https://github.com/knative-sandbox/eventing-redis) | [![Releases][eventing-redis-version-badge]][eventing-redis-release-page]  | [![Releasability][eventing-redis-release-badge]][eventing-redis-release-workflow]  | [![Nightly][eventing-redis-nightly-badge]][eventing-redis-nightly-page]  |
| [knative.dev/eventing-github](https://github.com/knative-sandbox/eventing-github) | [![Releases][eventing-github-version-badge]][eventing-github-release-page]  | [![Releasability][eventing-github-release-badge]][eventing-github-release-workflow]  | [![Nightly][eventing-github-nightly-badge]][eventing-github-nightly-page]  |
| [knative.dev/eventing-gitlab](https://github.com/knative-sandbox/eventing-gitlab) | [![Releases][eventing-gitlab-version-badge]][eventing-gitlab-release-page]  | [![Releasability][eventing-gitlab-release-badge]][eventing-gitlab-release-workflow]  | [![Nightly][eventing-gitlab-nightly-badge]][eventing-gitlab-nightly-page]  |


### This group can be started after all the previous repos have been successfully published.

| Repo   | Release   | Releasability   | Nightly   |
| ---------------------- | ---------------------- | ---------------------- | ---------------------- |
| [knative.dev/eventing-kafka-broker](https://github.com/knative-sandbox/eventing-kafka-broker) | [![Releases][eventing-kafka-broker-version-badge]][eventing-kafka-broker-release-page]  | [![Releasability][eventing-kafka-broker-release-badge]][eventing-kafka-broker-release-workflow]  | [![Nightly][eventing-kafka-broker-nightly-badge]][eventing-kafka-broker-nightly-page]  |
| [knative.dev/eventing-autoscaler-keda](https://github.com/knative-sandbox/eventing-autoscaler-keda) | [![Releases][eventing-autoscaler-keda-version-badge]][eventing-autoscaler-keda-release-page]  | [![Releasability][eventing-autoscaler-keda-release-badge]][eventing-autoscaler-keda-release-workflow]  | [![Nightly][eventing-autoscaler-keda-nightly-badge]][eventing-autoscaler-keda-nightly-page]  |
| [knative.dev/kn-plugin-admin](https://github.com/knative-sandbox/kn-plugin-admin) | [![Releases][kn-plugin-admin-version-badge]][kn-plugin-admin-release-page]  | [![Releasability][kn-plugin-admin-release-badge]][kn-plugin-admin-release-workflow]  | [![Nightly][kn-plugin-admin-nightly-badge]][kn-plugin-admin-nightly-page]  |
| [knative.dev/kn-plugin-event](https://github.com/knative-sandbox/kn-plugin-event) | [![Releases][kn-plugin-event-version-badge]][kn-plugin-event-release-page]  | [![Releasability][kn-plugin-event-release-badge]][kn-plugin-event-release-workflow]  | [![Nightly][kn-plugin-event-nightly-badge]][kn-plugin-event-nightly-page]  |
| [knative.dev/kn-plugin-source-kafka](https://github.com/knative-sandbox/kn-plugin-source-kafka) | [![Releases][kn-plugin-source-kafka-version-badge]][kn-plugin-source-kafka-release-page]  | [![Releasability][kn-plugin-source-kafka-release-badge]][kn-plugin-source-kafka-release-workflow]  | [![Nightly][kn-plugin-source-kafka-nightly-badge]][kn-plugin-source-kafka-nightly-page]  |
| [knative.dev/kn-plugin-source-kamelet](https://github.com/knative-sandbox/kn-plugin-source-kamelet) | [![Releases][kn-plugin-source-kamelet-version-badge]][kn-plugin-source-kamelet-release-page]  | [![Releasability][kn-plugin-source-kamelet-release-badge]][kn-plugin-source-kamelet-release-workflow]  | [![Nightly][kn-plugin-source-kamelet-nightly-badge]][kn-plugin-source-kamelet-nightly-page]  |
| [knative.dev/kn-plugin-quickstart](https://github.com/knative-sandbox/kn-plugin-quickstart) | [![Releases][kn-plugin-quickstart-version-badge]][kn-plugin-quickstart-release-page]  | [![Releasability][kn-plugin-quickstart-release-badge]][kn-plugin-quickstart-release-workflow]  | [![Nightly][kn-plugin-quickstart-nightly-badge]][kn-plugin-quickstart-nightly-page]  |
| [knative.dev/func](https://github.com/knative/func) | [![Releases][func-version-badge]][func-release-page]  | [![Releasability][func-release-badge]][func-release-workflow]  | [![Nightly][func-nightly-badge]][func-nightly-page]  |


## Post-release
📝 See these instructions for further guidance:

- [Releasing a new version of the Knative documentation](PROCEDURES.md#releasing-a-new-version-of-the-knative-documentation).
- [Homebrew updates](PROCEDURES.md#homebrew-updates).
- [Updating the release schedule](PROCEDURES.md#updating-the-release-schedule).
- [Bump dependencies in auto-update job](PROCEDURES.md#bump-dependencies-in-auto-update-job).


<!-- autogen start -->
[caching-version-badge]: https://img.shields.io/github/release-pre/knative/caching.svg?sort=semver
[caching-release-badge]: https://github.com/knative/release/workflows/knative/caching/badge.svg
[caching-release-page]: https://github.com/knative/caching/releases
[caching-release-workflow]: https://github.com/knative/release/actions/workflows/knative-caching.yaml
[caching-nightly-badge]: https://prow.knative.dev/badge.svg?jobs=nightly_caching_main_periodic
[caching-nightly-page]: https://prow.knative.dev?job=nightly_caching_main_periodic

[client-version-badge]: https://img.shields.io/github/release-pre/knative/client.svg?sort=semver
[client-release-badge]: https://github.com/knative/release/workflows/knative/client/badge.svg
[client-release-page]: https://github.com/knative/client/releases
[client-release-workflow]: https://github.com/knative/release/actions/workflows/knative-client.yaml
[client-nightly-badge]: https://prow.knative.dev/badge.svg?jobs=nightly_client_main_periodic
[client-nightly-page]: https://prow.knative.dev?job=nightly_client_main_periodic

[client-pkg-version-badge]: https://img.shields.io/github/release-pre/knative/client-pkg.svg?sort=semver
[client-pkg-release-badge]: https://github.com/knative/release/workflows/knative/client-pkg/badge.svg
[client-pkg-release-page]: https://github.com/knative/client-pkg/releases
[client-pkg-release-workflow]: https://github.com/knative/release/actions/workflows/knative-client-pkg.yaml
[client-pkg-nightly-badge]: https://prow.knative.dev/badge.svg?jobs=nightly_client-pkg_main_periodic
[client-pkg-nightly-page]: https://prow.knative.dev?job=nightly_client-pkg_main_periodic

[eventing-version-badge]: https://img.shields.io/github/release-pre/knative/eventing.svg?sort=semver
[eventing-release-badge]: https://github.com/knative/release/workflows/knative/eventing/badge.svg
[eventing-release-page]: https://github.com/knative/eventing/releases
[eventing-release-workflow]: https://github.com/knative/release/actions/workflows/knative-eventing.yaml
[eventing-nightly-badge]: https://prow.knative.dev/badge.svg?jobs=nightly_eventing_main_periodic
[eventing-nightly-page]: https://prow.knative.dev?job=nightly_eventing_main_periodic

[func-version-badge]: https://img.shields.io/github/release-pre/knative/func.svg?sort=semver
[func-release-badge]: https://github.com/knative/release/workflows/knative/func/badge.svg
[func-release-page]: https://github.com/knative/func/releases
[func-release-workflow]: https://github.com/knative/release/actions/workflows/knative-func.yaml
[func-nightly-badge]: https://prow.knative.dev/badge.svg?jobs=nightly_func_main_periodic
[func-nightly-page]: https://prow.knative.dev?job=nightly_func_main_periodic

[networking-version-badge]: https://img.shields.io/github/release-pre/knative/networking.svg?sort=semver
[networking-release-badge]: https://github.com/knative/release/workflows/knative/networking/badge.svg
[networking-release-page]: https://github.com/knative/networking/releases
[networking-release-workflow]: https://github.com/knative/release/actions/workflows/knative-networking.yaml
[networking-nightly-badge]: https://prow.knative.dev/badge.svg?jobs=nightly_networking_main_periodic
[networking-nightly-page]: https://prow.knative.dev?job=nightly_networking_main_periodic

[pkg-version-badge]: https://img.shields.io/github/release-pre/knative/pkg.svg?sort=semver
[pkg-release-badge]: https://github.com/knative/release/workflows/knative/pkg/badge.svg
[pkg-release-page]: https://github.com/knative/pkg/releases
[pkg-release-workflow]: https://github.com/knative/release/actions/workflows/knative-pkg.yaml
[pkg-nightly-badge]: https://prow.knative.dev/badge.svg?jobs=nightly_pkg_main_periodic
[pkg-nightly-page]: https://prow.knative.dev?job=nightly_pkg_main_periodic

[serving-version-badge]: https://img.shields.io/github/release-pre/knative/serving.svg?sort=semver
[serving-release-badge]: https://github.com/knative/release/workflows/knative/serving/badge.svg
[serving-release-page]: https://github.com/knative/serving/releases
[serving-release-workflow]: https://github.com/knative/release/actions/workflows/knative-serving.yaml
[serving-nightly-badge]: https://prow.knative.dev/badge.svg?jobs=nightly_serving_main_periodic
[serving-nightly-page]: https://prow.knative.dev?job=nightly_serving_main_periodic

[operator-version-badge]: https://img.shields.io/github/release-pre/knative/operator.svg?sort=semver
[operator-release-badge]: https://github.com/knative/release/workflows/knative/operator/badge.svg
[operator-release-page]: https://github.com/knative/operator/releases
[operator-release-workflow]: https://github.com/knative/release/actions/workflows/knative-operator.yaml
[operator-nightly-badge]: https://prow.knative.dev/badge.svg?jobs=nightly_operator_main_periodic
[operator-nightly-page]: https://prow.knative.dev?job=nightly_operator_main_periodic

[control-protocol-version-badge]: https://img.shields.io/github/release-pre/knative-sandbox/control-protocol.svg?sort=semver
[control-protocol-release-badge]: https://github.com/knative/release/workflows/knative-sandbox/control-protocol/badge.svg
[control-protocol-release-page]: https://github.com/knative-sandbox/control-protocol/releases
[control-protocol-release-workflow]: https://github.com/knative/release/actions/workflows/knative-sandbox-control-protocol.yaml
[control-protocol-nightly-badge]: https://prow.knative.dev/badge.svg?jobs=nightly_control-protocol_main_periodic
[control-protocol-nightly-page]: https://prow.knative.dev?job=nightly_control-protocol_main_periodic

[eventing-autoscaler-keda-version-badge]: https://img.shields.io/github/release-pre/knative-sandbox/eventing-autoscaler-keda.svg?sort=semver
[eventing-autoscaler-keda-release-badge]: https://github.com/knative/release/workflows/knative-sandbox/eventing-autoscaler-keda/badge.svg
[eventing-autoscaler-keda-release-page]: https://github.com/knative-sandbox/eventing-autoscaler-keda/releases
[eventing-autoscaler-keda-release-workflow]: https://github.com/knative/release/actions/workflows/knative-sandbox-eventing-autoscaler-keda.yaml
[eventing-autoscaler-keda-nightly-badge]: https://prow.knative.dev/badge.svg?jobs=nightly_eventing-autoscaler-keda_main_periodic
[eventing-autoscaler-keda-nightly-page]: https://prow.knative.dev?job=nightly_eventing-autoscaler-keda_main_periodic

[eventing-ceph-version-badge]: https://img.shields.io/github/release-pre/knative-sandbox/eventing-ceph.svg?sort=semver
[eventing-ceph-release-badge]: https://github.com/knative/release/workflows/knative-sandbox/eventing-ceph/badge.svg
[eventing-ceph-release-page]: https://github.com/knative-sandbox/eventing-ceph/releases
[eventing-ceph-release-workflow]: https://github.com/knative/release/actions/workflows/knative-sandbox-eventing-ceph.yaml
[eventing-ceph-nightly-badge]: https://prow.knative.dev/badge.svg?jobs=nightly_eventing-ceph_main_periodic
[eventing-ceph-nightly-page]: https://prow.knative.dev?job=nightly_eventing-ceph_main_periodic

[eventing-github-version-badge]: https://img.shields.io/github/release-pre/knative-sandbox/eventing-github.svg?sort=semver
[eventing-github-release-badge]: https://github.com/knative/release/workflows/knative-sandbox/eventing-github/badge.svg
[eventing-github-release-page]: https://github.com/knative-sandbox/eventing-github/releases
[eventing-github-release-workflow]: https://github.com/knative/release/actions/workflows/knative-sandbox-eventing-github.yaml
[eventing-github-nightly-badge]: https://prow.knative.dev/badge.svg?jobs=nightly_eventing-github_main_periodic
[eventing-github-nightly-page]: https://prow.knative.dev?job=nightly_eventing-github_main_periodic

[eventing-gitlab-version-badge]: https://img.shields.io/github/release-pre/knative-sandbox/eventing-gitlab.svg?sort=semver
[eventing-gitlab-release-badge]: https://github.com/knative/release/workflows/knative-sandbox/eventing-gitlab/badge.svg
[eventing-gitlab-release-page]: https://github.com/knative-sandbox/eventing-gitlab/releases
[eventing-gitlab-release-workflow]: https://github.com/knative/release/actions/workflows/knative-sandbox-eventing-gitlab.yaml
[eventing-gitlab-nightly-badge]: https://prow.knative.dev/badge.svg?jobs=nightly_eventing-gitlab_main_periodic
[eventing-gitlab-nightly-page]: https://prow.knative.dev?job=nightly_eventing-gitlab_main_periodic

[eventing-kafka-version-badge]: https://img.shields.io/github/release-pre/knative-sandbox/eventing-kafka.svg?sort=semver
[eventing-kafka-release-badge]: https://github.com/knative/release/workflows/knative-sandbox/eventing-kafka/badge.svg
[eventing-kafka-release-page]: https://github.com/knative-sandbox/eventing-kafka/releases
[eventing-kafka-release-workflow]: https://github.com/knative/release/actions/workflows/knative-sandbox-eventing-kafka.yaml
[eventing-kafka-nightly-badge]: https://prow.knative.dev/badge.svg?jobs=nightly_eventing-kafka_main_periodic
[eventing-kafka-nightly-page]: https://prow.knative.dev?job=nightly_eventing-kafka_main_periodic

[eventing-kafka-broker-version-badge]: https://img.shields.io/github/release-pre/knative-sandbox/eventing-kafka-broker.svg?sort=semver
[eventing-kafka-broker-release-badge]: https://github.com/knative/release/workflows/knative-sandbox/eventing-kafka-broker/badge.svg
[eventing-kafka-broker-release-page]: https://github.com/knative-sandbox/eventing-kafka-broker/releases
[eventing-kafka-broker-release-workflow]: https://github.com/knative/release/actions/workflows/knative-sandbox-eventing-kafka-broker.yaml
[eventing-kafka-broker-nightly-badge]: https://prow.knative.dev/badge.svg?jobs=nightly_eventing-kafka-broker_main_periodic
[eventing-kafka-broker-nightly-page]: https://prow.knative.dev?job=nightly_eventing-kafka-broker_main_periodic

[eventing-kogito-version-badge]: https://img.shields.io/github/release-pre/knative-sandbox/eventing-kogito.svg?sort=semver
[eventing-kogito-release-badge]: https://github.com/knative/release/workflows/knative-sandbox/eventing-kogito/badge.svg
[eventing-kogito-release-page]: https://github.com/knative-sandbox/eventing-kogito/releases
[eventing-kogito-release-workflow]: https://github.com/knative/release/actions/workflows/knative-sandbox-eventing-kogito.yaml
[eventing-kogito-nightly-badge]: https://prow.knative.dev/badge.svg?jobs=nightly_eventing-kogito_main_periodic
[eventing-kogito-nightly-page]: https://prow.knative.dev?job=nightly_eventing-kogito_main_periodic

[eventing-rabbitmq-version-badge]: https://img.shields.io/github/release-pre/knative-sandbox/eventing-rabbitmq.svg?sort=semver
[eventing-rabbitmq-release-badge]: https://github.com/knative/release/workflows/knative-sandbox/eventing-rabbitmq/badge.svg
[eventing-rabbitmq-release-page]: https://github.com/knative-sandbox/eventing-rabbitmq/releases
[eventing-rabbitmq-release-workflow]: https://github.com/knative/release/actions/workflows/knative-sandbox-eventing-rabbitmq.yaml
[eventing-rabbitmq-nightly-badge]: https://prow.knative.dev/badge.svg?jobs=nightly_eventing-rabbitmq_main_periodic
[eventing-rabbitmq-nightly-page]: https://prow.knative.dev?job=nightly_eventing-rabbitmq_main_periodic

[eventing-redis-version-badge]: https://img.shields.io/github/release-pre/knative-sandbox/eventing-redis.svg?sort=semver
[eventing-redis-release-badge]: https://github.com/knative/release/workflows/knative-sandbox/eventing-redis/badge.svg
[eventing-redis-release-page]: https://github.com/knative-sandbox/eventing-redis/releases
[eventing-redis-release-workflow]: https://github.com/knative/release/actions/workflows/knative-sandbox-eventing-redis.yaml
[eventing-redis-nightly-badge]: https://prow.knative.dev/badge.svg?jobs=nightly_eventing-redis_main_periodic
[eventing-redis-nightly-page]: https://prow.knative.dev?job=nightly_eventing-redis_main_periodic

[kn-plugin-admin-version-badge]: https://img.shields.io/github/release-pre/knative-sandbox/kn-plugin-admin.svg?sort=semver
[kn-plugin-admin-release-badge]: https://github.com/knative/release/workflows/knative-sandbox/kn-plugin-admin/badge.svg
[kn-plugin-admin-release-page]: https://github.com/knative-sandbox/kn-plugin-admin/releases
[kn-plugin-admin-release-workflow]: https://github.com/knative/release/actions/workflows/knative-sandbox-kn-plugin-admin.yaml
[kn-plugin-admin-nightly-badge]: https://prow.knative.dev/badge.svg?jobs=nightly_kn-plugin-admin_main_periodic
[kn-plugin-admin-nightly-page]: https://prow.knative.dev?job=nightly_kn-plugin-admin_main_periodic

[kn-plugin-event-version-badge]: https://img.shields.io/github/release-pre/knative-sandbox/kn-plugin-event.svg?sort=semver
[kn-plugin-event-release-badge]: https://github.com/knative/release/workflows/knative-sandbox/kn-plugin-event/badge.svg
[kn-plugin-event-release-page]: https://github.com/knative-sandbox/kn-plugin-event/releases
[kn-plugin-event-release-workflow]: https://github.com/knative/release/actions/workflows/knative-sandbox-kn-plugin-event.yaml
[kn-plugin-event-nightly-badge]: https://prow.knative.dev/badge.svg?jobs=nightly_kn-plugin-event_main_periodic
[kn-plugin-event-nightly-page]: https://prow.knative.dev?job=nightly_kn-plugin-event_main_periodic

[kn-plugin-quickstart-version-badge]: https://img.shields.io/github/release-pre/knative-sandbox/kn-plugin-quickstart.svg?sort=semver
[kn-plugin-quickstart-release-badge]: https://github.com/knative/release/workflows/knative-sandbox/kn-plugin-quickstart/badge.svg
[kn-plugin-quickstart-release-page]: https://github.com/knative-sandbox/kn-plugin-quickstart/releases
[kn-plugin-quickstart-release-workflow]: https://github.com/knative/release/actions/workflows/knative-sandbox-kn-plugin-quickstart.yaml
[kn-plugin-quickstart-nightly-badge]: https://prow.knative.dev/badge.svg?jobs=nightly_kn-plugin-quickstart_main_periodic
[kn-plugin-quickstart-nightly-page]: https://prow.knative.dev?job=nightly_kn-plugin-quickstart_main_periodic

[kn-plugin-source-kafka-version-badge]: https://img.shields.io/github/release-pre/knative-sandbox/kn-plugin-source-kafka.svg?sort=semver
[kn-plugin-source-kafka-release-badge]: https://github.com/knative/release/workflows/knative-sandbox/kn-plugin-source-kafka/badge.svg
[kn-plugin-source-kafka-release-page]: https://github.com/knative-sandbox/kn-plugin-source-kafka/releases
[kn-plugin-source-kafka-release-workflow]: https://github.com/knative/release/actions/workflows/knative-sandbox-kn-plugin-source-kafka.yaml
[kn-plugin-source-kafka-nightly-badge]: https://prow.knative.dev/badge.svg?jobs=nightly_kn-plugin-source-kafka_main_periodic
[kn-plugin-source-kafka-nightly-page]: https://prow.knative.dev?job=nightly_kn-plugin-source-kafka_main_periodic

[kn-plugin-source-kamelet-version-badge]: https://img.shields.io/github/release-pre/knative-sandbox/kn-plugin-source-kamelet.svg?sort=semver
[kn-plugin-source-kamelet-release-badge]: https://github.com/knative/release/workflows/knative-sandbox/kn-plugin-source-kamelet/badge.svg
[kn-plugin-source-kamelet-release-page]: https://github.com/knative-sandbox/kn-plugin-source-kamelet/releases
[kn-plugin-source-kamelet-release-workflow]: https://github.com/knative/release/actions/workflows/knative-sandbox-kn-plugin-source-kamelet.yaml
[kn-plugin-source-kamelet-nightly-badge]: https://prow.knative.dev/badge.svg?jobs=nightly_kn-plugin-source-kamelet_main_periodic
[kn-plugin-source-kamelet-nightly-page]: https://prow.knative.dev?job=nightly_kn-plugin-source-kamelet_main_periodic

[net-certmanager-version-badge]: https://img.shields.io/github/release-pre/knative-sandbox/net-certmanager.svg?sort=semver
[net-certmanager-release-badge]: https://github.com/knative/release/workflows/knative-sandbox/net-certmanager/badge.svg
[net-certmanager-release-page]: https://github.com/knative-sandbox/net-certmanager/releases
[net-certmanager-release-workflow]: https://github.com/knative/release/actions/workflows/knative-sandbox-net-certmanager.yaml
[net-certmanager-nightly-badge]: https://prow.knative.dev/badge.svg?jobs=nightly_net-certmanager_main_periodic
[net-certmanager-nightly-page]: https://prow.knative.dev?job=nightly_net-certmanager_main_periodic

[net-contour-version-badge]: https://img.shields.io/github/release-pre/knative-sandbox/net-contour.svg?sort=semver
[net-contour-release-badge]: https://github.com/knative/release/workflows/knative-sandbox/net-contour/badge.svg
[net-contour-release-page]: https://github.com/knative-sandbox/net-contour/releases
[net-contour-release-workflow]: https://github.com/knative/release/actions/workflows/knative-sandbox-net-contour.yaml
[net-contour-nightly-badge]: https://prow.knative.dev/badge.svg?jobs=nightly_net-contour_main_periodic
[net-contour-nightly-page]: https://prow.knative.dev?job=nightly_net-contour_main_periodic

[net-gateway-api-version-badge]: https://img.shields.io/github/release-pre/knative-sandbox/net-gateway-api.svg?sort=semver
[net-gateway-api-release-badge]: https://github.com/knative/release/workflows/knative-sandbox/net-gateway-api/badge.svg
[net-gateway-api-release-page]: https://github.com/knative-sandbox/net-gateway-api/releases
[net-gateway-api-release-workflow]: https://github.com/knative/release/actions/workflows/knative-sandbox-net-gateway-api.yaml
[net-gateway-api-nightly-badge]: https://prow.knative.dev/badge.svg?jobs=nightly_net-gateway-api_main_periodic
[net-gateway-api-nightly-page]: https://prow.knative.dev?job=nightly_net-gateway-api_main_periodic

[net-http01-version-badge]: https://img.shields.io/github/release-pre/knative-sandbox/net-http01.svg?sort=semver
[net-http01-release-badge]: https://github.com/knative/release/workflows/knative-sandbox/net-http01/badge.svg
[net-http01-release-page]: https://github.com/knative-sandbox/net-http01/releases
[net-http01-release-workflow]: https://github.com/knative/release/actions/workflows/knative-sandbox-net-http01.yaml
[net-http01-nightly-badge]: https://prow.knative.dev/badge.svg?jobs=nightly_net-http01_main_periodic
[net-http01-nightly-page]: https://prow.knative.dev?job=nightly_net-http01_main_periodic

[net-istio-version-badge]: https://img.shields.io/github/release-pre/knative-sandbox/net-istio.svg?sort=semver
[net-istio-release-badge]: https://github.com/knative/release/workflows/knative-sandbox/net-istio/badge.svg
[net-istio-release-page]: https://github.com/knative-sandbox/net-istio/releases
[net-istio-release-workflow]: https://github.com/knative/release/actions/workflows/knative-sandbox-net-istio.yaml
[net-istio-nightly-badge]: https://prow.knative.dev/badge.svg?jobs=nightly_net-istio_main_periodic
[net-istio-nightly-page]: https://prow.knative.dev?job=nightly_net-istio_main_periodic

[net-kourier-version-badge]: https://img.shields.io/github/release-pre/knative-sandbox/net-kourier.svg?sort=semver
[net-kourier-release-badge]: https://github.com/knative/release/workflows/knative-sandbox/net-kourier/badge.svg
[net-kourier-release-page]: https://github.com/knative-sandbox/net-kourier/releases
[net-kourier-release-workflow]: https://github.com/knative/release/actions/workflows/knative-sandbox-net-kourier.yaml
[net-kourier-nightly-badge]: https://prow.knative.dev/badge.svg?jobs=nightly_net-kourier_main_periodic
[net-kourier-nightly-page]: https://prow.knative.dev?job=nightly_net-kourier_main_periodic

[reconciler-test-version-badge]: https://img.shields.io/github/release-pre/knative-sandbox/reconciler-test.svg?sort=semver
[reconciler-test-release-badge]: https://github.com/knative/release/workflows/knative-sandbox/reconciler-test/badge.svg
[reconciler-test-release-page]: https://github.com/knative-sandbox/reconciler-test/releases
[reconciler-test-release-workflow]: https://github.com/knative/release/actions/workflows/knative-sandbox-reconciler-test.yaml
[reconciler-test-nightly-badge]: https://prow.knative.dev/badge.svg?jobs=nightly_reconciler-test_main_periodic
[reconciler-test-nightly-page]: https://prow.knative.dev?job=nightly_reconciler-test_main_periodic

[sample-controller-version-badge]: https://img.shields.io/github/release-pre/knative-sandbox/sample-controller.svg?sort=semver
[sample-controller-release-badge]: https://github.com/knative/release/workflows/knative-sandbox/sample-controller/badge.svg
[sample-controller-release-page]: https://github.com/knative-sandbox/sample-controller/releases
[sample-controller-release-workflow]: https://github.com/knative/release/actions/workflows/knative-sandbox-sample-controller.yaml
[sample-controller-nightly-badge]: https://prow.knative.dev/badge.svg?jobs=nightly_sample-controller_main_periodic
[sample-controller-nightly-page]: https://prow.knative.dev?job=nightly_sample-controller_main_periodic

[sample-source-version-badge]: https://img.shields.io/github/release-pre/knative-sandbox/sample-source.svg?sort=semver
[sample-source-release-badge]: https://github.com/knative/release/workflows/knative-sandbox/sample-source/badge.svg
[sample-source-release-page]: https://github.com/knative-sandbox/sample-source/releases
[sample-source-release-workflow]: https://github.com/knative/release/actions/workflows/knative-sandbox-sample-source.yaml
[sample-source-nightly-badge]: https://prow.knative.dev/badge.svg?jobs=nightly_sample-source_main_periodic
[sample-source-nightly-page]: https://prow.knative.dev?job=nightly_sample-source_main_periodic

<!-- autogen end -->
