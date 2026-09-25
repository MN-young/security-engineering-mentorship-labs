# Shuffle and Slack routing

## Reused workflow

Week 6 reused the Week 5 Wazuh SOAR Slack playbook. Wazuh supplied the alert, Shuffle executed the workflow, and Slack received the analyst notification.

## Observed routing defect

Rules `100202` and `100203` reached Slack correctly, but they then continued into the existing VirusTotal hash-lookup path. The result was an irrelevant `404` / no-record message because neither finding represented a file hash requiring VirusTotal enrichment.

The pre-fix screenshots remain under `evidence/troubleshooting/`; they are not final architecture evidence.

## Final routing condition

The exclusions were placed after the Slack Alert step and before VirusTotal:

```text
$exec.rule_id != 100202
AND
$exec.rule_id != 100203
```

The branch therefore behaves as follows:

| Rule | Slack | VirusTotal |
| --- | --- | --- |
| `100202` | Deliver | Stop |
| `100203` | Deliver | Stop |
| Other eligible Week 5 alert | Deliver | Continue according to existing logic |

The placement is deliberate. Adding the conditions before Slack would suppress the desired analyst notification. The wrong connector was nearly modified during troubleshooting; the correct control point was the post-Slack branch condition.

## Abandoned formatter experiment

A dedicated pip-audit Slack formatter attempted to reference nested values with `$exec` and `fix_versions.#0`. The nested references produced errors, so the experiment was abandoned. It is not the final workflow and must not be reconstructed from its screenshots.

## Verified notification content

- Rule `100202`, Level 12: Semgrep SQL-injection risk.
- Rule `100203`, Level 12: Flask `3.0.3`, `PYSEC-2026-2151`, fix `3.1.3`.

The final clean Slack screenshots contain no VirusTotal follow-on message.

## Secret handling

Do not publish screenshots containing Slack webhook URLs, Shuffle webhook secrets, VirusTotal API keys, bearer tokens, cookies, or authorization headers. Rotate or revoke any live Slack webhook, VirusTotal key, or Shuffle secret that was exposed during the lab before public release.
