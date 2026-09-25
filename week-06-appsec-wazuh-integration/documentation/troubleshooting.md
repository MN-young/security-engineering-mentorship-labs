# Troubleshooting record

This file preserves failed and intermediate states so the final result is reproducible without presenting those states as the final design.

## Environment and application

### Python venv could not be created

**Symptom:** `python3 -m venv` failed because the Python 3.12 venv package / `ensurepip` support was unavailable.

**Resolution:** Install the matching `python3.12-venv` package after recovering the package manager, then recreate and activate the virtual environment.

**Evidence:** `evidence/troubleshooting/2026-09-22-225554.png` through `2026-09-22-231406.png`.

### apt lock held by stale PID 8651

**Symptom:** Package installation could not acquire the apt/dpkg lock.

**Resolution:** Inspect the exact owner, confirm stale PID `8651`, terminate that specific process, repair the package-manager state, and rerun the installation. The evidence does not support deleting lock files blindly.

**Evidence:** `2026-09-22-230121.png` and `2026-09-22-230526.png`.

### Flask listened only on loopback

**Symptom:** The app was reachable locally at `127.0.0.1` but not from another lab host.

**Resolution:** Run the isolated training server with `flask --app app run --host 0.0.0.0 --port 5000`.

**Evidence:** `2026-09-22-231900.png` and `2026-09-22-232301.png`.

### SSH was inactive

**Symptom:** SCP delivery to the Linux endpoint was unavailable.

**Resolution:** Start and enable the SSH service, then verify its active state.

**Evidence:** `2026-09-23-163707.png` and `2026-09-23-163722.png`.

### SCP was run from the wrong host

**Symptom:** A Windows source path was referenced from Linux.

**Resolution:** Run SCP from Windows PowerShell, where the downloaded artifact path exists, and target the Linux endpoint.

**Evidence:** `2026-09-23-164930.png`.

## Semgrep workflow

### Findings did not fail the job

**Symptom:** The first Semgrep workflow displayed findings but stayed green.

**Cause:** A normal Semgrep scan reports results but does not necessarily act as a blocking CI gate.

**Resolution:** Keep the JSON export step, upload the artifact, then run a separate scan with `--error`.

**Evidence:** Initial green runs are in `evidence/github-actions/`; the blocking evolution is shown by `2026-09-23-053213.png` through `2026-09-23-055044.png`.

### Artifact risk when enforcing the gate

**Risk:** If the only scan uses `--error`, the job can stop before the JSON artifact is uploaded.

**Resolution:** Export and upload `semgrep-results.json` first; enforce the gate afterward.

**Evidence:** `evidence/semgrep/2026-09-23-054359.png` and `2026-09-23-055302.png`.

## Semgrep-to-Wazuh path

### Pretty JSON was not suitable for line collection

**Symptom:** The Semgrep artifact was an array rather than one complete event per line.

**Resolution:** Normalize each finding into its own JSON object with stable top-level fields before replaying the monitored file.

### Replacing the monitored file was not detected reliably

**Symptom:** Copying or moving a replacement file did not consistently produce a new Wazuh event.

**Resolution:** Truncate the monitored file and append the test event with `tee -a`.

**Evidence:** `evidence/troubleshooting/2026-09-24-115312.png` and the replay evidence under `evidence/wazuh-100202/`.

### archives.json was unavailable

**Symptom:** A proposed validation path expected `archives.json`, but archives were not enabled.

**Resolution:** Use `wazuh-logtest`, exact searches in `alerts.json`, and dashboard verification.

### Broad grep produced false matches

**Symptom:** Generic searches matched rule files, historical text, or unrelated messages.

**Resolution:** Search exact fields such as `"source":"semgrep"`, `"source":"pip-audit"`, or an exact target rule ID.

### Rule design fell through to generic Rule 1002

**Symptom:** The first custom rules decoded the JSON but did not become the final matched rule.

**Cause:** The intermediate `decoded_as json` hierarchy did not match the event as expected.

**Resolution:** Match the decoded top-level `source=semgrep` field directly in parent Rule `100200`, then use child Rules `100201` and `100202`.

**Evidence:** Failed/intermediate screenshots, including `2026-09-23-182445.png`, are retained under `evidence/wazuh-100202/` but must be read as troubleshooting. The final rule and logtest proof are `2026-09-23-184131.png` and `2026-09-23-185710.png`.

### Unrelated Rule 7616 warnings

**Observation:** `wazuh-analysisd -t` printed missing IOC-list warnings associated with Rule `7616`.

**Interpretation:** They were unrelated to the Week 6 AppSec rules. The validation command still returned `0`, so the AppSec rules were syntactically accepted.

## pip-audit workflow and ingestion

### YAML structure problems

**Symptom:** While adding the stretch-goal dependency job, duplicate or incorrectly indented YAML caused failed workflow attempts.

**Resolution:** Keep `semgrep` and `dependency-scan` as sibling jobs under `jobs`, with separate step lists.

**Evidence:** `evidence/troubleshooting/2026-09-24-171408.png`, `172923.png`, `173113.png`, and `173207.png`.

### Dependency test needed a controlled vulnerable version

**Method:** Temporarily pin Flask `3.0.3`, run pip-audit, verify `PYSEC-2026-2151`, then restore Flask `3.1.3` and rerun.

**Accuracy:** Flask `3.0.3` is not the final state.

### JSON artifact needed to survive failure

**Resolution:** Export `pip-audit-results.json` and upload with `if: always()`.

### Duplicate normalized events remained

**Symptom:** Two normalized dependency events were present, and byte-for-byte deduplication did not reduce them.

**Resolution:** For the controlled replay, retain the first complete line explicitly with `head -n 1`.

**Evidence:** `evidence/troubleshooting/2026-09-25-000501.png`.

### No custom pip-audit decoder was required

`wazuh-logtest` showed that the built-in JSON decoder already exposed `source`, `event_type`, `package`, `installed_version`, `vulnerability_id`, and `fix_versions`. Rule `100203` therefore matched those fields directly.

## Shuffle and Slack

### AppSec alerts entered VirusTotal

**Symptom:** Rules `100202` and `100203` reached Slack but then produced irrelevant VirusTotal `404` / no-record messages.

**Cause:** The reused Week 5 workflow did not yet exclude the new AppSec rule IDs from the hash-enrichment branch.

**Resolution:** After Slack, require both `$exec.rule_id != 100202` and `$exec.rule_id != 100203` before VirusTotal.

**Evidence:** Pre-fix screenshots `2026-09-25-005415.png` and `2026-09-25-011554.png`; final condition `evidence/shuffle-slack/2026-09-25-014348.png`.

### Wrong connector was nearly changed

**Correction:** The issue was not the Slack connector or the Wazuh webhook. The relevant control was the routing condition after Slack and before VirusTotal.

### Dynamic pip-audit formatter failed

**Symptom:** Nested `$exec` and `fix_versions.#0` references produced formatter errors.

**Resolution:** Abandon the experiment and retain the proven generic Wazuh-to-Slack alert path. The formatter is not part of the final design.

## VM watchdog messages

Soft-lockup messages were observed on the VM during the lab. They are recorded as an observation only. The available evidence does not establish a root cause, so this repository does not invent one.

## Final-state rule

When an intermediate screenshot conflicts with the final configuration, the final verified state takes precedence:

- Semgrep red is expected, not broken.
- Flask `3.1.3` is final; Flask `3.0.3` is the controlled test.
- `PYSEC-2026-2151` is the verified advisory identifier.
- Direct field matching is the final Semgrep Wazuh rule design.
- Rules `100202` and `100203` stop after Slack and before VirusTotal.
