# Week 4 — Attack Simulation and Full-Chain Validation

## Overview

Week 4 tested the security stack built during Weeks 1–3 against five controlled Atomic Red Team techniques. The objective was not to force every test into a successful alert. It was to establish what the lab could detect, prove where visibility stopped, repair one genuine pipeline failure, and turn the results into an actionable MITRE ATT&CK coverage assessment.

```text
Atomic Red Team
      ↓
Endpoint or network activity
      ↓
Suricata and/or Wazuh
      ↓
TheHive (where the existing integration scope applied)
      ↓
MITRE ATT&CK mapping and coverage decision
```

Five techniques spanning five tactics were executed. The final outcome was:

- **1 full-chain pass** — T1046 Network Service Scanning.
- **1 pass after a real pipeline fix** — T1053.003 Cron.
- **3 documented coverage gaps** — T1059.004 Unix Shell, T1552.001 Credentials In Files, and T1070.004 File Deletion.

The most important finding was a real Cron detection failure. The host produced usable telemetry, but Wazuh did not alert. `wazuh-logtest` proved that no decoder matched the event. A dedicated decoder, MITRE-mapped rule, and explicit `/var/log/syslog` collection restored live detection.

## Objectives

- Install Atomic Red Team on a disposable Linux test endpoint.
- Select five techniques from different ATT&CK tactics.
- Determine whether Suricata, Wazuh, and TheHive observed each test.
- Investigate every non-detection instead of treating it as a failed test.
- Find and fix at least one genuine pipeline problem.
- Build an ATT&CK coverage matrix.
- Present the findings as a concise SOC-lead briefing.

## Existing lab architecture

| System | Address | Week 4 role |
| --- | --- | --- |
| `wazuh-linux-agent` | `192.168.244.129` | Atomic Red Team endpoint, Wazuh agent, and Suricata sensor |
| Windows endpoint | `192.168.244.130` | T1046 scan target |
| Wazuh Manager / TheHive / Cortex | `192.168.244.128` | SIEM analysis, case management, and enrichment |

```text
                                  ┌── Suricata ──┐
Atomic Red Team ── activity ──────┤              ├── Wazuh Manager
                                  └─ Linux logs ─┘         │
                                                           ├── Rule 86601 ── TheHive ── Cortex/VirusTotal
                                                           └── Other rules ── remain in Wazuh unless routed
```

The Week 3 bridge was deliberately scoped to the port-scan workflow processed by Wazuh rule `86601`. A Wazuh host alert therefore was not automatically expected to create a TheHive case. This boundary is important when interpreting the T1053 result.

## Safety and baseline

Before installing Atomic Red Team, the Linux endpoint was snapshotted as `Pre-Week4-Atomic-Linux`. The baseline confirmed Ubuntu `24.04.4 LTS`, hostname `wazuh-linux-agent`, address `192.168.244.129`, and active Wazuh Agent and Suricata services.

![Pre-Week 4 Atomic Red Team snapshot](./evidence/00-baseline/01-pre-week4-atomic-snapshot.png)

![Known-good Linux endpoint baseline](./evidence/00-baseline/02-linux-endpoint-baseline.png)

Atomic techniques were executed only in the isolated lab. The credential-file test used a dummy `.git-credentials` file containing fake values under `/tmp/atomic-git-creds-test`; no real credential was searched or published.

See [setup and safety notes](./documentation/setup.md).

## Atomic Red Team installation

PowerShell Core `7.6.5` was installed on the Linux endpoint. `powershell-yaml` and `invoke-atomicredteam` were installed separately after the first combined module command failed. The verified module versions were:

```text
Invoke-AtomicRedTeam  2.3.0.0
powershell-yaml       0.4.12
```

Atomic Red Team was installed at:

```text
/home/sysadmin/AtomicRedTeam
├── atomics
└── invoke-atomicredteam
```

![PowerShell modules and Atomic Red Team installed](./evidence/01-atomic-installation/05-modules-and-atomic-installed.png)

The installation and test-selection issues—including the missing repository package, module parameter error, and the T1087 parent/sub-technique path distinction—are preserved in [setup.md](./documentation/setup.md) and [troubleshooting.md](./documentation/troubleshooting.md).

## Techniques selected

