# Evidence catalog

All 71 source PNGs were opened, visually reviewed in batch context and read with local OCR, and their dimensions and SHA-256 values were checked against the supplied manifest. There are no binary duplicates. Upload sequence is retained because several batches begin with a later screenshot. Capture dates and embedded event times are distinct fields of evidence.

45 images are selected. Seven copies contain opaque masks: E06 and E16 conceal session-cookie values; E35 conceals every repeated webhook token; E41 conceals the callback token and every repeated hook-ID value. E25, E31 and E33 mask replayable SQL injection inputs and retain the results. The 38 other copies are byte-identical. Safe lab IPs, public GitHub account references, technical usernames, timestamps, rule IDs, signatures, errors and result values remain visible. Originals are never overwritten. Excluded raw images and the handoff are not packaged for public GitHub.

[Actual screenshot gallery](gallery.md) · [CSV manifest](evidence-manifest.csv) · [JSON manifest](evidence-manifest.json) · [Selected SHA-256 values](SHA256SUMS.txt)

The manifest inventories all 71 originals and records every original filename, source batch/upload sequence, original hash, dimensions, selected destination, caption and redaction decision. Captions state what is visible and its limits. The per-image topics below come from review rather than the source manifest's broad batch labels.

## Proposed selection

| ID | Original filename | Proposed location | What it demonstrates | Redaction |
| --- | --- | --- | --- | --- |
| E03 | Screenshot 2026-10-16 131741.png | [dvwa/E03-2026-10-16-131741.png](dvwa/E03-2026-10-16-131741.png) | DVWA source clone completed on the Docker Agent. | No sensitive values identified in selected frame |
| E05 | Screenshot 2026-10-16 134159.png | [dvwa/E05-2026-10-16-134159.png](dvwa/E05-2026-10-16-134159.png) | DVWA and MariaDB running; initial host binding is loopback 127.0.0.1:4280. | No sensitive values identified in selected frame |
| E06 | Screenshot 2026-10-16 134442.png | [dvwa/E06-2026-10-16-134442.png](dvwa/E06-2026-10-16-134442.png) | Local setup.php returns HTTP 200; session-cookie values redacted; application and agent containers remain visible. | Opaque blocks over PHP session-cookie values |
| E07 | Screenshot 2026-10-16 135351.png | [dvwa/E07-2026-10-16-135351.png](dvwa/E07-2026-10-16-135351.png) | SSH local forwarding to the loopback-bound application; host-key fingerprint is public key identification, not a private key. | No sensitive values identified in selected frame |
| E10 | Screenshot 2026-10-16 142516.png | [dvwa/E10-2026-10-16-142516.png](dvwa/E10-2026-10-16-142516.png) | Suricata active; ens33 and eve.json checked. | No sensitive values identified in selected frame |
| E11 | Screenshot 2026-10-16 142655.png | [dvwa/E11-2026-10-16-142655.png](dvwa/E11-2026-10-16-142655.png) | AF_PACKET capture configured on ens33 and active Suricata process shown. | No sensitive values identified in selected frame |
| E13 | Screenshot 2026-10-17 111513.png | [troubleshooting/E13-2026-10-17-111513.png](troubleshooting/E13-2026-10-17-111513.png) | iptables insertion first fails with Invalid rule number; corrected command and source-restricted rule are listed. | No sensitive values identified in selected frame |
| E15 | Screenshot 2026-10-17 122312.png | [dvwa/E15-2026-10-17-122312.png](dvwa/E15-2026-10-17-122312.png) | Compose configuration checked, DVWA recreated, and lab-IP port binding verified. | No sensitive values identified in selected frame |
| E16 | Screenshot 2026-10-17 122451.png | [dvwa/E16-2026-10-17-122451.png](dvwa/E16-2026-10-17-122451.png) | Allowed Linux Agent receives HTTP 302 and login.php HTTP 200; session-cookie values redacted. | Opaque blocks over PHP session-cookie values |
| E17 | Screenshot 2026-10-17 122728.png | [troubleshooting/E17-2026-10-17-122728.png](troubleshooting/E17-2026-10-17-122728.png) | Windows host can ping but TCP/4280 fails; consistent with source restriction, not proof of application failure. | No sensitive values identified in selected frame |
| E18 | Screenshot 2026-10-17 124344.png | [dvwa/E18-2026-10-17-124344.png](dvwa/E18-2026-10-17-124344.png) | Suricata HTTP events for DVWA port 4280 establish traffic visibility. | No sensitive values identified in selected frame |
| E23 | Screenshot 2026-10-17 134028.png | [sqli/E23-2026-10-17-134028.png](sqli/E23-2026-10-17-134028.png) | Normal User ID 1 query returns a single DVWA record before SQL injection. | No sensitive values identified in selected frame |
| E25 | Screenshot 2026-10-17 140525.png | [sqli/E25-2026-10-17-140525.png](sqli/E25-2026-10-17-140525.png) | Tautology SQL injection returns five DVWA training records; exploitation of the lab query is demonstrated. | Opaque masks over the replayable SQL input; all five returned records remain visible |
| E27 | Screenshot 2026-10-17 151859.png | [sqli/E27-2026-10-17-151859.png](sqli/E27-2026-10-17-151859.png) | Suricata configuration test reports successful loading; configuration validity alone is not detection. | No sensitive values identified in selected frame |
| E30 | Screenshot 2026-10-18 101738.png | [sqli/E30-2026-10-18-101738.png](sqli/E30-2026-10-18-101738.png) | Complete LAB DVWA SQL Injection Attempt Detected signature SID 1000002, revision 1, matching raw URI content. | No sensitive values identified in selected frame |
| E31 | Screenshot 2026-10-18 103132.png | [sqli/E31-2026-10-18-103132.png](sqli/E31-2026-10-18-103132.png) | SQL injection retest still returns multiple records after signature setup. | Opaque masks over the replayable SQL input; all five returned records remain visible |
| E32 | Screenshot 2026-10-18 103357.png | [sqli/E32-2026-10-18-103357.png](sqli/E32-2026-10-18-103357.png) | Suricata eve.json contains repeated SQLi alerts from Linux Agent to DVWA. | No sensitive values identified in selected frame |
| E33 | Screenshot 2026-10-18 103902.png | [sqli/E33-2026-10-18-103902.png](sqli/E33-2026-10-18-103902.png) | Wazuh alerts.json ingests the SQLi signature as Rule 86601, Level 3; action allowed indicates detection, not blocking. | Opaque masks over the replayable request values; the alert fields and outcome are visible |
| E35 | Screenshot 2026-10-18 110149.png | [troubleshooting/E35-2026-10-18-110149.png](troubleshooting/E35-2026-10-18-110149.png) | Wazuh-to-Shuffle fails with No route to host and exit status 1; webhook token redacted. | Opaque blocks over webhook token in every repeated URL |
| E36 | Screenshot 2026-10-18 121122.png | [case-management/E36-2026-10-18-121122.png](case-management/E36-2026-10-18-121122.png) | TheHive API status responses coexist with a zero-server Cortex quota warning; new Week 8 case/enrichment success is unverified. | No sensitive values identified in selected frame |
| E37 | Screenshot 2026-10-19 004231.png | [shuffle/E37-2026-10-19-004231.png](shuffle/E37-2026-10-19-004231.png) | Shuffle frontend HTTP 200 and local port connectivity succeed; webhook delivery remains a separate test. | No sensitive values identified in selected frame |
| E38 | Screenshot 2026-10-19 005049.png | [troubleshooting/E38-2026-10-19-005049.png](troubleshooting/E38-2026-10-19-005049.png) | Extensionless shuffle launcher initially missing while shuffle.py exists. | No sensitive values identified in selected frame |
| E39 | Screenshot 2026-10-19 071733.png | [week-06-07-validation/E39-2026-10-19-071733.png](week-06-07-validation/E39-2026-10-19-071733.png) | GitHub Actions run summary: Semgrep fails, pip-audit passes, two artifacts; no direct CI-to-Wazuh delivery proven. | No sensitive values identified in selected frame |
| E41 | Screenshot 2026-10-19 010118.png | [shuffle/E41-2026-10-19-010118.png](shuffle/E41-2026-10-19-010118.png) | Shuffle backend records webhook processing and finished executions; hook identifier and callback tokens redacted; unrelated execution status is not final recon-run completion proof. | Opaque blocks over webhook token, including repeated hook IDs |
| E42 | Screenshot 2026-10-19 010944.png | [week-06-07-validation/E42-2026-10-19-010944.png](week-06-07-validation/E42-2026-10-19-010944.png) | Checkov API name resolution fails, while normalized failed-check records are printed below; completeness of that scan is not established. | No sensitive values identified in selected frame |
| E43 | Screenshot 2026-10-19 011349.png | [week-06-07-validation/E43-2026-10-19-011349.png](week-06-07-validation/E43-2026-10-19-011349.png) | Checkov finding reaches Wazuh Rule 110701 Level 12; generic sudo records in the broad query are unrelated. | No sensitive values identified in selected frame |
| E45 | Screenshot 2026-10-19 013733.png | [week-06-07-validation/E45-2026-10-19-013733.png](week-06-07-validation/E45-2026-10-19-013733.png) | Linux Agent collects JSON from /var/log/semgrep/findings.json and /var/log/pip-audit/findings.json. | No sensitive values identified in selected frame |
| E47 | Screenshot 2026-10-19 052803.png | [week-06-07-validation/E47-2026-10-19-052803.png](week-06-07-validation/E47-2026-10-19-052803.png) | Synthetic Semgrep logtest matches Rule 100201 Level 10 despite unrelated missing-list warnings. | No sensitive values identified in selected frame |
| E48 | Screenshot 2026-10-19 052920.png | [week-06-07-validation/E48-2026-10-19-052920.png](week-06-07-validation/E48-2026-10-19-052920.png) | Synthetic pip-audit logtest matches Rule 100203 Level 12. | No sensitive values identified in selected frame |
| E49 | Screenshot 2026-10-19 053530.png | [week-06-07-validation/E49-2026-10-19-053530.png](week-06-07-validation/E49-2026-10-19-053530.png) | Controlled Semgrep test JSON appended to the monitored agent file; not a fresh scanner export. | No sensitive values identified in selected frame |
| E50 | Screenshot 2026-10-19 054007.png | [week-06-07-validation/E50-2026-10-19-054007.png](week-06-07-validation/E50-2026-10-19-054007.png) | Manager live alert for the Semgrep test: Rule 100201 Level 10, marker and agent match. | No sensitive values identified in selected frame |
| E51 | Screenshot 2026-10-19 054337.png | [week-06-07-validation/E51-2026-10-19-054337.png](week-06-07-validation/E51-2026-10-19-054337.png) | Controlled pip-audit dependency test JSON appended; vulnerable version is a test payload, not the current CI dependency state. | No sensitive values identified in selected frame |
| E52 | Screenshot 2026-10-19 054416.png | [week-06-07-validation/E52-2026-10-19-054416.png](week-06-07-validation/E52-2026-10-19-054416.png) | Manager live dependency-test alert: Rule 100203 Level 12. | No sensitive values identified in selected frame |
| E53 | Screenshot 2026-10-19 060007.png | [privilege-escalation/E53-2026-10-19-060007.png](privilege-escalation/E53-2026-10-19-060007.png) | Operator uses docker exec -u www-data; su authentication fails with exit 1 and before/after uid remains 33. | No sensitive values identified in selected frame |
| E54 | Screenshot 2026-10-19 064825.png | [week-06-07-validation/E54-2026-10-19-064825.png](week-06-07-validation/E54-2026-10-19-064825.png) | Dashboard jointly displays Checkov 110701 Level 12, pip-audit 100203 Level 12 and Semgrep 100201 Level 10. | No sensitive values identified in selected frame |
| E58 | Screenshot 2026-10-19 170611.png | [slack/E58-2026-10-19-170611.png](slack/E58-2026-10-19-170611.png) | Slack notification matches Rule 110750 Level 8 and final manager event timestamp; destination channel reported by handoff, channel label not visible in crop. | No sensitive values identified in selected frame |
| E59 | Screenshot 2026-10-19 071827.png | [week-06-07-validation/E59-2026-10-19-071827.png](week-06-07-validation/E59-2026-10-19-071827.png) | Semgrep CI scan: 9 findings, 9 blocking, 341 rules, 11 targets, exit 1; pip-audit job green. | No sensitive values identified in selected frame |
| E60 | Screenshot 2026-10-19 154901.png | [privilege-escalation/E60-2026-10-19-154901.png](privilege-escalation/E60-2026-10-19-154901.png) | Broad grep returns Semgrep and generic Successful sudo to ROOT alerts; these do not establish www-data escalation or detection of its failed su attempt. | No sensitive values identified in selected frame |
| E61 | Screenshot 2026-10-19 160119.png | [reconnaissance/E61-2026-10-19-160119.png](reconnaissance/E61-2026-10-19-160119.png) | Manager confirms base Suricata port-scan alert under Rule 86601 for Linux Agent to DVWA. | No sensitive values identified in selected frame |
| E62 | Screenshot 2026-10-19 160806.png | [troubleshooting/E62-2026-10-19-160806.png](troubleshooting/E62-2026-10-19-160806.png) | Initial custom Rule 110750 uses data-prefixed fields; later query produces no custom match. | No sensitive values identified in selected frame |
| E64 | Screenshot 2026-10-19 161402.png | [troubleshooting/E64-2026-10-19-161402.png](troubleshooting/E64-2026-10-19-161402.png) | Query for custom Rule 110750 returns no rows at this checkpoint; base detection existed. | No sensitive values identified in selected frame |
| E66 | Screenshot 2026-10-19 161928.png | [wazuh/E66-2026-10-19-161928.png](wazuh/E66-2026-10-19-161928.png) | Corrected Rule 110750 uses src_ip, dest_ip and alert.signature; parent 86601, Level 8. | No sensitive values identified in selected frame |
| E69 | Screenshot 2026-10-19 165942.png | [reconnaissance/E69-2026-10-19-165942.png](reconnaissance/E69-2026-10-19-165942.png) | Final Nmap -sT -Pn -p 1-1000,4280 scan; SSH/22 and DVWA/4280 open. | No sensitive values identified in selected frame |
| E70 | Screenshot 2026-10-19 170043.png | [wazuh/E70-2026-10-19-170043.png](wazuh/E70-2026-10-19-170043.png) | Two custom Rule 110750 Level 8 alerts; final event 15:56:48.758+0000 matches Shuffle and Slack. | No sensitive values identified in selected frame |
| E71 | Screenshot 2026-10-19 170246.png | [shuffle/E71-2026-10-19-170246.png](shuffle/E71-2026-10-19-170246.png) | Final reconnaissance payload in Shuffle, Rule 110750 and matching timestamp; UI status EXECUTING; extra severity 3 origin unresolved. | No sensitive values identified in selected frame |

