# End-to-End Validation

## Test A — Unknown custom file

**Purpose:** Prove that an unseen SHA-256 takes the expected no-record route.

**Input:** Unique benign text written to `/etc/week5_task26_final.txt` on `wazuh-linux-agent`.

**Observed chain:**

```text
File content change
  → Wazuh Rule 550
  → Shuffle webhook execution
  → initial Slack security alert
  → VirusTotal HTTP 404 / NotFoundError
  → Slack “No existing VirusTotal record”
```

**Result:** Pass. The 404 is the designed business outcome for an unknown hash. No conclusion about benignness should be drawn from absence in VirusTotal.

Evidence:

- [unknown-file trigger](../evidence/06-virustotal-404/2026-09-22-052221.png)
- [Slack 404 result](../evidence/06-virustotal-404/2026-09-22-052235.png)
- [final API 404](../evidence/06-virustotal-404/2026-09-22-054509.png)
- [final combined Slack view](../evidence/06-virustotal-404/2026-09-22-054227.png)

## Test B — Known harmless EICAR artifact

**Purpose:** Prove that a known SHA-256 takes the enrichment route.

**Input:** The standard harmless EICAR antivirus test string written to the same monitored path in the isolated lab.

**Observed chain:**

```text
EICAR test-string change
  → Wazuh Rule 550
  → Shuffle webhook execution
  → initial Slack security alert
  → VirusTotal HTTP 200
  → Slack analysis statistics and report context
```

**Result:** Pass. The final handoff screenshot observed `65` malicious, `0` suspicious, `0` harmless, and `2` undetected. An earlier run observed `66` malicious; VirusTotal counts are dynamic.

Evidence:

- [EICAR trigger](../evidence/07-virustotal-200/2026-09-22-054737.png)
- [final API 200](../evidence/07-virustotal-200/2026-09-22-054921.png)
- [final Slack enrichment](../evidence/07-virustotal-200/2026-09-22-054811.png)

## Regression checks

After any playbook edit, repeat both tests and confirm:

- the filter still admits Rule `550` at level `7`;
- Rule `111801` does not use this demonstrated branch;
- both messages include the same SHA-256 as the Wazuh event;
- 404 routes only to the no-record action;
- 200 routes only to the enrichment action;
- counts are read from the current response rather than hard-coded;
- no secrets appear in execution output captured for documentation.

