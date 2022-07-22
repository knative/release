
# Timeline of a Knative release

We release each repository of `knative.dev` every 6 weeks. Please check the [release schedule](README.md#release-schedule) to calculate when to start work on each checkpoint of a release timeline.

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
  - [Creating a release Slack channel](PROCEDURES.md#creating-a-release-slack-channel).
  - [Bump dependencies in auto-update job](PROCEDURES.md#bump-dependencies-in-auto-update-job).

## T-minus 14 days
- Ensure that the releasability defaults have been updated and propagated.
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
| [knative.dev/pkg](https://github.com/knative/pkg) | [![Releasability](https://github.com/knative/pkg/workflows/Releasability/badge.svg)](https://github.com/knative/pkg/actions/workflows/knative-releasability.yaml) |
| [knative.dev/networking](https://github.com/knative/networking) | [![Releasability](https://github.com/knative/networking/workflows/Releasability/badge.svg)](https://github.com/knative/networking/actions/workflows/knative-releasability.yaml) |
| [knative.dev/caching](https://github.com/knative/caching) | [![Releasability](https://github.com/knative/caching/workflows/Releasability/badge.svg)](https://github.com/knative/caching/actions/workflows/knative-releasability.yaml) |
| [knative.dev/reconciler-test](https://github.com/knative-sandbox/reconciler-test) | [![Releasability](https://github.com/knative-sandbox/reconciler-test/workflows/Releasability/badge.svg)](https://github.com/knative-sandbox/reconciler-test/actions/workflows/knative-releasability.yaml) |
| [knative.dev/control-protocol](https://github.com/knative-sandbox/control-protocol) | [![Releasability](https://github.com/knative-sandbox/control-protocol/workflows/Releasability/badge.svg)](https://github.com/knative-sandbox/control-protocol/actions/workflows/knative-releasability.yaml) |


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
| [knative.dev/operator](https://github.com/knative/operator) | [![Releases](https://img.shields.io/github/release-pre/knative/operator.svg?sort=semver)](https://github.com/knative/operator/releases) | [![Releasability](https://github.com/knative/operator/workflows/Releasability/badge.svg)](https://github.com/knative/operator/actions/workflows/knative-releasability.yaml) | [![Nightly](https://prow.knative.dev/badge.svg?jobs=nightly_operator_main_periodic)](https://prow.knative.dev?job=nightly_operator_main_periodic) |

## T-minus zero - releasing core repos
📝 See instructions for guidance on [Releasing a repository](PROCEDURES.md#releasing-a-repository) and follow all the steps.

### This group can be started after all the supporting repos have been successfully released.

| Repo   | Release   | Releasability   | Nightly   |
| ---------------------- | ---------------------- | ---------------------- | ---------------------- |
| [knative.dev/serving](https://github.com/knative/serving) | [![Releases](https://img.shields.io/github/release-pre/knative/serving.svg?sort=semver)](https://github.com/knative/serving/releases)   | [![Releasability](https://github.com/knative/serving/workflows/Releasability/badge.svg)](https://github.com/knative/serving/actions/workflows/knative-releasability.yaml)  | [![Nightly](https://prow.knative.dev/badge.svg?jobs=nightly_serving_main_periodic)](https://prow.knative.dev?job=nightly_serving_main_periodic)  |
| [knative.dev/net-certmanager](https://github.com/knative-sandbox/net-certmanager) | [![Releases](https://img.shields.io/github/release-pre/knative-sandbox/net-certmanager.svg?sort=semver)](https://github.com/knative-sandbox/net-certmanager/releases) | [![Releasability](https://github.com/knative-sandbox/net-certmanager/workflows/Releasability/badge.svg)](https://github.com/knative-sandbox/net-certmanager/actions/workflows/knative-releasability.yaml)   | [![Nightly](https://prow.knative.dev/badge.svg?jobs=nightly_net-certmanager_main_periodic)](https://prow.knative.dev?job=nightly_net-certmanager_main_periodic)  |
| [knative.dev/net-contour](https://github.com/knative-sandbox/net-contour)   | [![Releases](https://img.shields.io/github/release-pre/knative-sandbox/net-contour.svg?sort=semver)](https://github.com/knative-sandbox/net-contour/releases)   | [![Releasability](https://github.com/knative-sandbox/net-contour/workflows/Releasability/badge.svg)](https://github.com/knative-sandbox/net-contour/actions/workflows/knative-releasability.yaml)  | [![Nightly](https://prow.knative.dev/badge.svg?jobs=nightly_net-contour_main_periodic)](https://prow.knative.dev?job=nightly_net-contour_main_periodic) |
| [knative.dev/net-http01](https://github.com/knative-sandbox/net-http01)  | [![Releases](https://img.shields.io/github/release-pre/knative-sandbox/net-http01.svg?sort=semver)](https://github.com/knative-sandbox/net-http01/releases)  | [![Releasability](https://github.com/knative-sandbox/net-http01/workflows/Releasability/badge.svg)](https://github.com/knative-sandbox/net-http01/actions/workflows/knative-releasability.yaml) | [![Nightly](https://prow.knative.dev/badge.svg?jobs=nightly_net-http01_main_periodic)](https://prow.knative.dev?job=nightly_net-http01_main_periodic)   |
| [knative.dev/net-istio](https://github.com/knative-sandbox/net-istio) | [![Releases](https://img.shields.io/github/release-pre/knative-sandbox/net-istio.svg?sort=semver)](https://github.com/knative-sandbox/net-istio/releases) | [![Releasability](https://github.com/knative-sandbox/net-istio/workflows/Releasability/badge.svg)](https://github.com/knative-sandbox/net-istio/actions/workflows/knative-releasability.yaml)   | [![Nightly](https://prow.knative.dev/badge.svg?jobs=nightly_net-istio_main_periodic)](https://prow.knative.dev?job=nightly_net-istio_main_periodic)  |
| [knative.dev/net-kourier](https://github.com/knative-sandbox/net-kourier)   | [![Releases](https://img.shields.io/github/release-pre/knative-sandbox/net-kourier.svg?sort=semver)](https://github.com/knative-sandbox/net-kourier/releases)   | [![Releasability](https://github.com/knative-sandbox/net-kourier/workflows/Releasability/badge.svg)](https://github.com/knative-sandbox/net-kourier/actions/workflows/knative-releasability.yaml)  | [![Nightly](https://prow.knative.dev/badge.svg?jobs=nightly_net-kourier_main_periodic)](https://prow.knative.dev?job=nightly_net-kourier_main_periodic) |
| [knative.dev/net-gateway-api](https://github.com/knative-sandbox/net-gateway-api) | [![Releases](https://img.shields.io/github/release-pre/knative-sandbox/net-gateway-api.svg?sort=semver)](https://github.com/knative-sandbox/net-gateway-api/releases) | [![Releasability](https://github.com/knative-sandbox/net-gateway-api/workflows/Releasability/badge.svg)](https://github.com/knative-sandbox/net-gateway-api/actions/workflows/knative-releasability.yaml) | [![Nightly](https://prow.knative.dev/badge.svg?jobs=nightly_net-gateway-api_main_periodic)](https://prow.knative.dev?job=nightly_net-gateway-api_main_periodic) |
| [knative.dev/eventing](https://github.com/knative/eventing)  | [![Releases](https://img.shields.io/github/release-pre/knative/eventing.svg?sort=semver)](https://github.com/knative/eventing/releases) | [![Releasability](https://github.com/knative/eventing/workflows/Releasability/badge.svg)](https://github.com/knative/eventing/actions/workflows/knative-releasability.yaml) | [![Nightly](https://prow.knative.dev/badge.svg?jobs=nightly_eventing_main_periodic)](https://prow.knative.dev?job=nightly_eventing_main_periodic) |
| [knative.dev/sample-controller](https://github.com/knative-sandbox/sample-controller) | [![Releases](https://img.shields.io/github/release-pre/knative-sandbox/sample-controller.svg?sort=semver)](https://github.com/knative-sandbox/sample-controller/releases)  | [![Releasability](https://github.com/knative-sandbox/sample-controller/workflows/Releasability/badge.svg)](https://github.com/knative-sandbox/sample-controller/actions/workflows/knative-releasability.yaml) | [![Nightly](https://prow.knative.dev/badge.svg?jobs=nightly_sample-controller_main_periodic)](https://prow.knative.dev?job=nightly_sample-controller_main_periodic)  |


### This group can be started after `knative.dev/eventing` has been successfully published.

| Repo   | Release   | Releasability   | Nightly   |
| ---------------------- | ---------------------- | ---------------------- | ---------------------- |
| [knative.dev/eventing-ceph](https://github.com/knative-sandbox/eventing-ceph)  | [![Releases](https://img.shields.io/github/release-pre/knative-sandbox/eventing-ceph.svg?sort=semver)](https://github.com/knative-sandbox/eventing-ceph/releases)  | [![Releasability](https://github.com/knative-sandbox/eventing-ceph/workflows/Releasability/badge.svg)](https://github.com/knative-sandbox/eventing-ceph/actions/workflows/knative-releasability.yaml)  | [![Nightly](https://prow.knative.dev/badge.svg?jobs=nightly_eventing-ceph_main_periodic)](https://prow.knative.dev?job=nightly_eventing-ceph_main_periodic) |
| [knative.dev/eventing-kogito](https://github.com/knative-sandbox/eventing-kogito) | [![Releases](https://img.shields.io/github/release-pre/knative-sandbox/eventing-kogito.svg?sort=semver)](https://github.com/knative-sandbox/eventing-kogito/releases) | [![Releasability](https://github.com/knative-sandbox/eventing-kogito/workflows/Releasability/badge.svg)](https://github.com/knative-sandbox/eventing-kogito/actions/workflows/knative-releasability.yaml) | [![Nightly](https://prow.knative.dev/badge.svg?jobs=nightly_eventing-kogito_main_periodic)](https://prow.knative.dev?job=nightly_eventing-kogito_main_periodic) |
| [knative.dev/eventing-rabbitmq](https://github.com/knative-sandbox/eventing-rabbitmq)   | [![Releases](https://img.shields.io/github/release-pre/knative-sandbox/eventing-rabbitmq.svg?sort=semver)](https://github.com/knative-sandbox/eventing-rabbitmq/releases)   | [![Releasability](https://github.com/knative-sandbox/eventing-rabbitmq/workflows/Releasability/badge.svg)](https://github.com/knative-sandbox/eventing-rabbitmq/actions/workflows/knative-releasability.yaml)   | [![Nightly](https://prow.knative.dev/badge.svg?jobs=nightly_eventing-rabbitmq_main_periodic)](https://prow.knative.dev?job=nightly_eventing-rabbitmq_main_periodic) |
| [knative.dev/sample-source](https://github.com/knative-sandbox/sample-source)  | [![Releases](https://img.shields.io/github/release-pre/knative-sandbox/sample-source.svg?sort=semver)](https://github.com/knative-sandbox/sample-source/releases)  | [![Releasability](https://github.com/knative-sandbox/sample-source/workflows/Releasability/badge.svg)](https://github.com/knative-sandbox/sample-source/actions/workflows/knative-releasability.yaml)  | [![Nightly](https://prow.knative.dev/badge.svg?jobs=nightly_sample-source_main_periodic)](https://prow.knative.dev?job=nightly_sample-source_main_periodic) |

### This group can be started after both `knative.dev/eventing` and `knative.dev/serving` have been successfully published.

| Repo   | Release   | Releasability   | Nightly   |
| ---------------------- | ---------------------- | ---------------------- | ---------------------- |
| [knative.dev/client](https://github.com/knative/client)   | [![Releases](https://img.shields.io/github/release-pre/knative/client.svg?sort=semver)](https://github.com/knative/client/releases)  | [![Releasability](https://github.com/knative/client/workflows/Releasability/badge.svg)](https://github.com/knative/client/actions/workflows/knative-releasability.yaml) | [![Nightly](https://prow.knative.dev/badge.svg?jobs=nightly_client_main_periodic)](https://prow.knative.dev?job=nightly_client_main_periodic) |
| [knative.dev/eventing-kafka](https://github.com/knative-sandbox/eventing-kafka)   | [![Releases](https://img.shields.io/github/release-pre/knative-sandbox/eventing-kafka.svg?sort=semver)](https://github.com/knative-sandbox/eventing-kafka/releases)   | [![Releasability](https://github.com/knative-sandbox/eventing-kafka/workflows/Releasability/badge.svg)](https://github.com/knative-sandbox/eventing-kafka/actions/workflows/knative-releasability.yaml)   | [![Nightly](https://prow.knative.dev/badge.svg?jobs=nightly_eventing-kafka_main_periodic)](https://prow.knative.dev?job=nightly_eventing-kafka_main_periodic)   |
| [knative.dev/eventing-redis](https://github.com/knative-sandbox/eventing-redis)   | [![Releases](https://img.shields.io/github/release-pre/knative-sandbox/eventing-redis.svg?sort=semver)](https://github.com/knative-sandbox/eventing-redis/releases)   | [![Releasability](https://github.com/knative-sandbox/eventing-redis/workflows/Releasability/badge.svg)](https://github.com/knative-sandbox/eventing-redis/actions/workflows/knative-releasability.yaml)   | [![Nightly](https://prow.knative.dev/badge.svg?jobs=nightly_eventing-redis_main_periodic)](https://prow.knative.dev?job=nightly_eventing-redis_main_periodic)  |
| [knative.dev/eventing-github](https://github.com/knative-sandbox/eventing-github) | [![Releases](https://img.shields.io/github/release-pre/knative-sandbox/eventing-github.svg?sort=semver)](https://github.com/knative-sandbox/eventing-github/releases) | [![Releasability](https://github.com/knative-sandbox/eventing-github/workflows/Releasability/badge.svg)](https://github.com/knative-sandbox/eventing-github/actions/workflows/knative-releasability.yaml) | [![Nightly](https://prow.knative.dev/badge.svg?jobs=nightly_eventing-github_main_periodic)](https://prow.knative.dev?job=nightly_eventing-github_main_periodic) |
| [knative.dev/eventing-gitlab](https://github.com/knative-sandbox/eventing-gitlab) | [![Releases](https://img.shields.io/github/release-pre/knative-sandbox/eventing-gitlab.svg?sort=semver)](https://github.com/knative-sandbox/eventing-gitlab/releases) | [![Releasability](https://github.com/knative-sandbox/eventing-gitlab/workflows/Releasability/badge.svg)](https://github.com/knative-sandbox/eventing-gitlab/actions/workflows/knative-releasability.yaml) | [![Nightly](https://prow.knative.dev/badge.svg?jobs=nightly_eventing-gitlab_main_periodic)](https://prow.knative.dev?job=nightly_eventing-gitlab_main_periodic) |

### This group can be started after all the previous repos have been successfully published.

| Repo   | Release   | Releasability   | Nightly   |
| ---------------------- | ---------------------- | ---------------------- | ---------------------- |
| [knative.dev/eventing-kafka-broker](https://github.com/knative-sandbox/eventing-kafka-broker) | [![Releases](https://img.shields.io/github/release-pre/knative-sandbox/eventing-kafka-broker.svg?sort=semver)](https://github.com/knative-sandbox/eventing-kafka-broker/releases) | [![Releasability](https://github.com/knative-sandbox/eventing-kafka-broker/workflows/Releasability/badge.svg)](https://github.com/knative-sandbox/eventing-kafka-broker/actions/workflows/knative-releasability.yaml) | [![Nightly](https://prow.knative.dev/badge.svg?jobs=nightly_eventing-kafka-broker_main_periodic)](https://prow.knative.dev?job=nightly_eventing-kafka-broker_main_periodic) |
| [knative.dev/eventing-autoscaler-keda](https://github.com/knative-sandbox/eventing-autoscaler-keda) | [![Releases](https://img.shields.io/github/release-pre/knative-sandbox/eventing-autoscaler-keda.svg?sort=semver)](https://github.com/knative-sandbox/eventing-autoscaler-keda/releases) | [![Releasability](https://github.com/knative-sandbox/eventing-autoscaler-keda/workflows/Releasability/badge.svg)](https://github.com/knative-sandbox/eventing-autoscaler-keda/actions/workflows/knative-releasability.yaml) | [![Nightly](https://prow.knative.dev/badge.svg?jobs=nightly_eventing-autoscaler-keda_main_periodic)](https://prow.knative.dev?job=nightly_eventing-autoscaler-keda_main_periodic) |
| [knative.dev/kn-plugin-admin](https://github.com/knative-sandbox/kn-plugin-admin) | [![Releases](https://img.shields.io/github/release-pre/knative-sandbox/kn-plugin-admin.svg?sort=semver)](https://github.com/knative-sandbox/kn-plugin-admin/releases) | [![Releasability](https://github.com/knative-sandbox/kn-plugin-admin/workflows/Releasability/badge.svg)](https://github.com/knative-sandbox/kn-plugin-admin/actions/workflows/knative-releasability.yaml) | [![Nightly](https://prow.knative.dev/badge.svg?jobs=nightly_kn-plugin-admin_main_periodic)](https://prow.knative.dev?job=nightly_kn-plugin-admin_main_periodic) |
| [knative.dev/kn-plugin-event](https://github.com/knative-sandbox/kn-plugin-event) | [![Releases](https://img.shields.io/github/release-pre/knative-sandbox/kn-plugin-event.svg?sort=semver)](https://github.com/knative-sandbox/kn-plugin-event/releases) | [![Releasability](https://github.com/knative-sandbox/kn-plugin-event/workflows/Releasability/badge.svg)](https://github.com/knative-sandbox/kn-plugin-event/actions/workflows/knative-releasability.yaml) | [![Nightly](https://prow.knative.dev/badge.svg?jobs=nightly_kn-plugin-event_main_periodic)](https://prow.knative.dev?job=nightly_kn-plugin-event_main_periodic) |
| [knative.dev/kn-plugin-source-kafka](https://github.com/knative-sandbox/kn-plugin-source-kafka) | [![Releases](https://img.shields.io/github/release-pre/knative-sandbox/kn-plugin-source-kafka.svg?sort=semver)](https://github.com/knative-sandbox/kn-plugin-source-kafka/releases) | [![Releasability](https://github.com/knative-sandbox/kn-plugin-source-kafka/workflows/Releasability/badge.svg)](https://github.com/knative-sandbox/kn-plugin-source-kafka/actions/workflows/knative-releasability.yaml) | [![Nightly](https://prow.knative.dev/badge.svg?jobs=nightly_kn-plugin-source-kafka_main_periodic)](https://prow.knative.dev?job=nightly_kn-plugin-source-kafka_main_periodic) |
| [knative.dev/kn-plugin-source-kamelet](https://github.com/knative-sandbox/kn-plugin-source-kamelet) | [![Releases](https://img.shields.io/github/release-pre/knative-sandbox/kn-plugin-source-kamelet.svg?sort=semver)](https://github.com/knative-sandbox/kn-plugin-source-kamelet/releases) | [![Releasability](https://github.com/knative-sandbox/kn-plugin-source-kamelet/workflows/Releasability/badge.svg)](https://github.com/knative-sandbox/kn-plugin-source-kamelet/actions/workflows/knative-releasability.yaml) | [![Nightly](https://prow.knative.dev/badge.svg?jobs=nightly_kn-plugin-source-kamelet_main_periodic)](https://prow.knative.dev?job=nightly_kn-plugin-source-kamelet_main_periodic) |
| [knative.dev/kn-plugin-quickstart](https://github.com/knative-sandbox/kn-plugin-quickstart)   | [![Releases](https://img.shields.io/github/release-pre/knative-sandbox/kn-plugin-quickstart.svg?sort=semver)](https://github.com/knative-sandbox/kn-plugin-quickstart/releases)  | [![Releasability](https://github.com/knative-sandbox/kn-plugin-quickstart/workflows/Releasability/badge.svg)](https://github.com/knative-sandbox/kn-plugin-quickstart/actions/workflows/knative-releasability.yaml)   | [![Nightly](https://prow.knative.dev/badge.svg?jobs=nightly_kn-plugin-quickstart_main_periodic)](https://prow.knative.dev?job=nightly_kn-plugin-quickstart_main_periodic)  |


## Post-release
📝 See these instructions for further guidance:

- [Releasing a new version of the Knative documentation](PROCEDURES.md#releasing-a-new-version-of-the-knative-documentation).
- [Homebrew updates](PROCEDURES.md#homebrew-updates).
- [Updating the release schedule](PROCEDURES.md#updating-the-release-schedule).
