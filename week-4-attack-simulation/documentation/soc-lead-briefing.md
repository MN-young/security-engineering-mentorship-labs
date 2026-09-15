# SOC Lead Briefing — Week 4

## Executive summary

Five controlled ATT&CK techniques were tested across Discovery, Execution, Persistence, Credential Access, and Defense Evasion.

- T1046 achieved a complete detection-to-enrichment pass.
- T1053.003 exposed a real pipeline defect and passed after repair.
- T1059.004, T1552.001, and T1070.004 remain documented coverage gaps.

This is a useful result: the testing validated the strongest control, improved one material detection path, and identified the next telemetry investments.

## Strongest current coverage — network reconnaissance

T1046 proved:

```text
Atomic Nmap scan
  → Suricata SID 1000001
  → Wazuh Rule 86601
  → TheHive Case #231
  → automatic source-IP observable
  → Cortex / VirusTotal enrichment
```

The 120-second Atomic timeout did not prevent detection because the scan traffic had already been generated. Source, destination, signature, case, observable, and enrichment were correlated across the pipeline.

## Detection improved — Cron persistence

### Before

```text
Atomic persistence: yes
Linux Cron telemetry: yes
Wazuh alert: no
```

### Root cause

`wazuh-logtest` reported `No decoder matched`. After the decoder/rule worked offline, the live endpoint still lacked explicit collection of the reliable `/var/log/syslog` source.

### Fix

- Add `cron-service` decoder.
- Add rule `111801`, level `8`.
- Map to MITRE `T1053.003`.
- Collect `/var/log/syslog` explicitly.

### After

```text
agent:        wazuh-linux-agent
rule:         111801
level:        8
decoder:      cron-service
user:         sysadmin
command:      /tmp/evil.sh
MITRE:        T1053.003
```

No TheHive case was expected because current automation routing covers the rule `86601` port-scan flow only.

## Current coverage gaps

### T1059.004 — Unix Shell

The script executed and the host artifact existed, but no Wazuh alert was produced. Suricata observed traffic without identifying malicious network behavior.

**Risk:** Linux command and shell activity can occur without sufficient endpoint visibility.

**Priority:** High. Add `auditd`, eBPF-based process telemetry, or equivalent process monitoring, then validate common interpreter and command-line detections.

### T1552.001 — Credentials In Files

The controlled search for a fake `.git-credentials` file completed without a Wazuh alert.

**Risk:** Local discovery of credential material is not currently visible.

**Priority:** Medium-high. Combine process telemetry with carefully selected sensitive-path coverage. Never collect credential contents unnecessarily.

### T1070.004 — File Deletion

The file deletion succeeded outside current FIM scope.

**Risk:** Deletion in unmonitored temporary paths can be invisible.

**Priority:** Medium. Assess high-value temporary paths and exclusions before broadening FIM. Process telemetry may provide a better signal than blanket `/tmp` monitoring.

## Integration limitation

TheHive routing is narrow by design. T1046 created a case through rule `86601`; T1053 rule `111801` remained in Wazuh. Future routing should use a controlled policy rather than simply forwarding all alerts.

Recommended criteria:

- allowed Wazuh rule IDs,
- Suricata signature checks,
- MITRE tactic/technique allowlists,
- severity threshold,
- stable deduplication key,
- rate limiting and case grouping.

## Recommended next actions

1. Deploy and validate Linux process-execution telemetry.
2. Create T1059.004 detection candidates and baseline administrative shell behavior.
3. Design a safe T1552.001 detection using metadata, not credential contents.
4. Review FIM scope for selected high-risk temporary directories.
5. Generalize TheHive routing with allowlists and deduplication.
6. Retest the five techniques after telemetry changes and version the matrix over time.

## Overall assessment

The lab has strong internal reconnaissance coverage and now has a working Cron persistence detection. Endpoint execution, credential discovery, and file-deletion visibility require additional telemetry or carefully scoped controls. The result is not “two passes and three failures”; it is a verified baseline and a prioritized detection-engineering roadmap.
