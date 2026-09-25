# Week 5 Evidence Catalog

## Evidence policy

The source conversation supplied 126 Week 5 screenshots. Every image was inspected through visual review and text extraction before repository staging.

- **103 screenshots retained:** no visible Slack webhook URL, functional Shuffle webhook identifier, API key, password, cookie, bearer token, or authorization header value was found.
- **23 screenshots withheld:** each displayed a Slack incoming-webhook URL or a functional Shuffle webhook identifier/URL.
- Internal `192.168.244.x` lab addresses remain because they are RFC1918 addresses and support the architecture story.
- No image was cosmetically edited. Credential-bearing originals were excluded rather than partially redacted, avoiding accidental recovery or overlooked fragments.

The withheld originals remain only in the private working evidence pool and are not part of this repository draft.

## Folder inventory

| Folder | Images | What it preserves |
| --- | ---: | --- |
| `00-baseline-install` | 9 | Shuffle VM baseline, Docker installation, clone, OpenSearch prerequisite, initial services/UI |
| `01-shuffle-runtime-troubleshooting` | 13 | App/tool loading, image build, Orborus/worker/Swarm, networks, resource symptoms |
| `02-webhook-wazuh-integration` | 8 | Safe webhook execution result, Wazuh restart/integratord, real Rule 550 receipt |
| `03-networking-virustotal` | 12 | DNS, outbound HTTPS, host/container path, HTTP reachability diagnostics |
| `04-slack-alerting` | 14 | Slack app/channel setup, direct/placeholder tests, message-format iterations |
| `05-conditional-routing` | 13 | Cron noise, severity/rule conditions, clean Rule 550 delivery |
| `06-virustotal-404` | 18 | Workflow development and unknown-hash/no-record validation |
| `07-virustotal-200` | 16 | EICAR validation, known-hash API result, analysis output |
| `08-final-workflow-task-31` | index | Task 31 cross-reference to the final proof set |

## README-selected screenshots

The main Week 5 README uses 15 high-signal images:

1. `00-baseline-install/2026-09-16-152142.png` — Shuffle VM baseline.
2. `00-baseline-install/2026-09-17-095226.png` — Docker validation.
3. `00-baseline-install/2026-09-18-095717.png` — core service state.
4. `02-webhook-wazuh-integration/2026-09-19-141133.png` — completed manual webhook execution.
5. `02-webhook-wazuh-integration/2026-09-19-143023.png` — Wazuh restart/integration check.
6. `02-webhook-wazuh-integration/2026-09-19-211908.png` — real Rule 550 in Shuffle.
7. `05-conditional-routing/2026-09-21-170128.png` — clean Slack alert.
8. `05-conditional-routing/2026-09-21-165715.png` — pre-filter Cron noise.
9. `05-conditional-routing/2026-09-21-165728.png` — final two-condition filter.
10. `06-virustotal-404/2026-09-22-040614.png` — final playbook canvas.
11. `06-virustotal-404/2026-09-22-054509.png` — final HTTP 404.
12. `06-virustotal-404/2026-09-22-054227.png` — no-record Slack output.
13. `07-virustotal-200/2026-09-22-054737.png` — harmless EICAR test trigger.
14. `07-virustotal-200/2026-09-22-054921.png` — final HTTP 200.
15. `07-virustotal-200/2026-09-22-054811.png` — known-hash Slack enrichment.

The other 88 retained screenshots remain available for the deeper setup, troubleshooting, and validation record.

## Withheld security-sensitive screenshots

| Source filename | Reason withheld |
| --- | --- |
| `Screenshot 2026-09-18 113422.png` | Functional Shuffle webhook URL/identifier visible |
| `Screenshot 2026-09-18 113446.png` | Functional Shuffle webhook URL/identifier visible |
| `Screenshot 2026-09-19 141056.png` | Functional Shuffle webhook URL/identifier visible |
| `Screenshot 2026-09-19 142824.png` | Functional Shuffle webhook URL/identifier visible in Wazuh configuration |
| `Screenshot 2026-09-20 114432.png` | Functional Shuffle webhook URL/identifier visible in integration logs |
| `Screenshot 2026-09-21 144325.png` | Slack incoming-webhook URL visible |
| `Screenshot 2026-09-21 145643.png` | Slack incoming-webhook URL visible |
| `Screenshot 2026-09-21 153933.png` | Slack incoming-webhook URL visible |
| `Screenshot 2026-09-21 170201.png` | Slack incoming-webhook URL visible |
| `Screenshot 2026-09-21 172206.png` | Slack incoming-webhook URL visible |
| `Screenshot 2026-09-21 190224.png` | Slack incoming-webhook URL visible |
| `Screenshot 2026-09-22 035518.png` | Slack incoming-webhook URL visible |
| `Screenshot 2026-09-22 035545.png` | Slack incoming-webhook URL visible |
| `Screenshot 2026-09-22 041746.png` | Slack incoming-webhook URL visible |
| `Screenshot 2026-09-22 041817.png` | Slack incoming-webhook URL visible |
| `Screenshot 2026-09-22 052445.png` | Slack incoming-webhook URL visible |
| `Screenshot 2026-09-22 052514.png` | Slack incoming-webhook URL visible |
| `Screenshot 2026-09-22 053109.png` | Slack incoming-webhook URL visible |
| `Screenshot 2026-09-22 053136.png` | Slack incoming-webhook URL visible |
| `Screenshot 2026-09-22 054443.png` | Slack incoming-webhook URL visible |
| `Screenshot 2026-09-22 054524.png` | Slack incoming-webhook URL visible |
| `Screenshot 2026-09-22 054902.png` | Slack incoming-webhook URL visible |
| `Screenshot 2026-09-22 054947.png` | Slack incoming-webhook URL visible |

The facts those images prove are retained in the narrative only when independently supported by adjacent safe evidence or the Task 31 handoff document. Secret values themselves are never transcribed.

