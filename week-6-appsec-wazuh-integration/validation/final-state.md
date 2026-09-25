# Final known-good state

## Source and CI

- Flask is pinned to `3.1.3`.
- The deliberate SQL injection remains in `app.py`.
- Semgrep is red by design.
- Final Semgrep metrics: 6 findings, 6 blocking, 341 rules, 11 targets, exit code `1`.
- `semgrep-results.json` is uploaded before the blocking gate.
- pip-audit is green with no known vulnerabilities found.
- `pip-audit-results.json` is uploaded with `if: always()`.

## Controlled vulnerability test

- Temporary version: Flask `3.0.3`.
- Verified advisory: `PYSEC-2026-2151`.
- Verified fix version: Flask `3.1.3`.
- The vulnerable pin is not the final repository state.

## Wazuh

- Rule `100202`: Semgrep SQL-injection finding, Level 12.
- Rule `100202` verified by logtest, live alerts, and three dashboard hits.
- Rule `100203`: pip-audit dependency-vulnerability finding, Level 12.
- Rule `100203` verified by logtest and live alerts.
- The built-in JSON decoder handles pip-audit fields; no custom decoder is required.
- The final Semgrep rule family uses direct top-level field matches; `decoded_as json` is not part of the final configuration.

## SOAR

- The existing Week 5 Shuffle workflow delivers both Week 6 rules to Slack.
- Exclusions for `100202` and `100203` sit after Slack and before VirusTotal.
- The failed dynamic pip-audit formatter is not part of the final workflow.

## Boundary and limitation

Artifact delivery from GitHub Actions to the endpoint remains manual: download, SCP, normalization, and replay. Automation begins again at Wazuh collection and continues through Shuffle and Slack.

## Final proof

![Final Semgrep-red and pip-audit-green state](../evidence/final-state/2026-09-25-033935.png)
