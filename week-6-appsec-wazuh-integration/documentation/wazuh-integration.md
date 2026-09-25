# Wazuh AppSec integration

## Monitored files

The Linux endpoint used two JSON feeds:

```xml
<localfile>
  <log_format>json</log_format>
  <location>/var/log/semgrep/findings.json</location>
</localfile>

<localfile>
  <log_format>json</log_format>
  <location>/var/log/pip-audit/findings.json</location>
</localfile>
```

Each line must be a complete JSON object. Pretty-printed arrays are unsuitable for direct line-by-line collection.

## Semgrep normalization and replay

The Semgrep artifact was transformed into one event per line and enriched with stable fields such as `source`, `event_type`, `rule_id`, `severity`, `path`, and `message`.

Replacing the monitored file did not reliably trigger collection. The working replay pattern was:

```bash
sudo truncate -s 0 /var/log/semgrep/findings.json
sudo tee -a /var/log/semgrep/findings.json < semgrep-test-event.json >/dev/null
```

This preserves a visible write event for the collector.

## Working Semgrep rule hierarchy

The final rule design matched top-level decoded JSON fields directly:

```xml
<group name="week6,appsec,sast,integration,">
  <rule id="100200" level="3">
    <field name="source">semgrep</field>
    <description>Semgrep SAST finding: $(rule_id) in $(path): $(message)</description>
    <group>appsec,sast,semgrep</group>
  </rule>

  <rule id="100201" level="8">
    <if_sid>100200</if_sid>
    <field name="severity">ERROR</field>
    <description>Semgrep high-severity SAST finding: $(rule_id) in $(path): $(message)</description>
    <group>appsec,sast,semgrep</group>
  </rule>

  <rule id="100202" level="12">
    <if_sid>100200</if_sid>
    <field name="rule_id">python.flask.security.injection.tainted-sql-string.tainted-sql-string</field>
    <description>Semgrep SQL injection risk detected in app.py: $(message)</description>
    <group>appsec,sql_injection,semgrep</group>
  </rule>
</group>
```

The original rule description used temporary wording. The example above cleans up that label while preserving the tested match logic. It does not claim that the live manager file already used the polished wording.

The failed intermediate rules used `decoded_as json`. Although the event decoded as JSON, that design fell through to generic Rule `1002`. Those screenshots are troubleshooting history, not the final rule configuration.

## pip-audit normalization and replay

The normalized dependency event exposed fields including:

```json
{
  "source": "pip-audit",
  "event_type": "dependency_vulnerability",
  "package": "flask",
  "installed_version": "3.0.3",
  "vulnerability_id": "PYSEC-2026-2151",
  "fix_versions": ["3.1.3"]
}
```

Two normalized records were present. Byte-for-byte deduplication did not remove them, so the controlled replay retained the first complete event explicitly:

```bash
head -n 1 /var/log/pip-audit/findings.json | sudo tee /tmp/pip-clean.json >/dev/null
sudo truncate -s 0 /var/log/pip-audit/findings.json
sudo tee -a /var/log/pip-audit/findings.json < /tmp/pip-clean.json >/dev/null
```

## Rule 100203

The built-in Wazuh JSON decoder exposed the pip-audit fields; no custom decoder was needed.

```xml
<group name="week6,appsec,dependency-audit,">
  <rule id="100203" level="12">
    <field name="source">pip-audit</field>
    <field name="event_type">dependency_vulnerability</field>
    <description>pip-audit vulnerable dependency detected: $(package) $(installed_version) - $(vulnerability_id)</description>
    <group>appsec,dependency_vulnerability,pip-audit</group>
  </rule>
</group>
```

## Validation method

- Run `wazuh-analysisd -t` after rule edits. Unrelated Rule `7616` list warnings were present, but the command returned `0`.
- Use `wazuh-logtest` to verify the decoded fields, final rule ID, level, and `Alert to be generated` result.
- Use exact searches in `alerts.json` for `source` or the target rule ID.
- Query the Wazuh dashboard with `rule.id:100202` or `rule.id:100203`.

`archives.json` was not enabled in this lab. Validation therefore relied on `alerts.json`, `wazuh-logtest`, live alert evidence, and the dashboard.

## Verified outcomes

- Rule `100202`: Level 12, verified by logtest, live alerts, and three dashboard hits.
- Rule `100203`: Level 12, verified by logtest and live alert output.
