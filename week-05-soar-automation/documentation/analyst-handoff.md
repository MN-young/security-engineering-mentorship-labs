# Task 31 — SOAR Playbook Analyst Handoff

## Purpose

This handoff explains how the Wazuh → Shuffle → VirusTotal → Slack playbook behaves, what an analyst should do with each outcome, and how to separate a normal no-record result from an operational failure.

## What the playbook does

1. Receives a real Wazuh JSON alert through a Shuffle webhook.
2. Continues selected higher-value events when `rule.level > 6` and `rule.id != 111801`.
3. Posts an initial security alert to Slack.
4. Reads `syscheck.sha256_after` from the FIM alert.
5. Queries the VirusTotal file endpoint.
6. Routes HTTP `200` to Slack Enrichment with analysis statistics.
7. Routes HTTP `404` to Slack Not Found with a no-record explanation.

## Primary validated event

| Field | Validated value |
| --- | --- |
| Wazuh rule | `550` |
| Description | Integrity checksum changed |
| Agent | `wazuh-linux-agent` |
| Agent IP | `192.168.244.129` |
| File | `/etc/week5_task26_final.txt` |
| Hash field | `syscheck.sha256_after` |

Values can differ for future events; the field names and branch behavior are the important contract.

## Normal analyst workflow

### 1. Read the initial Slack alert

Confirm the rule ID, severity, agent, file path, and event time. Decide whether the modified file and host are within the expected scope. Do not wait for enrichment before beginning basic triage if the event is high-risk.

### 2. Correlate the enrichment message

Match the Rule ID and SHA-256 in the enrichment/no-record message to the initial alert. If messages are not threaded, use the event time, endpoint, and file path to avoid correlating the wrong run.

### 3. Interpret HTTP 200

HTTP `200` means VirusTotal has a record for the hash. Review malicious, suspicious, harmless, and undetected counts as current observations, then open the linked report for detail. Counts may change as vendors reclassify the file.

For the controlled test, the known file was the standard harmless EICAR antivirus test string. Treat that as validation evidence, not a real malware incident.

### 4. Interpret HTTP 404

HTTP `404` means no existing VirusTotal record was found. It does **not** mean:

- the integration failed;
- the file is safe;
- the file is malicious.

Continue investigation using provenance, signer/package metadata, recent changes, process context, endpoint activity, and organizational baselines. Consider submitting the sample only under the organization's data-handling and privacy rules.

### 5. Escalate operational errors

The current playbook does not explicitly route authentication, rate-limit, timeout, or provider-error responses. If the initial alert appears without a 200/404 follow-up, inspect the Shuffle execution and escalate the automation failure separately from the security event.

## Quick health checks

1. Confirm Shuffle and its execution workers are running.
2. Confirm the webhook trigger is active.
3. Check whether a recent execution was created for the Wazuh event.
4. Verify Wazuh `integratord` is running and inspect its logs without exposing the endpoint.
5. Confirm container DNS and outbound HTTPS.
6. Check VirusTotal response status for `401`, `403`, `429`, timeout, or `5xx`.
7. Check Slack action status and the target channel.
8. Never paste a webhook URL or API key into a ticket or public chat.

## Validation procedure

### Unknown-hash route

1. Write unique benign text to the monitored validation file.
2. Confirm Wazuh produces Rule `550` with `syscheck.sha256_after`.
3. Confirm Shuffle receives the event.
4. Confirm VirusTotal returns `404`.
5. Confirm Slack posts both the initial alert and the no-record message.

### Known-hash route

1. In the isolated lab only, write the standard harmless EICAR test string to the monitored validation file.
2. Confirm Wazuh produces Rule `550`.
3. Confirm Shuffle receives the event.
4. Confirm VirusTotal returns `200`.
5. Confirm Slack posts the initial alert and current analysis statistics.

## Known limitations

- Explicit branches exist only for `200` and `404`.
- A missing `syscheck.sha256_after` value has no documented fallback.
- Slack currently receives a separate initial and enrichment message.
- The demonstrated filter excludes Rule `111801` on this branch and may need policy review.
- Worker/container instability was observed during setup and needs production-grade monitoring.
- The design depends on external Slack and VirusTotal availability.

## Recommendations

- Add a third operational-error branch and bounded retry/backoff.
- Alert on failed or long-running Shuffle executions.
- Use a managed secret store and rotate any credential ever exposed during testing.
- Thread or update enrichment under the original Slack message.
- Add correlation/execution identifiers that do not expose the webhook secret.
- Define ownership and review dates for filters and suppressions.
- Version a sanitized playbook export after confirming it contains no credentials.
- Build a periodic regression test for both 404 and 200 paths.

## Completion evidence

- [Real Rule 550 in Shuffle](../evidence/02-webhook-wazuh-integration/2026-09-19-211908.png)
- [Final playbook canvas](../evidence/06-virustotal-404/2026-09-22-040614.png)
- [Final 404 lookup](../evidence/06-virustotal-404/2026-09-22-054509.png)
- [Final 404 Slack result](../evidence/06-virustotal-404/2026-09-22-054227.png)
- [Final 200 lookup](../evidence/07-virustotal-200/2026-09-22-054921.png)
- [Final 200 Slack result](../evidence/07-virustotal-200/2026-09-22-054811.png)