## Originals not selected

These 26 captures remain in the private source archive and are inventoried rather than added simply to increase the public screenshot count.

| ID | Original filename | Reason and observed content |
| --- | --- | --- |
| E01 | Screenshot 2026-10-17 125202.png | Early single-port Nmap scan and mixed Suricata events; not the final targeted correlation. |
| E02 | Screenshot 2026-10-15 160316.png | Docker and Compose readiness; existing service containers and host capacity. |
| E04 | Screenshot 2026-10-16 134120.png | Initial Compose startup; superseded by the fuller container and port view E05. |
| E08 | Screenshot 2026-10-16 135412.png | DVWA setup checks; default login text visible in raw source; excluded in favor of stronger deployment and SQLi evidence. |
| E09 | Screenshot 2026-10-16 135510.png | DVWA login page; redundant with actual authenticated application evidence. |
| E12 | Screenshot 2026-10-16 143927.png | Docker networking, inactive UFW, DOCKER-USER chain and FORWARD policy examined. |
| E14 | Screenshot 2026-10-17 120125.png | Compose editor includes database credentials; excluded because E15 proves the binding change without configuration secrets. |
| E19 | Screenshot 2026-10-17 124407.png | Mixed TLS/HTTP events and repeated curl headers; redundant and contains session cookies. |
| E20 | Screenshot 2026-10-19 005317.png | Shuffle connection refusal and timeout; overlapping failure evidence retained in E35 and E41. |
| E21 | Screenshot 2026-10-17 132712.png | SSH tunnel via Linux Agent retried after connection reset; documented in chronology. |
| E22 | Screenshot 2026-10-17 133739.png | DVWA security set to Low for the controlled SQL injection exercise. |
| E24 | Screenshot 2026-10-17 135850.png | Suricata HTTP request records for the SQLi endpoint; superseded by E30-E33 signature evidence. |
| E26 | Screenshot 2026-10-17 141616.png | HTTP/alert inspection and Suricata rule-file configuration before SQLi signature refinement. |
| E28 | Screenshot 2026-10-17 151935.png | Editor view of local scan and SQLi signatures; line ends clipped; use E30 for the complete SQLi rule. |
| E29 | Screenshot 2026-10-18 101347.png | Repeated successful Suricata configuration test; E27 retains the distinct configuration-validation stage. |
| E34 | Screenshot 2026-10-18 104511.png | Existing custom-thehive integration and integration files; configuration presence does not prove fresh case creation. |
| E40 | Screenshot 2026-10-19 005535.png | Later launcher and Python file exist, but transport errors persist; intermediate step, not final recovery. |
| E44 | Screenshot 2026-10-19 012842.png | Manager localfile inspection; actual AppSec monitored paths are confirmed on the Linux Agent in E45. |
| E46 | Screenshot 2026-10-19 014117.png | Existing normalized files and older contents inspected; finding filename search alone initially missed them. |
| E55 | Screenshot 2026-10-19 064919.png | Tighter duplicate crop of E54; broader original context retained in E54. |
| E56 | Screenshot 2026-10-19 071523.png | Standalone README editor describes validation; narrative text is weaker than direct log and CI evidence. |
| E57 | Screenshot 2026-10-19 071558.png | Actions list records the Week 8 rerun; detailed run summary and scan output retained instead. |
| E63 | Screenshot 2026-10-19 161121.png | First broader Nmap scan before custom-field correction; final scan E69 retained. |
| E65 | Screenshot 2026-10-19 161447.png | Base Suricata scan alerts visible alongside other stream alerts; retained in full inventory, E61 captures the targeted pair. |
| E67 | Screenshot 2026-10-19 162459.png | Post-correction scan, followed by first custom match; final scan E69 and two-event view E70 retained. |
| E68 | Screenshot 2026-10-19 162602.png | First custom Rule 110750 alert at 15:21:17.681+0000; included within fuller E70. |

## Documentation provenance

The supplied file `Week8_GitHub_Handoff.docx` was readable. The final Task 48 architecture overview and revised Task 49 runbook were subsequently supplied and are included unchanged with Markdown companions. The original diagram was extracted from Task 48 without editing; it is separate from the 45 selected screenshots. No final recording was supplied. The repository root and Weeks 6–7 READMEs were inspected using read-only access. The user’s later explicit execution request authorizes preparing the main and profile README changes locally while protecting Weeks 1–7 and requiring approval before publication.
