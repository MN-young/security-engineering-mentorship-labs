# Linux Syslog Collection Fix

## Problem

The custom Cron decoder and rule worked in `wazuh-logtest`, and rule `111801` even fired live for another agent. However, `wazuh-linux-agent` still did not produce a live `/tmp/evil.sh` alert.

## Investigation

The endpoint was checked specifically:

- hostname was `wazuh-linux-agent`,
- journald collection was configured,
- `wazuh-agent` was running,
- `wazuh-logcollector` was running,
- fresh `CRON[...] (sysadmin) CMD (/tmp/evil.sh)` events existed after restart,
- no centralized `agent.conf` override explained the behavior.

Fresh events were consistently visible in `/var/log/syslog`, but that file was not present in the endpoint's monitored `<localfile>` blocks.

![Fresh Cron telemetry in var-log-syslog](../evidence/04-T1053-003/after-fix/02-syslog-live-source-identified.png)

## Fix

The following block was added inside the endpoint's `<ossec_config>`:

```xml
<localfile>
  <log_format>syslog</log_format>
  <location>/var/log/syslog</location>
</localfile>
```

The reusable configuration fragment is available at [configs/linux-syslog-localfile.xml](../configs/linux-syslog-localfile.xml).

![Explicit syslog localfile block added](../evidence/04-T1053-003/after-fix/03-syslog-collection-added.png)

The Wazuh Agent configuration was validated and the service was restarted.

## Result

Live manager and dashboard records then contained rule `111801`, level `8`, decoder `cron-service`, user `sysadmin`, command `/tmp/evil.sh`, and MITRE `T1053.003` for `wazuh-linux-agent`.

![Live alerts.json result after the collection fix](../evidence/04-T1053-003/after-fix/04-live-rule-111801-alerts-json.png)

## Lesson

Offline rule success proves that Wazuh can analyze a supplied event. It does not prove that the correct live endpoint is collecting the source containing that event. Decoder validation and source collection must both be verified.
