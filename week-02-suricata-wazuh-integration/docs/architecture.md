# Week 2 Architecture — Suricata and Wazuh

## Purpose

This lab added network-layer telemetry to the Wazuh environment. Suricata inspected traffic on the Linux endpoint, wrote structured events to `eve.json`, and the Wazuh agent forwarded those events for centralized analysis and investigation.

## Components

### Nmap test source

The Wazuh Manager VM also served as the controlled scan source:

```text
Host: wazuh-manager
Address: 192.168.244.128
```

It generated a TCP SYN scan against the Suricata sensor to validate the detection pipeline.

### Suricata sensor

Suricata ran on:

```text
Host: wazuh-linux-agent
Address: 192.168.244.129
Interface: ens33
```

Its responsibilities were to capture network traffic, evaluate rules, and write structured JSON events to `/var/log/suricata/eve.json`.

### Wazuh Agent

The Wazuh agent on the same Linux endpoint monitored `eve.json` with JSON log formatting and forwarded the records to the Wazuh Manager.

### Wazuh Manager and ruleset

The Manager decoded the Suricata JSON and evaluated it using Wazuh's Suricata integration rules. The successful custom Suricata alert was processed under Wazuh rule `86601`.

### Wazuh Dashboard

Threat Hunting provided the investigation surface. The final alert was located with:

```text
data.alert.signature_id:1000001
```

## End-to-end data flow

```text
wazuh-manager
192.168.244.128
Nmap SYN scan
      │
      ▼
wazuh-linux-agent
192.168.244.129
ens33
      │
      ▼
Suricata
Custom SID 1000001
      │
      ▼
/var/log/suricata/eve.json
      │
      ▼
Wazuh Agent
      │
      ▼
Wazuh Manager
Rule 86601
      │
      ▼
Wazuh Threat Hunting
```

## Identifier mapping

| Identifier | Layer | Meaning |
| --- | --- | --- |
| `1000001` | Suricata | Local signature for internal TCP SYN-scan behavior |
| `86601` | Wazuh | Rule that processed the Suricata alert |

These identifiers are not interchangeable. The Suricata SID identifies the network signature; the Wazuh rule ID identifies how Wazuh categorized the ingested alert.

## Network-variable behavior

The lab configuration classified RFC1918 networks as `HOME_NET`:

```yaml
HOME_NET: "[192.168.0.0/16,10.0.0.0/8,172.16.0.0/12]"
EXTERNAL_NET: "!$HOME_NET"
```

Both test systems used `192.168.244.x`, so the scan direction was `HOME_NET → HOME_NET`. This mattered because many stock signatures inspected during troubleshooting were designed around traffic entering from `EXTERNAL_NET`.
