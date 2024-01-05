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

| Release | Release Date | Release Leads                                     | PKG cut    | Unpin repos |
|---------|--------------|---------------------------------------------------|------------|-------------|
| v1.11   | 2023-07-25   | skonto, dsimansk, creydr, pierDipi, Vishal-Chdhry | 2023-07-18 | 2023-07-26  |
| v1.12   | 2023-10-24   | skonto, ReToCode, Cali0707, creydr, dsimansk      | 2023-10-17 | 2023-10-25  |
| v1.13   | 2024-01-23   | skonto, ReToCode, pierDipi, dsimansk, Cali0707    | 2024-01-16 | 2024-01-24  |
| v1.14   | 2024-04-25   | TBD                                               | 2024-04-18 | 2024-04-26  |

## Release leads
The current pool of Knative release lead volunteers are listed in the [release roster](./ROSTER.md). If you would like to be a Knative release lead, please open a PR to add your name to the list! Please note: Before volunteering to lead a specific release, please look over the [release timeline](TIMELINE.md) to ensure your availability during the various checkpoints for that release is going to be a match.

## Contributing

If you would like to make contributions towards a future Knative release, you can take a look at all of the help wanted issue across Knative by looking
at [CLOTRIBUTOR](https://clotributor.dev/search?project=knative&page=1).
