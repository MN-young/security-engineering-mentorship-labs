# Week 3 Architecture

## Purpose

The Week 3 workflow converts a network detection into a managed case and then enriches an indicator associated with that case.

```text
Controlled traffic
      ↓
Suricata detection (SID 1000001)
      ↓
Wazuh alert (rule 86601)
      ↓
custom-thehive
      ↓
TheHive case
      ↓
thehive-enrich
      ↓
TheHive observable
      ↓
Cortex analyzer
      ↓
VirusTotal result
```

## Component responsibilities

### Suricata

Suricata performs network inspection. The Week 2 local rule assigns SID `1000001` to an internal TCP SYN-scan pattern and emits the resulting event to `eve.json`.

### Wazuh

The Wazuh agent collects `eve.json`. The manager decodes the Suricata JSON and represents the event as Wazuh rule `86601`.

These IDs belong to different layers:

- `1000001` identifies the custom Suricata signature.
- `86601` identifies the Wazuh rule that handled the Suricata alert.

### `custom-thehive`

The custom Wazuh integration receives the JSON alert path from Wazuh, extracts the case fields, and sends a case-creation request to TheHive. A successful request returns HTTP `201 Created`.

### TheHive

TheHive stores the investigation as a case. The final case preserved the detection title, rule and signature IDs, agent, source and destination addresses, timestamp, and workflow tags.

### `thehive-enrich`

The enrichment helper receives the new case context, adds the source address as an IP observable, waits for it to become available to the connector, and submits the Cortex job.

### Cortex and VirusTotal

Cortex executes `VirusTotal_GetReport_3_1`. The lab used two validation paths:

1. A known EICAR SHA-256 test hash, which returned a full report to TheHive.
2. The private source IP from the automatically created case, which proved automatic job submission and completion.

The private-IP job validates orchestration, not public reputation value.

## Manual and automated validation paths

The analyzer path was deliberately tested before the automation path:

```text
Manual test case → hash observable → Cortex → VirusTotal report
```

Once that contract worked, the alert-to-case path was validated:

```text
Wazuh alert → TheHive case
```

The stretch goal joined them:

```text
Wazuh alert → case → observable → Cortex job
```

This order isolated faults and prevented an analyzer issue from being mistaken for a Wazuh integration issue.

## Trust boundaries and secret handling

The workflow crosses several authenticated boundaries:

- Wazuh integration to TheHive API
- TheHive to Cortex connector
- Cortex to VirusTotal API

Secrets must not be embedded in screenshots, source files, command history, or Git commits. The lab used an external key file during integration testing; public examples use placeholders only. A production design should use a dedicated secret store, narrowly scoped service accounts, restricted file permissions, and key rotation.

## Production-hardening priorities

1. Filter on the intended Suricata SID or signature in addition to the Wazuh rule.
2. Deduplicate cases with a stable event fingerprint and time window.
3. Rate-limit case creation.
4. Use bounded exponential backoff for newly created observables.
5. Stop retrying on authorization errors until permissions are corrected.
6. Record correlation IDs across Wazuh, TheHive, and Cortex.
7. Monitor integration failures separately from detection alerts.
