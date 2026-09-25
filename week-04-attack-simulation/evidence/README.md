# Week 4 Evidence Index

This directory contains the curated Week 4 screenshot evidence. Images were selected from the complete source set, renamed by what they prove, and grouped by testing stage. The main README uses the clearest result images; the technique reports and troubleshooting chronology use the supporting failure, investigation, and recovery evidence.

The evidence deliberately includes unsuccessful states. A failed command, missing alert, or incorrect path is retained when it explains an engineering decision or establishes the cause of a result.

## 00 — Safe testing and baseline

| Evidence | What it proves |
| --- | --- |
| [Pre-Week 4 snapshot](./00-baseline/01-pre-week4-atomic-snapshot.png) | A recoverable snapshot existed before installing the adversary-emulation tooling |
| [Linux endpoint baseline](./00-baseline/02-linux-endpoint-baseline.png) | Ubuntu version, hostname, address, and Wazuh Agent baseline |
| [Wazuh and Suricata active](./00-baseline/03-wazuh-suricata-services-active.png) | Both monitoring services were healthy before testing |

## 01 — PowerShell and Atomic Red Team installation

| Evidence | What it proves |
| --- | --- |
| [Repository package missing](./01-atomic-installation/01-microsoft-repository-package-missing.png) | The initial local `.deb` archive was unavailable |
| [Repository download recovered](./01-atomic-installation/02-microsoft-repository-download-recovered.png) | The explicit Ubuntu 24.04 download completed successfully |
| [PowerShell 7.6.5 installed](./01-atomic-installation/03-powershell-7-6-5-installed.png) | Required PowerShell runtime installed |
| [Combined module command error](./01-atomic-installation/04-combined-module-command-error.png) | Initial positional-parameter problem |
| [Modules and Atomic installed](./01-atomic-installation/05-modules-and-atomic-installed.png) | Module versions and Atomic directories verified after the fix |
| [Parent technique path error](./01-atomic-installation/06-parent-technique-path-error.png) | T1087 parent YAML was not present |
| [Sub-technique lookup succeeds](./01-atomic-installation/07-subtechnique-details-success.png) | T1087.001 loads correctly |
| [Five techniques verified](./01-atomic-installation/08-five-techniques-verified.png) | Selected ATT&CK technique content was present before execution |

## 02 — T1046 Network Service Scanning

| Evidence | What it proves |
| --- | --- |
| [Prerequisites not met](./02-T1046/01-prerequisites-not-met.png) | Elevation/Nmap prerequisite problem |
| [Root module not found](./02-T1046/02-root-module-not-found.png) | Elevated PowerShell could not see the CurrentUser installation |
| [Root missing powershell-yaml](./02-T1046/03-root-missing-powershell-yaml.png) | Root could not resolve the dependency |
| [Wrong Atomics path](./02-T1046/04-root-wrong-atomics-path.png) | Elevated session defaulted to `/root/AtomicRedTeam/atomics` |
| [Prerequisites passed](./02-T1046/05-prerequisites-passed.png) | Module and Atomics path corrections worked |
| [120-second timeout](./02-T1046/06-atomic-timeout-120-seconds.png) | Atomic wrapper timed out after generating scan traffic |
| [Suricata detection](./02-T1046/07-suricata-port-scan-detected.png) | SID `1000001`, source, and destination were recorded |
| [Wazuh Rule 86601](./02-T1046/08-wazuh-rule-86601-detected.png) | Suricata alert reached Wazuh |
| [TheHive Case 231](./02-T1046/09-thehive-case-231.png) | Existing automation created a structured case |
| [Observable and VirusTotal](./02-T1046/10-observable-virustotal-enrichment.png) | Source IP was added and enriched automatically |

## 03 — T1059.004 Unix Shell

| Evidence | What it proves |
| --- | --- |
| [Command/path error](./03-T1059-004/01-command-parameter-and-path-error.png) | Initial parameter and root-home conflict |
| [Bash execution success](./03-T1059-004/02-bash-execution-success.png) | Atomic prints the expected message and exits successfully |
| [Artifact confirmed](./03-T1059-004/03-artifact-confirmed.png) | `/tmp/art.sh` exists on the endpoint |
| [Wazuh no detection](./03-T1059-004/04-wazuh-no-detection.png) | No matching Wazuh alert |
| [Artifact and agent health](./03-T1059-004/05-host-artifact-agent-healthy.png) | Action occurred while the agent remained healthy |
| [Traffic without alert](./03-T1059-004/06-suricata-traffic-no-alert.png) | Network telemetry exists without a malicious signature match |
| [Root-owned execution log](./03-T1059-004/07-atomic-log-root-owned.png) | Prior elevated execution caused the logging permission problem |
| [Execution-log fix](./03-T1059-004/08-atomic-log-permission-fixed.png) | Targeted ownership repair restored writability |

