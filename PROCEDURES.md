# Procedures

- [Procedures](#procedures)
  - [Releasing a repository](#releasing-a-repository)
  - [Open PR check](#open-pr-check)
  - [Build health check](#build-health-check)
  - [Dependency check](#dependency-check)
    - [Exceptions](#exceptions)
    - [Aligning dependencies](#aligning-dependencies)
  - [Releasability check](#releasability-check)
    - [Exceptions](#exceptions-1)
    - [Updating the releasability defaults](#updating-the-releasability-defaults)
    - [Verifying releasability](#verifying-releasability)
  - [Cut a branch](#cut-a-branch)
    - [Exceptions](#exceptions-2)
    - [Cutting a branch](#cutting-a-branch)
    - [What could go wrong?](#what-could-go-wrong)
  - [Release automation check](#release-automation-check)
    - [Exceptions](#exceptions-3)
    - [Nightly job](#nightly-job)
    - [Release job](#release-job)
    - [Manually triggering a release](#manually-triggering-a-release)
  - [Release notes](#release-notes)
    - [Exceptions](#exceptions-4)
    - [New release notes document](#new-release-notes-document)
    - [Release notes update](#release-notes-update)
  - [Homebrew updates](#homebrew-updates)
    - [homebrew-client](#homebrew-client)
    - [homebrew-kn-plugins](#homebrew-kn-plugins)
  - [Administrative work](#administrative-work)
    - [Permissions for release leads](#permissions-for-release-leads)
    - [Creating a release Slack channel](#creating-a-release-slack-channel)
    - [Updating the release schedule](#updating-the-release-schedule)

## Releasing a repository
To release a `knative.dev` repository, these are the steps needed, in order:

- ✅ [open PR check](#open-pr-check)
- ✅ [build health check](#build-health-check)
- ✅ [dependency check](#dependency-check)
- ✅ [releasability check](#releasability-check)
- ✅ [cut a branch](#cut-a-branch)
- ✅ [automation check](#automation-check)
- ✅ [release notes update](#release-notes-update)
- ✅ [post release](#post-release)

Most of the above steps are automated. In some noted exceptions, it might be
necessary to perform some of them manually.cl

For some repos, there might also be additional validations, or steps that need to be skipped. These exceptions are documented where they apply.

## Open PR check
Please ensure that there are no outstanding PRs for each repo before proceeding with each of the steps. For additional PRs merged into a repo during the release process, new checks need to be done in that repo and in the repos that depend on it.

## Build health check
tl;dr: check that all builds on `main` are passing.

Check if the repository is in a good shape and the builds pass consistently. **This is required** because the [Prow job](#release-job) that builds the release artifacts will execute all the various tests (build, unit, e2e) and, if something goes wrong, the release process will probably need to restart from the beginning.

For any problems in a specific repo, get in touch with the relevant WG leads to fix them.

## Dependency check
tl;dr: check that all the dependencies for the repo are up-to-date and aligned with the relase version.

### Exceptions
Repos that don't have dependencies naturally don't need a dependency check and this step can be skipped for those. Currently, `knative.dev/hack` is the only `knative.dev` repo that does not have any dependencies.

### Aligning dependencies
Each repo needs to be successfully updated to use the latest version of all shared dependencies **before** its release branch is cut.

In order to align the `knative.dev` dependencies, `knative-sandbox/knobots` automation will run PRs like this [Upgrade to latest dependencies PR](https://github.com/knative/eventing/pull/4713) for each repo, executing the command `./hack/update-deps.sh --upgrade --release 0.20` and committing all the content. Note: `buoy check`, which is invoked in the script, will fail if the dependencies are not yet ready.

- If there is no "Upgrade to latest dependencies" PR open, manually trigger the generation of these PRs starting the [Knobots Auto Update Deps](https://github.com/knative-sandbox/knobots/actions/workflows/auto-update-deps.yaml) and wait for the PR to pop in the repo you need. Note that in the automation run you have to change the field `If true, send update PRs even for deps changes that don't change vendor. nUse this only for releases.` to **true**, because in some cases there are no code changes in the vendor.
- Check the `go.mod` to ensure hashes point to commit hash at the head of the release branch of the dependency repo
  - For the **[supporting repos](PHASES.md#supporting-repos)** repos (`hack`, `pkg`, etc) you should see the dependency version pointing at a revision which should match the `HEAD` of the release branch. E.g. `knative.dev/pkg v0.0.0-20210112143930-acbf2af596cf` points at the revision `acbf2af596cf`, which is the `HEAD` of the `release-0.20` branch in `pkg` repo.
  - For the **core release** repos, you should see the dependency version pointing at the version tag. E.g. `knative.dev/eventing v0.20.0` points at the tag `v0.20.0` in the `eventing` repo.

## Releasability check
tl;dr: check that the releasability test is passing.
### Exceptions
Repos that don't have dependencies naturally don't need a releasability check and this step can be skipped for those. Currently, `knative.dev/hack` is the only `knative.dev` repo that does not have any dependencies.

The releasability check will not work on dot releases and there is a potential for false positives in those cases.

### Updating the releasability defaults
Open a PR in the `knative-sandbox/knobots` repo to update the releasability defaults for a release and bump the version info in the source workflow [knative-releasability.yaml](https://github.com/knative-sandbox/knobots/blob/main/workflow-templates/knative-releasability.yaml) file.  Here is an example:

- [Update releasability defaults for 1.5 by gab-satchi · Pull Request #202 · knative-sandbox/knobots](https://github.com/knative-sandbox/knobots/pull/202?w=1)

The changes in the source workflow will be automatically propagated to the rest of Knative repos in the next round of
workflow syncs, and it can also be triggered manually when necessary.

### Verifying releasability
An automatic repo releasability test is executed periodically and the results are posted on the corresponding Slack release channel. If the dependencies are properly aligned, the releasability test will pass.

A test can be re-run by manually running the [Releasability workflow](https://github.com/knative/serving/actions?query=workflow%3AReleasability).

If the releasability test reports a NO-GO on a repo where it was previously passing, probably a new PR merge introduced a dependency misalignment. Whatever the reason, if the releasability test is failing, it is necessary to start with the first step in the [Releasing a repository](#releasing-a-repository) process to get this test to a passing state.

## Cut a branch
tl;dr: cut a release branch from `main`.
### Exceptions
For some repositories some extra manual validation and updates need to be performed before the release branch is cut:

- `knative/client`
  - (optional) Check that [CHANGELOG.adoc](https://github.com/knative/client/blob/main/CHANGELOG.adoc) contains a section about the release, i.e. the top-level "(Unreleased)" section should be changed to point to the upcoming release version and number. It's not critical if the changelog is aligned after the release in retrospective.
  - If the validation fails, the fix should be trivial and could be either performed by the release leads or the client team.

- `knative-sandbox/kn-plugin-quickstart`
  - Update the version numbers of Serving / Kourier / Eventing in [pkg/install/install.go](https://github.com/knative-sandbox/kn-plugin-quickstart/blob/main/pkg/install/install.go#L25-L27) so that the plugin will use the just-released versions.

### Cutting a branch
Cutting a `release-x.y` branch can be done by using the GitHub UI:

1. Click on the branch selection box at the top level page of the repository.

  ![Click the branch selection box](images/github-branch.png)

2. Search for the correct `release-x.y` branch name for the release.

  ![Search for the expected release branch name](images/github-branch-search.png)

1. Click "Create branch: release-x.y".

  ![Click create branch: release-x.y](images/github-branch-create.png)

Otherwise, you can do it by hand on your local machine.

### What could go wrong?
In case you cut a branch before it was ready (e.g. some deps misalignment, a failing test, etc), then follow the steps below:

1. Mark the broken release as a `pre-release`
1. Create a dot release by waiting until the job triggers (once a week on Tue) or [on demand](https://github.com/knative/test-infra/blob/main/guides/manual_release.md#creating-a-dot-release-on-demand).
1. Repeat the steps for a release for the new dot release

## Release automation check
tl;dr: check that the release job succeeded.

The automation used to cut the actual releases is the very same as the automation used to cut nightly releases. The only difference is that the nightly job runs on `main`, and the release job runs against the release branch.

### Exceptions
Repos that don't require release artifacts (such as release tags and GitHub release for example) naturally don't need a release automation check and this step can be skipped for those. All of the [supporting repos](PHASES.md#supporting-repos) fit these criteria.

### Nightly job
tl;dr: verify the nightly release automation is passing.

Verify via [testgrid](http://testgrid.knative.dev/knative) that all relevant nightly releases are passing ([example](http://testgrid.knative.dev/serving#nightly)). If they are not, coordinate with the relevant WG leads to fix them.

### Release job
tl;dr: verify the release automation succeeded.

After a `release-x.y` branch comes into existence, a Prow job builds the code
from that branch, creates a release tag in the repo, publishes the images, publishes the `yaml` artifacts, and generates the GitHub release for that repo. It takes about 2hrs for this job to complete.

Verify the release automation succeeded for all relevant repos via the Prow dashboard: [Prow Status for the release automation - all repos](https://prow.knative.dev/?job=release*).

### Manually triggering a release
You can manually trigger a release for a repository by re-running its release job.

1. Navigate to https://prow.knative.dev/

   ![Prow homepage](images/prow-home.png)

2. Search for the `release*` job for the repository.

   ![Search Prow for the repo and select the release*](images/prow-search.png)

3. Rerun the release job.

   ![Rerun Prow Release](images/prow-rerun.png)

## Release notes
### Exceptions
Repos that don't require release artifacts (such as release tags and GitHub release for example) naturally don't need a release note and this step can be skipped for those. All of the [supporting repos](PHASES.md#supporting-repos) fit these criteria.

### New release notes document
For a new Knative release version, start a fresh HackMD release notes document by emptying out the [last release notes document](https://hackmd.io/cJwvzJ4eRVeqqiXzOPtxsA). Post and pin it to the **release-`xdotx`** Slack channel.

### Release notes update
After a repo release [has been published](#release-job), generate the repo's notes by using the `Release Notes` GitHub Action workflow. See an example in [Eventing](https://github.com/knative/eventing/actions?query=workflow%3A%22Release+Notes%22). The default starting and ending SHAs will work if running out of the `main` branch, or you can determine the correct starting and ending SHAs for the script to run.

Use the generated notes to:

1. add them to the [HackMD document](https://hackmd.io/cJwvzJ4eRVeqqiXzOPtxsA)
2. ask the relevant WG leads if they have any add or edit for the updated repo notes in the [HackMD document](https://hackmd.io/cJwvzJ4eRVeqqiXzOPtxsA)
3. use the GitHub UI to update the repo release tag with the final notes
## Homebrew updates
### homebrew-client
After the client release, the [Homebrew tap](https://github.com/knative/homebrew-client) needs to be updated with the new release:

- Copy `kn.rb` to the `kn@${PREV_RELEASE}.rb` with `$PREV_RELEASE` to be replace with the latest release (e.g. `0.19`).
- In `kn@${PREV_RELEASE}.rb` replace `class Kn` with `class KnAT${PREV_RELEASE_DIGITS}`, e.g `class KnAT019` for an previous release `0.19`.
- In `kn.rb`:
  - Replace the old version number in `v` with the released version (e.g. `v = "v0.20.0"`)
  - Replace the `sha256` checksums with the values from the [client release page](https://github.com/knative/client/releases). The checksums have been released too (e.g. [checksums.txt](https://github.com/knative/client/releases/download/v0.22.0/checksums.txt))

✅ Open a PR and merge the changes. Prow is not enabled for the homebrew repo, so the merge needs to be performed manually.

### homebrew-kn-plugins
Similar to the client repo, the [client plugin's Homebrew repo](https://github.com/knative-sandbox/homebrew-kn-plugins) needs to be updated
for the the plugins supported after their repos have successfully created a release.

Currently the following plugins are available with their own formulas:

* [kn-plugin-admin](https://github.com/knative-sandbox/kn-plugin-admin) is managed via the `admin.rb` formula
* [kn-plugin-source-kafka](https://github.com/knative-sandbox/kn-plugin-source-kafka) is managed via `source-kafka.rb` formula
* [kn-plugin-source-kamelet](https://github.com/knative-sandbox/kn-plugin-source-kamelet) is managed via `source-kamelet.rb` formula
* [kn-plugin-quickstart](https://github.com/knative-sandbox/kn-plugin-quickstart/) is managed via `quickstart.rb` formula
* [kn-plugin-event](https://github.com/knative-sandbox/kn-plugin-event) is managed via `event.rb` formula

## Administrative work
### Permissions for release leads
During a release, the release leads for that cycle need to be given all the permissions to perform the tasks needed for a release. Likewise, permissions for leads from the previous release cycle need to be revoked.

Check if the new leads are included in/removed from these two files in the `Knative Release Leads` section:

- [knative/community/main/peribolos/knative.yaml#Knative Release Leads](https://github.com/knative/community/blob/e635686d46366906af861c409978c2c55990a10e/peribolos/knative.yaml#L878)
- [knative/community/main/peribolos/knative-sandbox.yaml#Knative Release Leads](https://github.com/knative/community/blob/e635686d46366906af861c409978c2c55990a10e/peribolos/knative-sandbox.yaml#L739)

If not, open a PR in the `knative/community` repo to grant/remove permissions. Here's an example:

- [update release leads for 1.5 by nader-ziada · Pull Request #1021 · knative/community](https://github.com/knative/community/pull/1021?w=1)
- be sure to run `/hack/update-codegen.sh` so leads are added to/removed from the `OWNERS_ALIASES`.

It is ok to add/remove leads in two separate PRs.

### Creating a release Slack channel
Ask someone from the TOC to create a **release-`xdotx`** (Ex: `release-1dot5`) Slack channel that will be used to help manage a new release.

### Updating the release schedule
We maintain a list of current (and future) releases in the [Community repo](https://github.com/knative/community/blob/main/mechanics/RELEASE-SCHEDULE.md). When a new release goes out, an older one will almost always fall out of support. We should update the release schedule accordingly by opening a PR against the community repo. See [here](https://github.com/knative/community/pull/991/files) for an example.