# Troubleshooting register

The failures below are part of the lab's technical record. A correction is described as verified only to the extent supported by its checkpoint. Historical commands are explained, not executed against the current VMs.

| Stage | Symptom and investigation | Correction or later state | Boundary |
| --- | --- | --- | --- |
| Initial publication | Local curl works but Compose binds 127.0.0.1:4280 (E05–E07) | SSH forwarding permits local access; E15 later binds .131:4280 | Local HTTP success alone cannot prove remote reachability |
| Docker networking | UFW inactive, FORWARD DROP and Docker chains examined (E12) | E13 adds source restriction; E15/E16 show allowed access | No generalized firewall diagnosis or persistence proof |
| Rule insertion typo | `1-i` produces Invalid rule number (E13) | Separate `1 -i` command succeeds; listed DOCKER-USER rule retained | Exact visible command repair |
| Direct Windows test | Ping works, TCP/4280 fails, SSH reset occurs (E17/E21) | Tunnel via allowed Linux Agent retried | Restriction is consistent with failure; do not call the app down |
| Sensor coverage | Active service/config alone inconclusive (E10/E11) | HTTP 4280 records and later SQLi alerts observed (E18/E32) | No proof of all-segment monitoring |
| SQLi coverage | Early HTTP evidence does not establish SQLi signature matching (E24/E26) | Config validates, complete SID 1000002 shown, retest and alert ingestion (E27/E30–E33) | Specific raw-URI signature; no generic prevention claim |
| Case/enrichment | Existing integration and API HTTP 200 coexist with zero Cortex quota (E34/E36) | No supplied fix or fresh successful case | Licensing limitation reported; host placement unresolved |
| Shuffle network | No route to host, exit 1; later refusal/timeout (E35/E20/E40) | Backend processing and final matching payload/Slack later observed | Exact cause of each failure and all repair commands unrecorded |
| Shuffle launcher | Extensionless launcher missing, shuffle.py exists (E38) | Later both files present (E40) | Existence alone did not resolve transport failures |
| Health versus delivery | Frontend curl/nc succeed from Shuffle VM (E37) | Final manager timestamp traced through E70/E71/E58 | Test origin and API path differ |
| Checkov API | api.prismacloud.io temporary name-resolution failure (E42) | Normalized failures printed; Wazuh manager/dashboard visibility (E43/E54) | Complete successful fresh scan not established |
| Finding discovery | Filename search returns no matches despite configured directory paths (E45) | Exact path listing and tail find normalized files (E46) | Do not infer missing logs from basename-only search |
| Logtest warnings | Missing malicious-IOC lists, unrelated 7616 warnings (E47) | AppSec test still reaches intended matching phase | Other rules may be ignored; warning not globally resolved |
| Synthetic versus live | Logtest succeeds (E47/E48) | Agent appends independently appear at manager (E49–E52) | Neither stage proves automatic CI artifact ingestion |
| Semgrep control gate | Actions run is red (E39/E59) | Scan found 9 blocking findings, exit 1; pip-audit job passed | Expected security gate behavior, not scanner startup failure |
| www-data escalation | su authentication fails; UID remains 33 (E53) | No successful escalation | Generic admin sudo alerts are unrelated (E60) |
| Recon custom matching | Base 86601 present but no 110750 result (E61–E65) | E66 removes data. wrapper; E70 shows two custom matches | Task 48 reports a Manager restart; precise commands not visible |
| Severity interpretation | Shuffle shows severity 3, manager/Slack show Level 8 (E71/E70/E58) | Values recorded independently | Mapping/origin unresolved |
| Clock differences | Filename/display/log times differ | Correlate identical embedded final event timestamp | No unsupported timezone normalization |

## Docker access and firewall checks

