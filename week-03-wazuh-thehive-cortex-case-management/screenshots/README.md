# Week 3 Evidence Index

The public evidence set was reduced from the full troubleshooting history to a small, chronological selection. Screenshots that exposed API keys, passwords, bearer tokens, session cookies, or other authentication material were excluded rather than committed.

## Results

| File | Evidence |
| --- | --- |
| `results/01-cortex-hash-analyzer-jobs.png` | Successful VirusTotal analyzer jobs for the known EICAR hash |
| `results/02-virustotal-eicar-enrichment.png` | Detailed VirusTotal report returned to TheHive |
| `results/03-wazuh-thehive-integration-success.png` | Case creation, helper launch, observable creation, and Cortex submission success |
| `results/04-thehive-automated-case-214.png` | Structured TheHive case automatically created from Wazuh rule `86601` |
| `results/05-thehive-automated-observable.png` | Source IP automatically added to Case `#214` |
| `results/06-cortex-automated-enrichment-job.png` | Cortex job success for the same automatically created IP observable |

## Troubleshooting

| File | Evidence |
| --- | --- |
| `troubleshooting/01-integration-retry-and-permission-errors.png` | Authorization, readiness, retry, and execution problems encountered before the final success |

## Evidence interpretation

- The EICAR hash test demonstrates a complete VirusTotal report returning to TheHive.
- The Case `#214` sequence demonstrates automatic alert-to-case, observable creation, and Cortex job submission.
- The private IP observable validates orchestration; it should not be interpreted as a meaningful public threat-reputation result.
- The TheHive observable screenshot was captured before its report panel refreshed. Cortex Jobs History is the completion record for that automatic job.
- The troubleshooting image is intentionally contextualized and is not presented as the final state.

## Excluded material

The following categories were deliberately omitted:

- screenshots containing passwords or API keys,
- terminal commands containing bearer tokens,
- browser developer tools exposing TheHive session cookies,
- duplicate screenshots,
- failed states that did not add a distinct troubleshooting lesson,
- unrelated setup and social-post drafts.
