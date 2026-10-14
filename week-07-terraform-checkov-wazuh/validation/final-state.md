# Final known-good state and limits

The original lab established Terraform source validation/planning, local Checkov-to-Wazuh ingestion, real Level 12 findings in manager/dashboard output, and focused SSH remediation. It did not establish AWS deployment or a secure full configuration.

| Item | Evidence-backed outcome |
| --- | --- |
| Original tools | Terraform 1.16.4 Linux; Checkov 3.3.22; provider init installed 6.67.0 |
| Terraform readiness | Init/validate succeeded; plan proposed 3 additions |
| Original broad scan | 10 passed / 11 failed / 0 skipped; 0 parsing errors |
| Original selected SSH before | 0 passed / 1 failed / 0 skipped |
| Agent collection | JSON localfile; collector analyzed exact log path |
| Manager rules | Historical 110700 Level 5 parent; 110701 Level 12 FAILED child |
| Synthetic test | insecure_sg logtest matches; kept distinct from real scanning |
| Local automation | Final directory/report correction; multiple actual findings forwarded |
| Live visibility | Real manager findings, dashboard list and detailed S3 document |
| Selected SSH after | 10.7.0.0/16; fmt/validate success; focused 1/0/0 |
| Remaining findings | Unresolved; later CI still shows S3 lifecycle failure |
| CI stretch | Workflow ran and exited 1 on findings; automatic Wazuh delivery unproven |
| Publication | Approved mentorship portfolio documentation with 42 selected screenshots |

The manual reports separate October 12 handoff tests with macOS Terraform 1.6.6, AWS provider 6.68.0 and Checkov 3.3.22: selected before 0/1/0, selected after 1/0/0, full prepared source 11/10/0, 10 normalized events, isolated runner and file checks. Those earlier tests are not new original VM tests or a live Wazuh run.

The current documentation review verified the supplied archive, image hashes/decoding, classifications, selected-copy hashes, Markdown/image links, shell/Python syntax and XML structure. Current check results are recorded in the separate local approval review. XML structure alone does not establish live manager matching.
