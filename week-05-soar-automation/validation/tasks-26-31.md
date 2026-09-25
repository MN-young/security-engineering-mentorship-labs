# Tasks 26–31 Validation Matrix

## Acceptance summary

| Task | Engineering outcome | Primary proof | Status |
| --- | --- | --- | --- |
| 26 | Shuffle host deployed and webhook executed | Docker/core services plus completed `TASK26_OK` run | Complete |
| 27 | Wazuh sent a real alert to Shuffle | Rule 550 payload from `wazuh-linux-agent` | Complete |
| 28 | Slack received a clean security alert | Formatted Rule 550 message in `#soc-alerts` | Complete |
| 29 | Selected alerts routed with explicit conditions | `level > 6` AND `rule.id != 111801` | Complete |
| 30 | VirusTotal results routed to two analyst messages | 404/no-record and 200/known-hash runs | Complete |
| 31 | Analyst handoff delivered | Operating procedure, troubleshooting, limitations, recommendations | Complete |

## Task 26 — Deployment and webhook

Acceptance criteria met:

- dedicated Shuffle VM online;
- Docker validation completed;
- Shuffle/OpenSearch stack brought up;
- webhook accepted a manual request with HTTP `200` and execution ID;
- the corresponding Shuffle run finished and returned `TASK26_OK`.

Security note: the terminal/UI screenshots that visibly contain the webhook identifier are withheld. [Safe execution evidence](../evidence/02-webhook-wazuh-integration/2026-09-19-141133.png) preserves the acceptance result.

## Task 27 — Wazuh integration

Acceptance criteria met:

- manager integration configured for JSON alert delivery;
- Wazuh restarted and integration process checked;
- Linux-agent FIM Rule `550` reached Shuffle;
- received event included the file path and post-change SHA-256.

Primary proof: [real Rule 550 in Shuffle](../evidence/02-webhook-wazuh-integration/2026-09-19-211908.png).

## Task 28 — Slack notification

Acceptance criteria met:

- Slack app/incoming webhook delivery tested;
- placeholder messages replaced with a clean alert template;
- final alert displayed rule, level, description, agent, IP, file, and time.

Primary proof: [clean Slack alert](../evidence/05-conditional-routing/2026-09-21-170128.png).

## Task 29 — Filtering and routing

Acceptance criteria met:

- repeated Rule `111801` Cron noise documented;
- branch implemented with `rule.level > 6`;
- second AND condition excludes `rule.id == 111801`;
- Rule `550` continued through the intended branch.

Primary proof: [condition editor](../evidence/05-conditional-routing/2026-09-21-165728.png).

## Task 30 — VirusTotal enrichment

Acceptance criteria met:

- `syscheck.sha256_after` used as the file lookup key;
- real VirusTotal API response captured;
- HTTP `404` routed to a no-record Slack message;
- HTTP `200` routed to an enrichment Slack message with analysis statistics;
- no-record outcome correctly described as unknown, not failed or benign.

Primary proof:

- [404 API result](../evidence/06-virustotal-404/2026-09-22-054509.png)
- [404 analyst message](../evidence/06-virustotal-404/2026-09-22-054227.png)
- [200 API result](../evidence/07-virustotal-200/2026-09-22-054921.png)
- [200 analyst message](../evidence/07-virustotal-200/2026-09-22-054811.png)

## Task 31 — Handoff

Acceptance criteria met:

- final architecture documented;
- branch logic and message fields recorded;
- normal analyst procedure supplied;
- both test cases documented;
- chronological troubleshooting preserved;
- limitations and next-step recommendations supplied;
- evidence and security checklist completed.

Primary artifact: [analyst-handoff.md](../documentation/analyst-handoff.md).

