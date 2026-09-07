# Week 3 — Wazuh, TheHive and Cortex Case Management

## Overview

Week 3 turned the Week 2 network detection into a case-management and enrichment workflow. A live Suricata port-scan alert was processed by Wazuh, passed to a custom integration, converted into a structured TheHive case, and enriched through Cortex.

The core objective and stretch goal were both validated:

```text
Nmap test
      ↓
Suricata SID 1000001
      ↓
Wazuh rule 86601
      ↓
Automatic TheHive case
      ↓
Automatic IP observable
      ↓
Automatic Cortex execution
      ↓
VirusTotal enrichment
      ↓
Report returned to TheHive
```

The most important engineering lesson was that a working integration is not automatically a well-tuned one. Authentication, permissions, asynchronous object availability, helper execution, error handling, and case deduplication all affected the result.

## Objectives

- Deploy TheHive and Cortex in the lab.
- Configure a VirusTotal analyzer and validate it with a known test indicator.
- Connect TheHive to Cortex so analyzers are available from a case.
- Build a Wazuh-to-TheHive integration for selected alerts.
- Reuse the Week 2 Suricata port-scan detection as a live trigger.
- Automatically create a meaningful TheHive case from the alert.
- Enrich an indicator associated with that case.
- Stretch goal: automatically create the observable, execute the Cortex analyzer, and return the enrichment report to TheHive during case creation.

## Lab components

| Component | Responsibility |
| --- | --- |
| Suricata | Generated the `LOCAL TCP Port Scan Detected` alert with SID `1000001` |
| Wazuh | Processed the Suricata event as rule `86601` and invoked the integration |
| `custom-thehive` | Parsed the Wazuh alert and created a structured TheHive case |
| TheHive | Managed the investigation case and its observables |
| `thehive-enrich` | Added the observable and requested the Cortex analysis |
| Cortex | Executed `VirusTotal_GetReport_3_1` and returned the job report |
| VirusTotal | Returned resolution and reputation data to TheHive |

TheHive and Cortex were deployed with Docker Compose alongside their supporting lab services. Existing Wazuh components from Weeks 1–2 remained the detection source.

## Architecture

```mermaid
flowchart LR
    A["Controlled Nmap test"] --> B["Suricata<br/>SID 1000001"]
    B --> C["Wazuh<br/>Rule 86601"]
    C --> D["custom-thehive"]
    D --> E["Automatic TheHive case"]
    E --> F["thehive-enrich"]
    F --> G["Automatic IP observable"]
    G --> H["Cortex<br/>VirusTotal_GetReport_3_1"]
    H --> I["VirusTotal enrichment"]
    I --> J["Report returned to TheHive"]
```

See [the architecture document](./docs/architecture.md) for component boundaries, identifiers, and trust considerations.

## Final end-to-end result

After a temporary network interruption was resolved, a fresh Nmap validation produced the authoritative final workflow:

```text
Nmap → Suricata SID 1000001 → Wazuh rule 86601
     → automatic TheHive Case #216
     → automatic IP observable
     → automatic VirusTotal_GetReport_3_1 execution
     → VirusTotal report returned to TheHive
```

Wazuh mapped the Suricata detection to rule `86601`:

![Wazuh Suricata alert details](./screenshots/results/09-wazuh-suricata-alert-details.jpeg)

![Wazuh rule 86601 mapping](./screenshots/results/10-wazuh-rule-86601-mapping.jpeg)

The integration log recorded the correlated automation milestones for Case `#216`:

```text
SUCCESS rule=86601 HTTP=201
ENRICH_HELPER_LAUNCHED
OBSERVABLE_SUCCESS
CORTEX_SUCCESS ... HTTP=201
```

![Final automation log for Case 216](./screenshots/results/14-final-automation-success-log.jpeg)

TheHive Case `#216` was created by **Wazuh Integration** and preserved the Wazuh rule ID, Suricata SID, agent, source, destination, and timestamp.

![Automatically created TheHive Case 216](./screenshots/results/11-thehive-automated-case-216.jpeg)

