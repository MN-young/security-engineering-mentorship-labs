# Slack Message Templates

The examples below are intentionally credential-free. Field expressions are described generically because exact Shuffle expression syntax may vary by node and version.

## Initial alert

```text
🚨 WAZUH SECURITY ALERT
Rule ID: <rule.id>
Wazuh Level: <rule.level>
Alert: <rule.description>
Agent: <agent.name>
Agent IP: <agent.ip>
File: <syscheck.path>
Time: <timestamp>
```

## Known-hash enrichment — HTTP 200

```text
🔎 VIRUSTOTAL ENRICHMENT
Rule ID: <rule.id>
SHA-256: <syscheck.sha256_after>
VirusTotal Status: 200

🧪 ANALYSIS RESULTS
Malicious: <last_analysis_stats.malicious>
Suspicious: <last_analysis_stats.suspicious>
Harmless: <last_analysis_stats.harmless>
Undetected: <last_analysis_stats.undetected>

Result: Known file found in VirusTotal
Report: https://www.virustotal.com/gui/file/<sha256>
```

## No-record result — HTTP 404

```text
🔎 VIRUSTOTAL — NO RECORD FOUND
Rule ID: <rule.id>
SHA-256: <syscheck.sha256_after>
VirusTotal Status: 404
Result: No existing VirusTotal record for this SHA-256.
Details: <error.message>
```

## Formatting guidance

- Keep the rule, host, file, hash, status, and event time visible without expanding attachments.
- Label a 404 as **no record found**, not **failed** or **clean**.
- Do not equate an unknown hash with a benign file.
- Avoid putting API keys, webhook URLs, cookies, or authorization headers in message bodies or debug output.
- Consider threading the enrichment response under the initial alert to reduce channel noise.
