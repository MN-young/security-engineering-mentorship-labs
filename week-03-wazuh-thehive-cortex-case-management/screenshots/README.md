# Week 3 Evidence Index

The public evidence set was reduced from the full troubleshooting history to a chronological, security-reviewed selection. Screenshots exposing API keys, passwords, bearer tokens, session cookies, authentication headers, or other secrets were excluded.

## Results

| File | Evidence |
| --- | --- |
| `results/01-cortex-hash-analyzer-jobs.png` | Successful VirusTotal analyzer jobs for the known EICAR hash |
| `results/02-virustotal-eicar-enrichment.png` | Detailed VirusTotal report returned for the EICAR test |
| `results/03-wazuh-thehive-integration-success.png` | Earlier automation log showing case, observable, and Cortex request milestones |
| `results/04-thehive-automated-case-214.png` | Earlier structured TheHive case created from Wazuh rule `86601` |
| `results/05-thehive-automated-observable.png` | Source IP automatically added to earlier Case `#214` |
| `results/06-cortex-automated-enrichment-job.png` | Earlier Cortex job evidence for the automatically created observable |
| `results/07-thehive-automated-case-enrichment-tags.png` | Earlier automatically created case with returned VirusTotal tags |
| `results/08-thehive-automated-case-virustotal-report.png` | Earlier VirusTotal report opened from an automated case |
| `results/09-wazuh-suricata-alert-details.jpeg` | Suricata SID `1000001` detection details in Wazuh |
| `results/10-wazuh-rule-86601-mapping.jpeg` | Wazuh rule `86601`, `eve.json`, and decoded Suricata context |
| `results/11-thehive-automated-case-216.jpeg` | Authoritative final Case `#216`, automatically created by Wazuh Integration |
| `results/12-thehive-case-216-enrichment-tags.jpeg` | Automatic Case `#216` observable with `12 resolution(s)` and `0/89` tags |
| `results/13-cortex-virustotal-report-success.jpeg` | Successful `VirusTotal_GetReport_3_1` job with an actual report payload |
| `results/14-final-automation-success-log.jpeg` | Correlated Case `#216` creation, helper, observable, and Cortex request log |

## Troubleshooting

| File | Evidence |
| --- | --- |
| `troubleshooting/01-integration-retry-and-permission-errors.png` | Authorization, readiness, retry, and execution problems before automation succeeded |
| `troubleshooting/02-virustotal-connectivity-failure.jpeg` | Temporary VirusTotal HTTPS failure during the VMware NAT/DHCP outage; troubleshooting evidence only |

## Evidence interpretation

- Results `01`–`02` independently validate the analyzer with a known EICAR hash.
- Results `03`–`08` preserve earlier implementation and validation milestones.
- Results `09`–`14` are the authoritative final evidence for the fresh post-recovery run.
- Case `#216` proves automatic case creation, automatic observable creation, successful Cortex execution, and the VirusTotal report returned to TheHive.
- The private IP observable validates orchestration; `0/89` is expected and should not be interpreted as malicious reputation.
- The VirusTotal connection-error image documents a resolved network outage and is not presented as the final result.

## Excluded material

The following categories were deliberately omitted:

- screenshots containing passwords or API keys,
- terminal commands containing bearer tokens or authentication headers,
- browser developer tools exposing TheHive session cookies,
- duplicate screenshots,
- failed states without a distinct troubleshooting lesson,
- unrelated setup and social-post drafts.

