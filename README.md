# Knative release

This project is for Knative release leads who need to track and perform a series of steps necessary to release each of the `knative.dev` components.

## Release schedule

The Knative project releases quarterly, on Tuesday of the 4th week of January, April, July, October, represented by the following Crontab expression:

```
# minute   hour   day      month        weekday
0          0      22-28    1,4,7,10     2
```

**NOTE**: *Minor deviances from above schedule are possible, but they must be accepted by the [TOC committee](https://github.com/knative/community/blob/main/TECH-OVERSIGHT-COMMITTEE.md). Exact dates will always be updated in table(s) below.*

### Release schedule for 2024

| Release | Release Date | Release Leads                                                     | PKG cut    | Unpin repos |
|---------|--------------|-------------------------------------------------------------------|------------|-------------|
| v1.14   | 2024-04-23   | Cali0707, izabelacg, dsimansk                                     | 2024-04-16 | 2024-04-24  |
| v1.15   | 2024-07-23   | TBD                                                               | 2024-07-16 | 2024-07-24  |
| v1.16   | 2024-10-22   | TBD                                                               | 2024-10-15 | 2024-10-23  |
| v1.17   | 2025-01-21   | TBD                                                               | 2024-01-14 | 2024-01-21  |

## Release leads
The current pool of Knative release lead volunteers are listed in the [release roster](./ROSTER.md). If you would like to be a Knative release lead, please open a PR to add your name to the list! Please note: Before volunteering to lead a specific release, please look over the [release timeline](TIMELINE.md) to ensure your availability during the various checkpoints for that release is going to be a match.

## Contributing

If you would like to make contributions towards a future Knative release, you can take a look at all of the help wanted issue across Knative by looking
at [CLOTRIBUTOR](https://clotributor.dev/search?project=knative&page=1).