The service responded locally before the network binding changed. The first firewall insertion failed with `Invalid rule number`; the next command listed the corrected source restriction. From Windows, ping succeeded while TCP/4280 failed. The [deployment guide](dvwa-deployment.md#verification-and-troubleshooting) shows the separate successful HTTP test from the allowed Linux Agent.

![Failed and corrected Docker firewall rule insertion](../evidence/troubleshooting/E13-2026-10-17-111513.png)

*E13: iptables insertion first fails with Invalid rule number; corrected command and source-restricted rule are listed.*

![Windows host ping succeeds but direct TCP connection fails](../evidence/troubleshooting/E17-2026-10-17-122728.png)

*E17: Windows host can ping but TCP/4280 fails; consistent with source restriction, not proof of application failure.*

## Shuffle reachability, launcher and webhook processing

The manager logged `No route to host` and exit status 1. A successful port check from the Shuffle host tested the local listener, while the missing launcher was a separate symptom. Later backend logs show webhook processing; they do not establish which repair fixed every earlier error or that every branch of the final run completed.

![Wazuh cannot reach the Shuffle webhook; token redacted](../evidence/troubleshooting/E35-2026-10-18-110149.png)

*E35: Wazuh-to-Shuffle fails with No route to host and exit status 1; webhook token redacted.*

![Shuffle frontend HTTP and port checks pass locally](../evidence/shuffle/E37-2026-10-19-004231.png)

*E37: Shuffle frontend HTTP 200 and local port connectivity succeed; webhook delivery remains a separate test.*

![Missing extensionless Shuffle launcher](../evidence/troubleshooting/E38-2026-10-19-005049.png)

*E38: Extensionless shuffle launcher initially missing while shuffle.py exists.*

![Shuffle backend processes webhooks with tokens redacted](../evidence/shuffle/E41-2026-10-19-010118.png)

*E41: Shuffle backend records webhook processing and finished executions; hook identifier and callback tokens redacted; unrelated execution status is not final recon-run completion proof.*

## Wazuh correlation before and after the field correction

The first child rule used `data.` prefixes. The exact Rule 110750 query returned no rows even though base scan events were present. Removing the prefixes from the decoded field names produced the corrected rule; the [final event trace](../validation/final-results.md#correlated-final-event) shows the resulting notification.

![Initial rule uses data-prefixed field names](../evidence/troubleshooting/E62-2026-10-19-160806.png)

*E62: Initial custom Rule 110750 uses data-prefixed fields; later query produces no custom match.*

![No match for custom rule before field correction](../evidence/troubleshooting/E64-2026-10-19-161402.png)

*E64: Query for custom Rule 110750 returns no rows at this checkpoint; base detection existed.*

![Corrected Wazuh Rule 110750 uses decoded field names](../evidence/wazuh/E66-2026-10-19-161928.png)

*E66: Corrected Rule 110750 uses src_ip, dest_ip and alert.signature; parent 86601, Level 8.*

## Case handling and Cortex quota

TheHive responded to its status check, but the same log reports a zero-server Cortex quota. The handoff reports a licensing limitation, and no fresh Week 8 case or Cortex enrichment is verified.

![TheHive logs report a zero Cortex server quota](../evidence/case-management/E36-2026-10-18-121122.png)

*E36: TheHive API status responses coexist with a zero-server Cortex quota warning; new Week 8 case/enrichment success is unverified.*

## Checkov DNS error and local ingestion

The Checkov checkpoint shows a remote API DNS failure above the normalized findings. A matching Wazuh Checkov result demonstrates continued local ingestion; the error means this checkpoint cannot establish a complete fresh scan.

![Checkov API DNS error and normalized output](../evidence/week-06-07-validation/E42-2026-10-19-010944.png)

*E42: Checkov API name resolution fails, while normalized failed-check records are printed below; completeness of that scan is not established.*

![Wazuh Rule 110701 Level 12 for Checkov](../evidence/week-06-07-validation/E43-2026-10-19-011349.png)

*E43: Checkov finding reaches Wazuh Rule 110701 Level 12; generic sudo records in the broad query are unrelated.*

## Why generic sudo alerts did not prove escalation

The broad filter surfaced administrative sudo and Semgrep records. The container identity check in [Task 45](../README.md#privilege-escalation-outcome) is the relevant proof: it shows authentication failure and no change from `www-data`.

![Broad log filter mixes unrelated sudo and Semgrep records](../evidence/privilege-escalation/E60-2026-10-19-154901.png)

*E60: Broad grep returns Semgrep and generic Successful sudo to ROOT alerts; these do not establish www-data escalation or detection of its failed su attempt.*

## What remains to investigate

A future lab session could establish exact case-stack placement, resolve licensing/Cortex quota, validate new case creation and analyzer output, capture the complete port-scan rule, explain the additional Shuffle severity field and trace the Week 6 rule-ID difference. It could also test persistent firewall behavior and automatic CI artifact delivery. None of those future activities has been claimed complete in this portfolio.
