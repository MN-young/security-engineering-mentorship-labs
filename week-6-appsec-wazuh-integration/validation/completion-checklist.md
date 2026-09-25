# Week 6 completion checklist

| Requirement | Status | Evidence |
| --- | --- | --- |
| SecureOps application built and exercised | Complete | `evidence/application/` |
| Semgrep runs in GitHub Actions | Complete | `evidence/semgrep/` |
| Semgrep JSON uploaded before blocking gate | Complete | `2026-09-23-054359.png`, `2026-09-23-055302.png` |
| Final Semgrep gate reports 6 findings / 6 blocking / 341 rules / 11 targets / exit 1 | Complete | `2026-09-23-055044.png` |
| Deliberate SQL injection remains | Complete by design | `app.py` and Semgrep evidence |
| Semgrep normalized to one JSON event per line | Complete | `evidence/wazuh-100202/` |
| Wazuh Rule 100202 reaches Level 12 | Complete | logtest, live alert, dashboard evidence |
| Wazuh dashboard shows three Rule 100202 hits | Complete | `2026-09-24-120235.png` |
| pip-audit runs independently | Complete | workflow and `evidence/github-actions/` |
| Controlled Flask 3.0.3 test identifies PYSEC-2026-2151 | Complete | `2026-09-24-173551.png` |
| Dependency restored to Flask 3.1.3 | Complete | `requirements.txt`, final-state evidence |
| Final pip-audit reports no known vulnerabilities | Complete | `2026-09-24-175336.png` |
| pip-audit event normalized and collected | Complete | `evidence/pip-audit/`, `evidence/wazuh-100203/` |
| Wazuh Rule 100203 reaches Level 12 | Complete | `2026-09-25-003453.png` |
| Rules 100202 and 100203 reach Slack | Complete | `2026-09-25-014529.png`, `2026-09-25-014742.png` |
| AppSec rules stop before VirusTotal | Complete | `2026-09-25-014348.png` |
| Final Semgrep-red / pip-audit-green contrast | Complete | `2026-09-25-033935.png` |
| Manual artifact boundary documented | Complete | README and architecture document |
| Reflection criterion covered | Complete | `documentation/reflection.md` |
| Sensitive source screenshots withheld | Complete | `evidence/README.md` |

## Completion interpretation

The red Semgrep job is not an incomplete task. It is the verified result of an intentionally blocking security control against a deliberately vulnerable training path. Completion is demonstrated by the simultaneous clean pip-audit job, preserved artifacts, Wazuh classification, and Slack delivery.
