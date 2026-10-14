# Checkov export, normalization and Wazuh ingestion

## Historical report paths

The VM project was `~/week7-terraform-checkov-wazuh`. Different checkpoints used `reports/checkov-results.json` and root-level `checkov-output.json`. Screenshot 052 shows an explicit Terraform JSON export to `../reports/checkov-results.json`, followed by a 9.1K file listing. Later screenshots 069/070 show a 92K `checkov-output.json`. These are separate exports, not conflicting measurements of one unchanged file.

```bash
# Historical report stage, from terraform/
checkov -d . --framework terraform -o json > ../reports/checkov-results.json
jq '.summary' ../reports/checkov-results.json
```

Screenshot 054 shows 10 passed, 11 failed, 0 skipped, 0 parsing errors, 3 resources and Checkov 3.3.22. Select findings from `results.failed_checks`; the start of the raw report can show passed checks.

## Field transition

Early normalized input used `source=checkov`, `event_type=iac_misconfiguration`, `status=FAILED` and finding/location fields. Final working input used `integration=checkov`, `check_id`, `check_name`, `resource`, `file_path` and `result=FAILED`. Each collected record is one JSON line. A raw pretty-printed report is not the final ingestion format.

The early event decoded correctly but reached generic Rule 1002 Level 2 (061). The final rules expect the later `integration/result` fields. Avoid mixing the two schemas into one alleged final configuration.

Screenshot 072 extracts a real `CKV_AWS_24` finding for `aws_security_group.week7_sg` from index zero and appends its normalized output. Index zero demonstrates one finding; it does not robustly select a particular check when report ordering changes. The final runner iterates all failures.

## Agent collection

The following snippet belongs inside the existing `/var/ossec/etc/ossec.conf`, before its closing `ossec_config`. Back up and preserve the rest of the configuration.

```xml
<localfile>
  <log_format>json</log_format>
  <location>/var/log/checkov/checkov.log</location>
</localfile>
```

The historical file creation used `mkdir -p`, `touch` and `chmod 644`. The reference setup guide's root-owned 0640 choice is a reproduction improvement, not the original command history. Confirm collector access for the actual service account.

```bash
# Historical endpoint verification
sudo /var/ossec/bin/wazuh-logcollector -t
sudo systemctl restart wazuh-agent
sudo systemctl status wazuh-agent --no-pager
sudo grep -i checkov /var/ossec/logs/ossec.log | tail -20
```

Screenshot 059 shows the JSON localfile block and collector test invocation. Screenshot 060 shows `Analyzing file: '/var/log/checkov/checkov.log'`. Agent process status alone does not prove a fresh event reached the manager.

## Historical rules and manager checks

[The rule snippet](../configs/wazuh-manager-rules.xml) preserves Rule 110700 at Level 5 with JSON decoding and `integration=checkov`, then Rule 110701 at Level 12 using `if_sid=110700` and `result=FAILED`. It reproduces the manual's historical text, corroborated by screenshot 062. It is not a complete original manager export. Do not replace the existing rule file or leave the Checkov rules inside the Week 6 Semgrep group.

```bash
# Historical manager verification
sudo /var/ossec/bin/wazuh-analysisd -t
echo $?
sudo systemctl restart wazuh-manager
sudo systemctl is-active wazuh-manager
sudo /var/ossec/bin/wazuh-logtest
```

The manual records successful analysisd exit 0. Screenshot 063 corroborates the zero exit status and warning context but crops out the original test invocation. Screenshot 064 directly shows a synthetic logtest matching Rule 110701 Level 12 and `Alert to be generated`. Unrelated CDB/malicious-IOC warnings remain visible; their repair is not established.

## Synthetic input and real scanner findings

The controlled manual event uses `aws_security_group.insecure_sg`. Logtest verifies its decoding/matching, while historical append and live manager events separately verify transport. The actual Terraform scanner resource is `aws_security_group.week7_sg`. Screenshot 072 demonstrates real normalization; 077 forwards multiple real failures; 079 shows real manager events. Preserve those resource names and roles.

For a JSON-aware reproduction query, the following is an improved reference, not the exact historical grep command:

```bash
sudo jq -c 'select(.rule.id == "110701" and .agent.name == "iac-lab" and .data.integration == "checkov")' /var/ossec/logs/alerts/alerts.json
```

## Corrected historical automation

The final historical script in screenshot 078 explicitly enters `/home/sysadmin/week7-terraform-checkov-wazuh/terraform`, scans `.`, exports `../checkov-output.json`, and opens that same relative path in Python. Failed findings become JSON records appended with `sudo tee -a`.

The script uses `|| true`, no `pipefail`, and a success message that is not sufficient downstream acceptance proof. [Historical reconstruction](../scripts/run-checkov-wazuh-historical.sh) preserves those characteristics. [The strict reference runner](../scripts/run-checkov-wazuh.sh) validates reports and retains Checkov's failure status; it is an earlier handoff improvement. Neither file is a recovered raw VM export or a newly installed live change.

## Live analyst visibility

Screenshot 079 shows multiple actual S3/VPC/security-group findings in `alerts.json`, Rule 110701 Level 12, agent `iac-lab` and the Checkov log location. Screenshot 081 shows these fields in the dashboard list. Screenshot 082 identifies the S3 lifecycle document `CKV2_AWS_61`; screenshot 083 is the same document scrolled to `rule.id=110701` and `rule.level=12`.

These are failed static findings, not AWS runtime exploitation or the SSH pass. Dashboard timestamps belong to historical events; query/window corrections and initial `No Results` are documented without asserting a proven root cause.