| Technique | Atomic test | Tactic | Purpose |
| --- | --- | --- | --- |
| [T1046](./attack-tests/T1046.md) | T1046-12 — Port Scan using Nmap (port range) | Discovery | Validate the complete network-alert-to-enrichment chain |
| [T1059.004](./attack-tests/T1059.004.md) | T1059.004-1 — Create and Execute Bash Shell Script | Execution | Test Linux shell/process visibility |
| [T1053.003](./attack-tests/T1053.003.md) | T1053.003-1 — Cron: replace crontab with referenced file | Persistence | Test Cron telemetry, decoding, and live detection |
| [T1552.001](./attack-tests/T1552.001.md) | T1552.001-25 — Search for Git Credential Files | Credential Access | Test credential-file discovery coverage safely |
| [T1070.004](./attack-tests/T1070.004.md) | T1070.004-1 — Delete a Single File | Defense Evasion | Test whether deletion is visible within current FIM scope |

![Five selected ATT&CK technique folders verified](./evidence/01-atomic-installation/08-five-techniques-verified.png)

## Test methodology

Each technique was evaluated with the same evidence-led process:

1. Review the Atomic details and prerequisites.
2. Execute the test in the isolated endpoint.
3. Confirm the host artifact, log, or network activity actually occurred.
4. Check Suricata when network activity was relevant.
5. Search Wazuh and, where needed, inspect raw `alerts.json`.
6. Check TheHive only where the existing integration routing applied.
7. Classify the result as pass, pass after fix, or coverage gap.
8. Map the result to MITRE ATT&CK and document the next improvement.

## Technique results

### T1046 — Network Service Scanning: full-chain pass

Atomic test `T1046-12` launched an Nmap service scan from `192.168.244.129` against the Windows endpoint at `192.168.244.130`, ports `1–1000`.

The Atomic wrapper timed out after 120 seconds, but the network traffic had already been generated. The timeout was therefore a tooling/runtime outcome, not a detection failure.

Suricata generated:

```text
signature:    LOCAL TCP Port Scan Detected
signature_id: 1000001
category:     Detection of a Network Scan
src_ip:       192.168.244.129
dest_ip:      192.168.244.130
```

![Suricata detects the Atomic Nmap port scan](./evidence/02-T1046/07-suricata-port-scan-detected.png)

Wazuh ingested the alert as rule `86601`. The existing Week 3 automation then created TheHive Case `#231`, added `192.168.244.129` as an observable, and returned Cortex/VirusTotal enrichment tags including:

![Wazuh Rule 86601 detection details](./evidence/02-T1046/08-wazuh-rule-86601-detected.png)

![Automatically created TheHive Case 231](./evidence/02-T1046/09-thehive-case-231.png)

```text
VT:GetReport="12 resolution(s)"
VT:GetReport="0/89"
```

![Automatic observable and VirusTotal enrichment](./evidence/02-T1046/10-observable-virustotal-enrichment.png)

```text
Atomic T1046-12
      ↓
Suricata SID 1000001
      ↓
Wazuh Rule 86601
      ↓
TheHive Case #231
      ↓
Automatic IP observable
      ↓
Cortex / VirusTotal enrichment
```

**Result: FULL-CHAIN PASS**

### T1059.004 — Unix Shell: coverage gap

After resolving command-path and root-home conflicts, `T1059.004-1` executed successfully and printed:

```text
HELLO from the Atomic Red Team
Exit code: 0
```

The artifact `/tmp/art.sh` existed and contained the test script. A separate Atomic execution-log permission problem was traced to a root-owned `/tmp/Invoke-AtomicTest-ExecutionLog.csv` and corrected with targeted ownership repair.

Wazuh returned no relevant result even though the artifact existed and the agent was healthy. Suricata observed related traffic, including activity involving `8.8.8.8`, but correctly produced no malicious alert for ordinary ICMP traffic. No TheHive case was created.

![T1059.004 produced no matching Wazuh detection](./evidence/03-T1059-004/04-wazuh-no-detection.png)

**Result: COVERAGE GAP** — the current endpoint telemetry does not provide sufficient Linux process/shell execution visibility. The primary recommendation is `auditd` or equivalent process-execution telemetry.

### T1053.003 — Cron: pass after pipeline fix

Atomic test `T1053.003-1` installed:

```cron
* * * * * /tmp/evil.sh
```

Linux logs repeatedly recorded:

```text
CRON[...] (sysadmin) CMD (/tmp/evil.sh)
```

![Atomic Cron persistence executed](./evidence/04-T1053-003/before-fix/01-cron-persistence-executed.png)

![Cron telemetry exists on the Linux endpoint](./evidence/04-T1053-003/before-fix/02-host-cron-telemetry-present.png)

