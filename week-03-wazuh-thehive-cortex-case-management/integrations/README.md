# Integration Scripts — Public-Safe Notes

Two custom scripts implemented the verified Week 3 automation:

```text
/var/ossec/integrations/custom-thehive
/var/ossec/integrations/thehive-enrich
```

Final lab copies were preserved with `.week3-final` suffixes after validation.

## `custom-thehive`

Verified responsibilities:

1. Receive the Wazuh JSON alert.
2. Parse rule, signature, agent, source, destination, and timestamp fields.
3. Create a tagged TheHive case.
4. Confirm HTTP `201 Created`.
5. Launch the enrichment helper with the newly created case context.

## `thehive-enrich`

Verified responsibilities:

1. Add the source IP as an observable to the created case.
2. Parse the observable ID from the API response.
3. Retry briefly while the new observable becomes available to the connector.
4. Request `VirusTotal_GetReport_3_1` through the Cortex connector.
5. Record observable creation and Cortex request outcomes in the integration log.

## Why the deployed source is not reproduced here

The deployed scripts were edited interactively during troubleshooting and contained environment-specific endpoints and secret-loading details. The available evidence verifies their behavior but is not sufficient to reconstruct every final line without invention.

This portfolio therefore publishes:

- the verified responsibilities,
- the exact Wazuh integration trigger,
- the reproducible validation sequence,
- sanitized request patterns,
- the failures and fixes,
- the final success evidence.

It does not publish API keys, passwords, bearer tokens, session cookies, or an unverified reconstruction presented as the original script.

## Sanitized request pattern

Public examples should load credentials from the environment or a protected secret file:

```bash
export THEHIVE_URL="http://127.0.0.1:9000"
export THEHIVE_API_KEY="<load-from-secret-store>"
```

Requests should reference the variable rather than a literal secret:

```bash
curl --fail-with-body \
  -H "Authorization: Bearer ${THEHIVE_API_KEY}" \
  -H "Content-Type: application/json" \
  "${THEHIVE_URL}/api/v1/case"
```

Real deployments should avoid exporting long-lived secrets into shell history and should use a dedicated secret-management mechanism.

## Final validation boundary

An HTTP `201` from the connector proves that the analyzer request was accepted; it does not by itself prove enrichment completed. The authoritative final run therefore also verified Cortex Job Details and the resulting TheHive observable.

For Case `#216`, `VirusTotal_GetReport_3_1` executed with status `Success`, returned an actual report payload, and populated TheHive with:

```text
VT:GetReport="12 resolution(s)"
VT:GetReport="0/89"
```

This repository treats the returned TheHive report—not submission alone—as the completion boundary.

