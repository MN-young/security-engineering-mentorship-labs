# Week 4 MITRE ATT&CK Coverage Matrix

## Final results

| Technique | Tactic | Suricata | Wazuh | TheHive | Result | Notes |
| --- | --- | --- | --- | --- | --- | --- |
| T1046 Network Service Scanning | Discovery | **Yes** | **Yes** | **Yes** | **PASS** | Atomic Nmap timed out after 120 seconds, but generated traffic triggered Suricata SID `1000001`, Wazuh rule `86601`, TheHive Case `#231`, an observable, and VirusTotal enrichment |
| T1059.004 Unix Shell | Execution | Traffic only; no alert | **No** | **No** | **COVERAGE GAP** | Atomic succeeded and `/tmp/art.sh` existed; current Linux process/shell telemetry was insufficient |
| T1053.003 Cron | Persistence | N/A | **Yes, after fix** | **No** | **PASS AFTER FIX** | Added the `cron-service` decoder, rule `111801`, MITRE mapping, and explicit `/var/log/syslog` collection |
| T1552.001 Credentials In Files | Credential Access | N/A | **No** | **No** | **COVERAGE GAP** | Safe fake credential-file search executed successfully but is not currently covered |
| T1070.004 File Deletion | Defense Evasion | N/A | **No** | **No** | **COVERAGE GAP** | Atomic deleted a file under `/tmp`, outside current FIM monitoring scope |

## Result definitions

- **PASS:** expected telemetry and downstream controls completed for the intended scope.
- **PASS AFTER FIX:** a real control-path fault was proven, corrected, and validated live.
- **COVERAGE GAP:** the technique executed, but current telemetry, rule logic, or monitoring scope did not generate the expected detection.
- **N/A:** the sensor was not relevant to the local activity being tested.

## Important interpretation

TheHive coverage is not equivalent to Wazuh coverage. The Week 3 integration was intentionally routed around the port-scan workflow using Wazuh rule `86601`. T1053.003 therefore passed at the Wazuh detection layer even though it did not create a TheHive case.

Similarly, the T1046 Atomic timeout is not counted as a detection failure because the generated traffic was independently observed across Suricata, Wazuh, TheHive, and Cortex.

## Coverage summary

| Category | Count |
| --- | ---: |
| Techniques tested | 5 |
| Full-chain passes | 1 |
| Passes after pipeline repair | 1 |
| Documented coverage gaps | 3 |
| Genuine SOC pipeline bugs found and fixed | 1 |

## Versioning recommendation

Treat this matrix as a baseline, not a permanent score. After adding process telemetry, expanding selected detections, or changing FIM/routing scope, rerun the same Atomics and record a new dated matrix instead of overwriting the historical result.
