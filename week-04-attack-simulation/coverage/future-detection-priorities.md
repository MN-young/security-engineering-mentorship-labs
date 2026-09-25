# Future Detection Priorities

## Priority 1 — Linux process execution telemetry

### Gap addressed

T1059.004 executed successfully without a Wazuh alert.

### Recommended work

- Deploy `auditd`, eBPF telemetry, or another process-execution source.
- Capture executable, command line, parent process, user, working directory, and result.
- Build detections for unusual shell-script creation and execution.
- Test common interpreters such as Bash, Python, Perl, and PowerShell.
- Baseline legitimate administrative automation before raising severity.

### Validation

Rerun `T1059.004-1` and confirm the exact process chain is visible before writing a rule.

## Priority 2 — Credential-file discovery

### Gap addressed

T1552.001-25 searched a safe, fake `.git-credentials` file without detection.

### Recommended work

- Use process telemetry to detect commands enumerating credential-related filenames.
- Monitor access metadata for a small set of high-value credential paths where appropriate.
- Correlate search commands, user context, and unusual parent processes.
- Never ingest or publish credential contents solely for detection validation.

### Validation

Continue using dummy files in an isolated directory and verify that rules detect behavior without recording the fake secret value.

## Priority 3 — Risk-based temporary-file visibility

### Gap addressed

T1070.004 deleted a file under `/tmp`, outside current FIM scope.

### Recommended work

- Identify specific high-risk temporary subdirectories or application paths.
- Estimate expected change volume before enabling real-time FIM.
- Prefer narrow paths, exclusions, and process context over blanket `/tmp` monitoring.
- Evaluate whether process telemetry provides a more actionable deletion signal.

### Validation

Test both monitored and intentionally unmonitored paths, then record alert fidelity and noise.

## Priority 4 — Generalized but controlled TheHive routing

### Gap addressed

Rule `111801` remained in Wazuh because the existing bridge was scoped to the port-scan/rule `86601` flow.

### Recommended work

- Define an explicit allowlist of Wazuh rule IDs.
- Support routing by MITRE tactic/technique and severity.
- Preserve signature-specific checks for broad Suricata processing rules.
- Deduplicate using rule, source, destination, agent, and a time window.
- Add rate limiting and related-alert grouping.
- Keep service accounts least-privileged.

### Validation

Route a controlled rule `111801` event to a test case only after deduplication and case-volume controls are in place.

## Priority 5 — Detection regression testing

Convert the five Week 4 Atomics into a small regression suite:

1. Capture the Atomic ID and inputs.
2. Record expected host/network telemetry.
3. Record expected rule ID and severity.
4. Record whether case creation is in scope.
5. Retest after rules, agents, or log sources change.
6. Version the ATT&CK matrix rather than replacing previous results.

This turns the Week 4 assessment into a repeatable control-validation process.