## 04 — T1053.003 Cron

### Before the fix

| Evidence | What it proves |
| --- | --- |
| [Cron persistence executed](./04-T1053-003/before-fix/01-cron-persistence-executed.png) | Atomic created the scheduled `/tmp/evil.sh` command |
| [Host Cron telemetry](./04-T1053-003/before-fix/02-host-cron-telemetry-present.png) | The Linux host repeatedly recorded the command |
| [Wazuh no Cron detection](./04-T1053-003/before-fix/03-wazuh-no-cron-detection.png) | Initial SIEM search returned no result |
| [Journald/logcollector checked](./04-T1053-003/before-fix/04-journald-and-logcollector-checked.png) | Existing collection configuration and service health were investigated |
| [No TheHive Cron case](./04-T1053-003/before-fix/05-thehive-no-cron-case.png) | TheHive remained limited to the Rule `86601` workflow |

### Root cause and configuration work

| Evidence | What it proves |
| --- | --- |
| [No decoder matched](./04-T1053-003/root-cause/01-no-decoder-matched.png) | Exact Cron log fails in Wazuh Phase 2 before the fix |
| [Backup formatting error](./04-T1053-003/root-cause/02-backup-command-format-error.png) | Same-line backslash produced a malformed copy target |
| [Decoder filename typo](./04-T1053-003/root-cause/03-decoder-filename-typo.png) | `local_decoders.xml` was corrected to `local_decoder.xml` |
| [Glob issue and backup verification](./04-T1053-003/root-cause/04-backup-glob-and-verification.png) | Shell expansion issue and final explicit backup checks |
| [Cron decoder added](./04-T1053-003/root-cause/05-cron-service-decoder-added.png) | `cron-service` extracts user and command |
| [Rule 111801 added](./04-T1053-003/root-cause/06-rule-111801-added.png) | Level-8 rule and ATT&CK mapping were configured |

### After the fix

| Evidence | What it proves |
| --- | --- |
| [Offline logtest success](./04-T1053-003/after-fix/01-logtest-rule-111801-success.png) | Decoder and Rule `111801` match the same event |
| [Reliable syslog source](./04-T1053-003/after-fix/02-syslog-live-source-identified.png) | Fresh Cron events exist in `/var/log/syslog` |
| [Syslog collection added](./04-T1053-003/after-fix/03-syslog-collection-added.png) | Endpoint now monitors the reliable live source |
| [Live manager alert](./04-T1053-003/after-fix/04-live-rule-111801-alerts-json.png) | Rule fires live for `wazuh-linux-agent` |
| [Decoded event details](./04-T1053-003/after-fix/05-live-rule-111801-event-details.png) | Agent, command, user, and decoder fields are present |
| [MITRE validation](./04-T1053-003/after-fix/06-mitre-t1053-003-validation.png) | Level `8` and `T1053.003` are shown in Wazuh |

## 05 — T1552.001 Credentials In Files

| Evidence | What it proves |
| --- | --- |
| [Atomic details](./05-T1552-001/01-atomic-test-details.png) | Selected Git credential-file search Atomic |
| [Dummy credential prepared](./05-T1552-001/02-dummy-git-credential-prepared.png) | Safe isolated file containing fake values only |
| [Atomic execution success](./05-T1552-001/03-atomic-execution-success.png) | Test completes with exit code `0` |
| [Cleanup](./05-T1552-001/04-test-cleanup.jpg) | Temporary test artifacts removed |

## 06 — T1070.004 File Deletion

| Evidence | What it proves |
| --- | --- |
| [Details and initial prerequisite](./06-T1070-004/01-test-details-and-prerequisite-missing.jpg) | Test definition and missing-file condition |
| [Prerequisite missing](./06-T1070-004/02-prerequisite-file-missing.jpg) | Target did not initially exist |
| [Prerequisites met](./06-T1070-004/03-prerequisites-met.jpg) | Target prepared successfully |
| [Deletion success](./06-T1070-004/04-file-deletion-success.jpg) | Exit code `0` and `Test-Path False` |
| [Wazuh no detection](./06-T1070-004/05-wazuh-no-detection.jpg) | No matching file-deletion alert |
| [FIM scope](./06-T1070-004/06-file-outside-fim-scope.jpg) | Configured paths exclude `/tmp` |

## Sanitization

- No API keys, passwords, bearer tokens, cookies, authentication headers, or real credentials are included.
- The T1552 screenshot intentionally shows only the fake value `FAKE_ATOMIC_TOKEN_DO_NOT_USE` under the reserved domain `example.invalid`.
- RFC1918 lab addresses are retained because they explain source, target, and pipeline relationships.
- Duplicate screenshots and images that did not add distinct evidence were not published.