The source IP was added automatically as an observable. Its TheHive report contains the returned VirusTotal tags:

```text
VT:GetReport="12 resolution(s)"
VT:GetReport="0/89"
```

![VirusTotal enrichment tags returned to Case 216](./screenshots/results/12-thehive-case-216-enrichment-tags.jpeg)

Cortex Job Details confirms that `VirusTotal_GetReport_3_1` executed successfully for the same IP and returned an actual report payload.

![Successful Cortex VirusTotal report for Case 216](./screenshots/results/13-cortex-virustotal-report-success.jpeg)

## Implementation

### 1. Deploy and connect TheHive and Cortex

TheHive and Cortex were deployed as containerized lab services. The Cortex connector was added to TheHive and validated as enabled and healthy before analyzer testing.

The integration was first tested independently of Wazuh. This separated case-management and analyzer problems from alert-forwarding problems.

### 2. Validate VirusTotal enrichment with a test hash

A known EICAR test-file SHA-256 value was added to a controlled TheHive case as a hash observable. The `VirusTotal_GetReport_3_1` analyzer was launched through Cortex.

Cortex Jobs History recorded successful executions for the hash:

![Cortex jobs showing successful VirusTotal hash analysis](./screenshots/results/01-cortex-hash-analyzer-jobs.png)

The resulting TheHive report showed `61/68` malicious detections for the known test hash. This was stronger validation than using a private lab IP, because public reputation services do not normally provide meaningful reputation for RFC1918 addresses.

![VirusTotal enrichment report returned to TheHive](./screenshots/results/02-virustotal-eicar-enrichment.png)

### 3. Configure the Wazuh integration trigger

Wazuh was configured to run the custom integration for Suricata alerts processed as rule `86601`:

```xml
<integration>
  <name>custom-thehive</name>
  <rule_id>86601</rule_id>
  <alert_format>json</alert_format>
</integration>
```

The reusable, sanitized block is available in [`configs/wazuh-thehive-integration.xml`](./configs/wazuh-thehive-integration.xml).

API credentials were stored outside the public scripts and are not included in this repository. The original screenshots containing passwords, API keys, and session cookies were deliberately excluded.

### 4. Create a structured case from a live alert

The Week 2 controlled SYN-scan detection was reused as the trigger:

```text
Suricata signature: LOCAL TCP Port Scan Detected
Suricata SID:       1000001
Wazuh rule:         86601
```

The integration parsed the JSON alert and submitted a case to TheHive. A successful API response returned HTTP `201 Created`.

The automatically created case included:

- alert and rule identifiers,
- source and destination addresses,
- the reporting agent,
- event timestamp,
- `wazuh`, `suricata`, and `automated-case` tags.

### 5. Add the observable, execute Cortex, and return the report

The enrichment helper added the source IP to the newly created case as an observable, waited for the object to become available, and requested `VirusTotal_GetReport_3_1` through the TheHive-Cortex connector.

The final Case `#216` run proves more than job submission:

- the observable was created automatically,
- Cortex executed the VirusTotal analyzer successfully,
- the job returned an actual report payload,
- TheHive received the enrichment and displayed `12 resolution(s)` and `0/89` tags.

Because the indicator is an RFC1918 private lab (lab-only) address, the `0/89` reputation result is expected. The result validates orchestration and report return; the independent EICAR hash test remains the stronger malicious-indicator enrichment example.

Earlier Cases `#199` and `#214` remain in the evidence folder as implementation-progress records. Case `#216` is the authoritative final validation because it correlates case creation, observable creation, successful analyzer execution, and the returned report after network recovery.

## Success criteria

| Requirement | Result | Evidence |
| --- | --- | --- |
| A live Wazuh alert automatically creates a TheHive case | Complete | Integration HTTP `201` and Case `#216` |
| A Cortex analyzer enriches an indicator from the case workflow | Complete | `VirusTotal_GetReport_3_1` status `Success` with a returned report payload |
| Record the alert → case → enrichment pipeline | Complete | Final log, Case `#216`, observable tags, and Cortex report screenshots |
| Stretch: auto-trigger enrichment during case creation | Complete | Automatic observable, Cortex execution, and enrichment returned to TheHive |

