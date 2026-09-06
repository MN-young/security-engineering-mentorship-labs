# Week 3 Validation Sequence

This sequence documents how the completed workflow was validated. Addresses are private lab values; secrets are represented by placeholders.

## 1. Validate the analyzer independently

1. Create a test case in TheHive.
2. Add a SHA-256 observable for the standard EICAR test file.
3. Confirm `VirusTotal_GetReport_3_1` is available from Cortex.
4. Launch the analyzer.
5. Confirm a successful job in Cortex Jobs History.
6. Confirm the report is attached to the TheHive observable.

Expected evidence:

```text
Analyzer: VirusTotal_GetReport_3_1
Status:   Success
Result:   61/68 malicious for the known test hash
```

## 2. Validate TheHive API access without exposing a key

Use a protected environment variable or secret store:

```bash
export THEHIVE_URL="http://127.0.0.1:9000"
export THEHIVE_API_KEY="<load-from-secret-store>"
```

A current-user or test-case request should use the variable in the authorization header. Do not place the literal key in source control or shell history.

Expected result:

```text
HTTP 200 for identity/status checks
HTTP 201 for successful object creation
```

## 3. Validate the Wazuh trigger configuration

Confirm the manager contains:

```xml
<integration>
  <name>custom-thehive</name>
  <rule_id>86601</rule_id>
  <alert_format>json</alert_format>
</integration>
```

Validate the Wazuh configuration using the method appropriate for the installed version, then restart the manager only after successful validation.

## 4. Generate the controlled alert

From the lab scanner/Wazuh manager (`192.168.244.128`), run the Week 2 test against the Suricata sensor (`192.168.244.129`):

```bash
sudo nmap -sS -p 1-1000 -T4 192.168.244.129
```

Confirm the native and Wazuh identifiers:

```text
Suricata signature ID: 1000001
Wazuh rule ID:         86601
Signature:             LOCAL TCP Port Scan Detected
```

## 5. Verify the automation chain

Check the integration log for one correlated execution:

```text
SUCCESS rule=86601 HTTP=201
ENRICH_HELPER_LAUNCHED
OBSERVABLE_SUCCESS
CORTEX_SUCCESS ... HTTP=201
```

Then verify in the interfaces:

1. A new TheHive case was created by the Wazuh integration.
2. The title identifies rule `86601` and the port-scan signature.
3. The description contains rule, signature, agent, source, destination, and timestamp fields.
4. The source IP appears as a case observable.
5. Cortex Jobs History shows `VirusTotal_GetReport_3_1` with status `Success` for that observable.

## 6. Negative and tuning tests

A production-oriented revision should also validate:

- a different Suricata alert mapped to rule `86601` does not create a port-scan case,
- a repeated identical alert inside the deduplication window does not create another case,
- an expired or unauthorized API identity fails without indefinite retry,
- a temporary observable-readiness `404` retries only within a bounded window,
- an analyzer outage records an actionable integration error.

These tuning tests describe the next hardening step; they are not claimed as completed Week 3 controls.