However, Wazuh returned no matching alert. The Wazuh Agent and logcollector were running and journald collection was configured, so the test moved from a normal gap to a pipeline investigation.

The exact event was supplied to `wazuh-logtest`:

```text
Sep 13 22:19:01 wazuh-linux-agent CRON[26118]: (sysadmin) CMD (/tmp/evil.sh)
```

The decisive result was:

```text
Phase 1: Completed pre-decoding
program_name: CRON

Phase 2: Completed decoding
No decoder matched.
```

![Before the fix, Wazuh logtest reports no decoder matched](./evidence/04-T1053-003/root-cause/01-no-decoder-matched.png)

The fix added three pieces:

1. A dedicated `cron-service` decoder extracting `service_user` and `command`.
2. Custom rule `111801`, level `8`, mapped to MITRE `T1053.003`.
3. Explicit Linux collection of `/var/log/syslog`, the source confirmed to contain fresh Cron events.

After the change, the same offline test produced:

```text
decoder.name: cron-service
service_user: sysadmin
command: /tmp/evil.sh
rule.id: 111801
rule.level: 8
MITRE: T1053.003
Alert to be generated.
```

![After the fix, Wazuh logtest matches Rule 111801](./evidence/04-T1053-003/after-fix/01-logtest-rule-111801-success.png)

Live manager events then confirmed rule `111801` for `wazuh-linux-agent`, command `/tmp/evil.sh`, and user `sysadmin`.

![Live Rule 111801 event from wazuh-linux-agent](./evidence/04-T1053-003/after-fix/05-live-rule-111801-event-details.png)

**Result: PASS AFTER FIX**

No Cron case was created in TheHive. That is an integration-scope limitation—the Week 3 bridge remained scoped to the port-scan/rule `86601` flow—not a failure of the Cron detection.

See the detailed [T1053 report](./attack-tests/T1053.003.md) and [detection engineering artifacts](./detection-engineering/cron-decoder.md).

### T1552.001 — Credentials In Files: coverage gap

The test used only a fake credential file:

```text
/tmp/atomic-git-creds-test/.git-credentials
```

Atomic `T1552.001-25` was restricted to that directory and completed with exit code `0`. Wazuh produced no relevant alert. Suricata was not expected to detect a local filesystem search, and without a Wazuh alert no TheHive case was expected.

![Safe fake credential file prepared in an isolated directory](./evidence/05-T1552-001/02-dummy-git-credential-prepared.png)

![T1552.001 Atomic test completed successfully](./evidence/05-T1552-001/03-atomic-execution-success.png)

**Result: COVERAGE GAP** — credential-file discovery behavior is not currently covered.

### T1070.004 — File Deletion: FIM-scope gap

After resolving the missing-file prerequisite, Atomic `T1070.004-1` deleted:

```text
/tmp/victim-files/T1070.004-test.txt
```

The test returned exit code `0`, and `Test-Path` returned `False`. Wazuh produced no T1070.004 detection. Inspection showed that FIM monitored `/etc`, `/usr/bin`, `/usr/sbin`, and `/boot`, but not `/tmp`.

![T1070.004 deletes the test file successfully](./evidence/06-T1070-004/04-file-deletion-success.jpg)

![Existing FIM paths do not include the test location under tmp](./evidence/06-T1070-004/06-file-outside-fim-scope.jpg)

**Result: COVERAGE GAP** — the file was outside the configured FIM scope. The lab was not changed solely to make the test green; whether selected temporary paths merit monitoring should be decided through risk and noise analysis.

## Final ATT&CK coverage matrix

| Technique | Tactic | Suricata | Wazuh | TheHive | Result | Notes |
| --- | --- | --- | --- | --- | --- | --- |
| T1046 Network Service Scanning | Discovery | Yes | Yes | Yes | **PASS** | Atomic timed out after 120s, but generated traffic triggered full detection and enrichment |
| T1059.004 Unix Shell | Execution | Traffic only; no alert | No | No | **COVERAGE GAP** | Current Linux process/shell telemetry is insufficient |
| T1053.003 Cron | Persistence | N/A | Yes, after fix | No | **PASS AFTER FIX** | Added Cron decoder, rule `111801`, ATT&CK mapping, and explicit syslog collection |
| T1552.001 Credentials In Files | Credential Access | N/A | No | No | **COVERAGE GAP** | Credential-file discovery is not currently covered |
| T1070.004 File Deletion | Defense Evasion | N/A | No | No | **COVERAGE GAP** | Test file was outside current FIM scope |