## Troubleshooting and engineering decisions

The successful result required work across several layers:

- VirusTotal analyzer jobs initially failed before later succeeding.
- TheHive-Cortex connector health and container connectivity were validated independently.
- API authentication and account permissions produced authorization failures.
- The observable endpoint returned HTTP `403` until the integration permissions were corrected.
- Cortex submission returned temporary HTTP `404` responses while the new observable became available.
- Python syntax, indentation, response-shape, file-mode, and subprocess issues were corrected.
- The enrichment helper initially lacked executable permissions.
- A VMware NAT/DHCP outage blocked the manager and Cortex from reaching VirusTotal; restarting `VMnetDHCP` and `VMware NAT Service` restored the NAT path before the successful final run.
- Triggering on Wazuh rule `86601` alone created too many cases because that rule represents more than the intended custom Suricata signature.

![Integration troubleshooting showing permission and readiness errors](./screenshots/troubleshooting/01-integration-retry-and-permission-errors.png)

The full chronology, root causes, fixes, and lessons are documented in [`docs/troubleshooting.md`](./docs/troubleshooting.md).

## Detection and automation caveats

This is a controlled lab implementation, not a production-ready SOAR workflow.

- Wazuh rule `86601` can represent multiple Suricata alerts, not only SID `1000001`.
- Filtering only on `86601` caused repeated and unrelated case creation during testing.
- A production design should verify the Suricata signature ID or signature text before creating a case.
- Deduplication should use a stable event key and a time window.
- Retry logic should use bounded exponential backoff and distinguish authorization failures from temporary readiness failures.
- Private RFC1918 addresses are useful for workflow validation but weak indicators for public reputation enrichment.
- Service-account permissions and API credentials should follow least privilege and remain outside source control.

## Repository artifacts

| Path | Purpose |
| --- | --- |
| [`configs/wazuh-thehive-integration.xml`](./configs/wazuh-thehive-integration.xml) | Sanitized Wazuh integration block |
| [`integrations/README.md`](./integrations/README.md) | Verified script responsibilities and public-safe implementation notes |
| [`tests/README.md`](./tests/README.md) | Reproducible validation sequence and expected results |
| [`docs/architecture.md`](./docs/architecture.md) | Detailed data flow and trust boundaries |
| [`docs/troubleshooting.md`](./docs/troubleshooting.md) | Problem, investigation, root cause, fix, and lesson history |
| [`screenshots/README.md`](./screenshots/README.md) | Evidence inventory and security exclusions |

The exact deployed scripts contained environment-specific values and underwent live edits during troubleshooting. Rather than publish an incomplete reconstruction, this repository documents their verified behavior and includes only configuration that can be confirmed from the final evidence.

## Results

- TheHive and Cortex were deployed and connected.
- Cortex successfully executed VirusTotal analysis from TheHive.
- A known test hash returned a detailed enrichment report.
- A live Suricata/Wazuh alert automatically created a structured TheHive case.
- The source IP was automatically added as an observable.
- `VirusTotal_GetReport_3_1` executed automatically and returned its enrichment report to TheHive.
- Authentication, permission, readiness, execution, connectivity, and case-volume issues were investigated.
- The limitations of broad rule-based triggering and private-IP enrichment were documented.

## Skills demonstrated

- Security case management
- Wazuh custom integrations
- TheHive and Cortex administration
- REST API integration
- Python troubleshooting
- Docker and service connectivity
- Observable and indicator handling
- Threat-intelligence enrichment
- Automated alert-to-case orchestration
- Error handling and retry design
- Security credential hygiene
- Detection and automation tuning

## What I learned

End-to-end automation is a sequence of independently testable contracts. The alert must contain the right fields, the bridge must authenticate, the case API must accept the payload, the observable must become queryable, and Cortex must receive a valid analyzer request. Verifying each boundary separately made the final workflow reliable enough to demonstrate and revealed the next engineering priorities: precise filtering, deduplication, bounded retries, least privilege, and safer secret management.


