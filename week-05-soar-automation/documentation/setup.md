# Setup and Implementation

## Scope

This document records the implemented Week 5 build at a reproducible level while intentionally omitting all active credentials. It should be read with the [troubleshooting chronology](./troubleshooting.md) because several deployment stages required recovery work.

## 1. Prepare the Shuffle host

The dedicated Ubuntu host was placed on the existing isolated lab network and checked for:

- correct hostname and address;
- reachability to the Wazuh manager and internet-facing services;
- sufficient CPU, memory, and disk capacity;
- working name resolution and time synchronization.

Evidence: [Shuffle VM baseline](../evidence/00-baseline-install/2026-09-16-152142.png).

## 2. Install Docker and obtain Shuffle

Docker was installed and its standard test container ran successfully. The Shuffle repository was then cloned and its deployment files reviewed.

OpenSearch requires an appropriate virtual-memory map limit. The host was configured with:

```text
vm.max_map_count=262144
```

This value should be made persistent through the operating system's normal sysctl configuration.

Evidence:

- [Docker validation](../evidence/00-baseline-install/2026-09-17-095226.png)
- [Shuffle clone and kernel prerequisite](../evidence/00-baseline-install/2026-09-17-104205.png)
- [OpenSearch startup inspection](../evidence/00-baseline-install/2026-09-18-095639.png)

## 3. Start and validate Shuffle

The deployment was started and the core services were inspected individually rather than treating a running frontend as proof that executions would work. Validation included:

- frontend and backend availability;
- OpenSearch state;
- Orborus and worker state;
- backend-to-worker connectivity;
- worker network membership;
- ability to build or pull required app images;
- a completed test workflow execution.

The UI's initial administrator password was entered interactively and is neither documented nor visible in the retained screenshot.

## 4. Create and validate the webhook

A Shuffle webhook trigger was created. Before connecting Wazuh, a manual JSON POST tested the entry point. The response returned HTTP `200` and an execution identifier; the matching Shuffle run completed with `TASK26_OK`.

The webhook URL and UUID are secret-like bearer values. Replace the placeholder below with a managed secret at deployment time:

```text
http://<shuffle-host>:3001/api/v1/hooks/<SHUFFLE_WEBHOOK_ID>
```

The raw POST screenshots are not retained in the public evidence tree because they display the identifier. Safe validation: [finished webhook execution](../evidence/02-webhook-wazuh-integration/2026-09-19-141133.png).

## 5. Connect Wazuh

The Wazuh manager was configured to send JSON alerts to the Shuffle webhook. A sanitized structural example is:

```xml
<integration>
  <name>shuffle</name>
  <hook_url>http://&lt;shuffle-host&gt;:3001/api/v1/hooks/&lt;SECRET_ID&gt;</hook_url>
  <level>10</level>
  <alert_format>json</alert_format>
</integration>
```

The exact level in the manager integration and the later Shuffle condition serve different purposes: the former controls which alerts Wazuh forwards; the latter controls which received alerts continue on the illustrated playbook branch. After the configuration change, Wazuh was restarted and `wazuh-integratord` was checked.

A real-time FIM modification on `wazuh-linux-agent` generated Rule `550` and provided `syscheck.sha256_after`. Shuffle received the real event, proving the integration beyond the manual webhook test.

## 6. Configure Slack

A Slack app/incoming webhook was created for `#soc-alerts`. A direct post and simple placeholder messages established delivery before formatting was improved.

The final initial alert includes the rule ID, level, description, agent, IP, file, and timestamp. The incoming-webhook URL must be stored as a Shuffle secret and must not be shown in screenshots, workflow exports, command history, or repository files.

## 7. Add filtering

The demonstrated playbook branch uses:

```text
rule.level > 6 AND rule.id != 111801
```

The exclusion was added after repeated Rule `111801` Cron messages created visible noise in Slack. The condition should be reviewed whenever detection priorities or rule semantics change.

## 8. Add VirusTotal lookup

The HTTP action sends the post-change FIM hash to the VirusTotal file endpoint:

```text
GET https://www.virustotal.com/api/v3/files/<syscheck.sha256_after>
x-apikey: <VIRUSTOTAL_API_KEY>
```

The API key must be stored as a secret. It is not present in this repository.

## 9. Add result branches

Two conditions branch on the HTTP status:

- `200` → Slack Enrichment;
- `404` → Slack Not Found.

The 404 action is deliberately worded as **no record found**. An unknown hash is not proof that a file is benign, and the API response is not a transport failure.

## 10. Validate end to end

Two files exercised both routes:

1. A unique/custom file produced a new SHA-256 and the expected VirusTotal `404` result.
2. The standard harmless EICAR antivirus test string produced a known SHA-256 and VirusTotal `200` result with engine statistics.

For both tests, validation required the complete sequence: endpoint modification → Wazuh Rule 550 → Shuffle execution → API status → correct Slack message.

## Security checklist

- [x] No Slack webhook URL in repository text or images.
- [x] No Shuffle webhook identifier in repository text or images.
- [x] No VirusTotal API key or authorization header value.
- [x] No passwords, cookies, or private tokens.
- [x] EICAR described as a harmless test string.
- [x] Internal RFC1918 lab addresses retained only for architecture clarity.

