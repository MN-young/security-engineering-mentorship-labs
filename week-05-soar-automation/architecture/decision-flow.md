# Decision Flow

## Entry decision

The initial Shuffle branch is true only when both conditions hold:

```text
alert.rule.level > 6
AND
alert.rule.id != "111801"
```

The `111801` exclusion was introduced after repeated Cron alerts made the Slack channel noisy. It is a scoped lab decision; a production policy should be risk-owned, measured, and reviewed rather than silently suppressing the rule everywhere.

## Enrichment decision

```text
if VirusTotal HTTP status == 200:
    send Slack Enrichment
else if VirusTotal HTTP status == 404:
    send Slack Not Found
else:
    currently no explicit analyst route
```

HTTP `404` is a valid lookup outcome: the queried SHA-256 has no existing VirusTotal record. It does not mean the Shuffle-to-VirusTotal integration failed.

## Recommended third branch

Add an error branch for:

- `401` or `403`: authentication/authorization problem;
- `429`: rate limit reached;
- timeout or DNS error: connectivity problem;
- `5xx`: provider-side failure;
- malformed response: parsing or contract problem.

That route should post a concise enrichment-failed message, record the execution ID, and schedule a bounded retry where appropriate.

