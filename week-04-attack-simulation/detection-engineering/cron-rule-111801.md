# Wazuh Rule 111801 — Cron Persistence

## Detection goal

Generate a level-8 Wazuh alert for events decoded as `cron-service`, preserve the executing user and command in the description, and map the alert to MITRE ATT&CK `T1053.003`.

## Sanitized rule

```xml
<group name="cron-service,">
  <rule id="111800" level="0">
    <decoded_as>cron-service</decoded_as>
    <description>Journald logs for CRON.</description>
  </rule>

  <rule id="111801" level="8">
    <if_sid>111800</if_sid>
    <match>CMD</match>
    <description>CRON: The $(service_user) user executed ($(command)) on $(hostname).</description>
    <mitre>
      <id>T1053.003</id>
    </mitre>
  </rule>
</group>
```

The reusable XML is available at [rules/cron-rule-111801.xml](../rules/cron-rule-111801.xml).

![Rule 111801 with level and ATT&CK mapping](../evidence/04-T1053-003/root-cause/06-rule-111801-added.png)

## Offline validation

After the decoder and rule were added, `wazuh-logtest` reported:

```text
rule.id: 111801
rule.level: 8
MITRE: T1053.003
Alert to be generated.
```

`wazuh-analysisd -t` also emitted warnings about pre-existing malicious IOC lists and rules in the `9990x` range. Those warnings were unrelated to the Cron rule; no Cron XML syntax failure was observed.

## Live validation

After explicit `/var/log/syslog` collection was enabled on the Linux endpoint, live Wazuh events showed:

```text
agent.name:      wazuh-linux-agent
decoder.name:    cron-service
rule.id:         111801
rule.level:      8
service_user:    sysadmin
command:         /tmp/evil.sh
rule.mitre.id:   T1053.003
```

![Live Rule 111801 event details](../evidence/04-T1053-003/after-fix/05-live-rule-111801-event-details.png)

![Live level-8 and MITRE T1053.003 fields](../evidence/04-T1053-003/after-fix/06-mitre-t1053-003-validation.png)

## Scope and tuning

This lab rule demonstrates successful decoding, field extraction, ATT&CK mapping, and live alerting. In production, Cron activity should be tuned against expected administrative jobs and enriched with file ownership, path, parent process, account context, and change provenance.

Rule `111801` did not create a TheHive case because the existing integration routing remained scoped to the port-scan/rule `86601` workflow.