See the standalone [coverage matrix](./coverage/attack-coverage-matrix.md).

## SOC lead briefing

### Strongest current coverage

Network reconnaissance. T1046 proved the complete chain from a controlled Atomic action through network detection, SIEM ingestion, automated case creation, observable handling, and reputation enrichment.

### Detection improved during Week 4

Cron persistence. The host already generated useful telemetry, but Wazuh did not decode it and the Linux agent was not collecting the reliable syslog source. The decoder, rule, ATT&CK mapping, and log-source changes converted a silent gap into a live level-8 detection.

### Highest-priority gaps

1. Add Linux process-execution telemetry for T1059.004 and related execution techniques.
2. Design credential-access visibility for T1552.001 using process telemetry and carefully selected sensitive-path monitoring.
3. Review high-risk temporary paths for FIM without broadly monitoring `/tmp` and creating excessive noise.
4. Generalize TheHive routing beyond rule `86601` using explicit allowlists, MITRE mapping, severity, signature checks, and deduplication.

Read the complete [SOC lead briefing](./documentation/soc-lead-briefing.md).

## Troubleshooting preserved

The detailed troubleshooting record includes:

- Microsoft repository package download failure and explicit recovery.
- PowerShell module installation and parent/sub-technique lookup issues.
- Root PowerShell module visibility, dependency, and Atomics-path problems.
- T1046 prerequisite and 120-second timeout interpretation.
- T1059 parameter, `$HOME`, and root-owned execution-log problems.
- T1053 telemetry, decoder, log-source, backup-command, filename, and glob investigation.
- Unrelated `analysisd` IOC-list warnings that were not misclassified as Cron errors.
- T1070 prerequisite behavior and FIM-scope analysis.

See [documentation/troubleshooting.md](./documentation/troubleshooting.md).

## Results

- Atomic Red Team installed and verified on Linux.
- Five techniques tested across five ATT&CK tactics.
- T1046 passed across the complete Suricata → Wazuh → TheHive → Cortex chain.
- A genuine Cron pipeline failure was isolated and fixed.
- Rule `111801` generated live level-8 alerts mapped to `T1053.003`.
- Three legitimate coverage gaps were documented without inflating results.
- The boundary between Wazuh detection and TheHive routing was preserved.
- A final ATT&CK coverage matrix and SOC improvement plan were produced.

## Repository guide

| Path | Purpose |
| --- | --- |
| [`attack-tests/`](./attack-tests/) | Technique-by-technique execution, evidence, and outcome |
| [`detection-engineering/`](./detection-engineering/) | Cron decoder, rule `111801`, and syslog collection fix |
| [`decoders/cron-service-decoder.xml`](./decoders/cron-service-decoder.xml) | Reusable sanitized decoder artifact |
| [`rules/cron-rule-111801.xml`](./rules/cron-rule-111801.xml) | Reusable sanitized Wazuh rule artifact |
| [`configs/linux-syslog-localfile.xml`](./configs/linux-syslog-localfile.xml) | Linux syslog collection block used by the fix |
| [`documentation/setup.md`](./documentation/setup.md) | Baseline, safe testing, and Atomic installation |
| [`documentation/troubleshooting.md`](./documentation/troubleshooting.md) | Full problem → investigation → fix history |
| [`documentation/lessons-learned.md`](./documentation/lessons-learned.md) | Engineering lessons from the tests |
| [`documentation/soc-lead-briefing.md`](./documentation/soc-lead-briefing.md) | Coverage, gaps, risk, and priorities |
| [`coverage/attack-coverage-matrix.md`](./coverage/attack-coverage-matrix.md) | Final ATT&CK coverage result |
| [`coverage/future-detection-priorities.md`](./coverage/future-detection-priorities.md) | Recommended roadmap |
| [`evidence/README.md`](./evidence/README.md) | Screenshot inventory, placement, and sanitization rules |

## Key lessons

- Successful attack execution and successful detection are separate outcomes.
- A host log proves telemetry exists; it does not prove the SIEM collects or decodes it.
- Offline decoder/rule validation and live collection validation answer different questions.
- A timeout does not erase telemetry already generated.
- The absence of a TheHive case does not invalidate a Wazuh alert when automation routing is intentionally narrow.
- Honest coverage gaps are useful engineering results because they identify the next telemetry and detection investments.

All testing was performed in an isolated educational lab. Secrets, real credentials, authentication material, and sensitive session data are excluded.
