# Knative release

This project is for Knative release leads who need to track and perform a series of steps necessary to release each of the `knative.dev` components.
## Release schedule

| Release | Release Date | Serving        | Eventing            | PKG cut    | Unpin repos
| ------- | ------------ | -------------- | --------------------| ---------- | -----------
| v1.5    | 2022-05-31   | dprotaso       | gab-satchi          | 2022-05-24 | 2022-06-01
| v1.6    | 2022-07-12   | psschwei       | evankanderson       | 2022-07-05 | 2022-07-13
| v1.7    | 2022-08-23   | dprotaso       | matzew              | 2022-08-16 | 2022-08-24
| v1.8    | 2022-10-04   | nak3           | lionelvillard       | 2022-09-27 | 2022-10-05
| v1.9    | 2022-11-15   | psschwei       | evankanderson       | 2022-11-08 | 2022-11-16

## Release leads

Current Knative volunteers are listed in the [release roster](./ROSTER.md). If you would like to be a Knative release lead, please open a PR to add your name to the list!

## Release cycles

[Each phase of a Knative release cycle](PHASES.md) requires its set of actions to be fully completed before moving on to the next phase of the cycle. Most of the phases involve performing various [procedures](PROCEDURES.md) on the [repos to be released](PHASES.md#repos-to-be-released) during that phase.
