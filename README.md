# Knative release

This project is for Knative release leads who need to track and perform a series of steps necessary to release each of the `knative.dev` components.

## Release schedule

The Knative project releases quarterly, on Tuesday of the 4th week of January, April, July, October, represented by the following Crontab expression:

```
# minute   hour   day      month        weekday
0          0      22-28    1,4,7,10     2
```

**NOTE**: *Minor deviances from above schedule are possible, but they must be accepted by the [TOC committee](https://github.com/knative/community/blob/main/TECH-OVERSIGHT-COMMITTEE.md). Exact dates will always be updated in table(s) below.*

### Release schedule for 2023

| Release | Release Date | Serving        | Eventing            | PKG cut    | Unpin repos
| ------- | ------------ | -------------- | --------------------| ---------- | -----------
| v1.9    | 2023-01-24   | psschwei       | evankanderson       | 2023-01-17 | 2023-01-25
| v1.10   | 2023-04-25   | TBD            | TBD                 | 2023-04-18 | 2023-04-26
| v1.11   | 2023-07-25   | TBD            | TBD                 | 2023-07-18 | 2023-07-26
| v1.12   | 2023-10-24   | TBD            | TBD                 | 2023-10-17 | 2023-10-25

## Release leads
The current pool of Knative release lead volunteers are listed in the [release roster](./ROSTER.md). If you would like to be a Knative release lead, please open a PR to add your name to the list! Please note: Before volunteering to lead a specific release, please look over the [release timeline](TIMELINE.md) to ensure your availability during the various checkpoints for that release is going to be a match.
