# Playbook — Node-by-Node Logic

## 1. Wazuh Alert Webhook

Receives the Wazuh alert as JSON. The webhook must remain enabled and reachable from the Wazuh manager. Its identifier functions as an access secret and is omitted here.

Expected input fields are documented in [the architecture data contract](../architecture/final-soar-architecture.md#data-contract).

## 2. Higher-value alert filter

The demonstrated branch uses two AND conditions:

```text
rule.level > 6
rule.id != 111801
```

False results stop on this branch. True results continue to Slack alerting and enrichment.

## 3. Slack Alert

Posts the initial Wazuh event before enrichment completes. The message includes:

- rule ID and Wazuh level;
- alert description;
- agent name and IP;
- affected file path;
- timestamp.

The destination webhook is a protected value and is not included in screenshots or examples.

## 4. VirusTotal Lookup

Performs:

```text
GET https://www.virustotal.com/api/v3/files/<syscheck.sha256_after>
```

The `x-apikey` value is stored outside the playbook documentation. Network reachability by itself is not accepted as proof of enrichment; the validation requires an actual API status and downstream routing.

## 5. HTTP 200 condition

When the response status is `200`, the known-hash route extracts relevant fields from `data.attributes.last_analysis_stats` and posts them to **Slack Enrichment**, together with the SHA-256 and a VirusTotal report link.

Engine counts are point-in-time values and must not be hard-coded as permanent truth.

## 6. HTTP 404 condition

When the response status is `404`, the no-record route posts to **Slack Not Found**. The message states that no existing VirusTotal record was found for the SHA-256 and preserves the lookup status/details for analyst context.

This is a successful playbook decision, not an integration error.

## 7. Missing error route

The current lab explicitly demonstrates only `200` and `404`. See [decision-flow.md](../architecture/decision-flow.md#recommended-third-branch) for the recommended operational-error branch.

