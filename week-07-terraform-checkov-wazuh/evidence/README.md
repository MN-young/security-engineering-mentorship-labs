# Week 7 evidence catalog

All 105 original PNGs passed filename, byte-size, SHA-256 and image-decode verification against the supplied manifest. The public proposal contains **42 selected screenshots**, with **12 embedded in the Week 7 README**. The other selected images support setup, troubleshooting and deeper verification. Seven AWS/authentication images are excluded entirely; other exclusions reduce repeated or lower-value proof. No selected image was generated, retouched or pixel-edited. Internal 192.168.244.x lab addresses remain as authorized.

The same S3 document has two complementary views: 082 shows the identity/finding fields, while 083 shows rule.id/level. These are retained because each proves fields cropped out of the other. Synthetic logtest 064 uses insecure_sg; actual scanner events use week7_sg or real VPC/S3 resources. Images 077–083 are historical pipeline checkpoints, not a post-remediation full rescan.

| ID | Original filename | Classification | In README | Evidence and limit |
| --- | --- | --- | --- | --- |
| 002 | [Screenshot 2026-10-02 023704.png](environment/002-2026-10-02-023704.png) | supporting evidence | No | Wazuh dashboard: iac-lab active; other agents have separate statuses |
| 016 | [Screenshot 2026-10-02 115435.png](troubleshooting/016-2026-10-02-115435.png) | troubleshooting evidence | No | Literal-HOME symlink corrected to /home/sysadmin/.venvs/checkov/bin/checkov; Checkov 3.3.22 works |
| 017 | [Screenshot 2026-10-02 125901.png](environment/017-2026-10-02-125901.png) | supporting evidence | No | Original Terraform 1.16.4 Linux and Checkov 3.3.22 readiness |
| 019 | [Screenshot 2026-10-02 144243.png](networking/019-2026-10-02-144243.png) | troubleshooting evidence | No | IP ping succeeds while DNS fails; public/gateway DNS overrides still fail |
| 020 | [Screenshot 2026-10-02 144446.png](networking/020-2026-10-02-144446.png) | troubleshooting evidence | No | Resolver revert, network renew/restarts; successful DNS query and hostname ping |
| 021 | [Screenshot 2026-10-02 144516.png](networking/021-2026-10-02-144516.png) | troubleshooting evidence | No | VMware NAT/DHCP restart attempts; not proof of the final DNS fix |
| 028 | [Screenshot 2026-10-02 202941.png](terraform/028-2026-10-02-202941.png) | supporting evidence | No | Original project tree with Terraform files, evidence and reports |
| 033 | [Screenshot 2026-10-03 091311.png](troubleshooting/033-2026-10-03-091311.png) | troubleshooting evidence | No | Terraform Invalid multi-line string syntax failures |
| 034 | [Screenshot 2026-10-03 095332.png](troubleshooting/034-2026-10-03-095332.png) | troubleshooting evidence | No | sed source inspection; awk and Python diagnostic attempts also hit syntax errors |
| 038 | [Screenshot 2026-10-04 115907.png](troubleshooting/038-2026-10-04-115907.png) | troubleshooting evidence | No | Broken main.tf backed up; terraform ftm typo corrected to terraform fmt |
| 041 | [Screenshot 2026-10-04 121441.png](terraform/041-2026-10-04-121441.png) | supporting evidence | No | Terraform init and validate succeed; original AWS provider 6.67.0 |
| 042 | [Screenshot 2026-10-04 122553.png](troubleshooting/042-2026-10-04-122553.png) | troubleshooting evidence | No | Terraform plan blocked by no valid credentials and expired login session |
| 047 | [Screenshot 2026-10-04 124506.png](terraform/047-2026-10-04-124506.png) | supporting evidence | No | Terraform plan: 3 to add, 0 to change, 0 to destroy; planned only |
| 049 | [Screenshot 2026-10-04 132413.png](terraform/049-2026-10-04-132413.png) | README proof | Yes | Intentional TCP/22 SSH ingress from 0.0.0.0/0 in Terraform source |
| 051 | [Screenshot 2026-10-04 133222.png](checkov/051-2026-10-04-133222.png) | README proof | Yes | Focused CKV_AWS_24 failure: 0 passed / 1 failed / 0 skipped on week7_sg |
| 052 | [Screenshot 2026-10-04 135004.png](checkov/052-2026-10-04-135004.png) | supporting evidence | No | Explicit JSON export to ../reports/checkov-results.json; report exists (9.1K at this checkpoint) |
| 054 | [Screenshot 2026-10-04 135415.png](checkov/054-2026-10-04-135415.png) | supporting evidence | No | Original broad scan summary: 10 passed / 11 failed / 0 skipped; parsing errors 0 |
| 055 | [Screenshot 2026-10-04 140132.png](checkov/055-2026-10-04-140132.png) | supporting evidence | No | jq selects exact CKV_AWS_24 finding and resource/file/line range |
| 057 | [Screenshot 2026-10-04 143311.png](troubleshooting/057-2026-10-04-143311.png) | troubleshooting evidence | No | Misspelled chceckov log path fails; correctly spelled path contains normalized early-schema event |
| 059 | [Screenshot 2026-10-04 143851.png](wazuh/059-2026-10-04-143851.png) | supporting evidence | No | Agent localfile JSON configuration; correct monitored path and collector test invocation |
| 060 | [Screenshot 2026-10-04 144033.png](wazuh/060-2026-10-04-144033.png) | supporting evidence | No | Agent logcollector reports Analyzing file /var/log/checkov/checkov.log |
| 061 | [Screenshot 2026-10-04 150512.png](troubleshooting/061-2026-10-04-150512.png) | troubleshooting evidence | No | Early source/status event decodes as JSON but matches generic Rule 1002 Level 2 |
| 062 | [Screenshot 2026-10-04 160907.png](wazuh/062-2026-10-04-160907.png) | supporting evidence | No | Historical Rule 110700 Level 5 parent and Rule 110701 Level 12 FAILED child |
| 063 | [Screenshot 2026-10-04 161211.png](troubleshooting/063-2026-10-04-161211.png) | troubleshooting evidence | No | Manager check exit status 0 despite warning context; test command itself is cropped |
| 064 | [Screenshot 2026-10-04 162024.png](wazuh/064-2026-10-04-162024.png) | README proof | Yes | Synthetic insecure_sg logtest reaches Rule 110701 Level 12 and Alert to be generated |
| 065 | [Screenshot 2026-10-05 174218.png](troubleshooting/065-2026-10-05-174218.png) | troubleshooting evidence | No | File inspection finds no reports directory at this checkpoint |
| 072 | [Screenshot 2026-10-05 182754.png](checkov/072-2026-10-05-182754.png) | README proof | Yes | Actual Checkov week7_sg finding normalized to integration/result schema and appended |
| 077 | [Screenshot 2026-10-06 111401.png](wazuh/077-2026-10-06-111401.png) | README proof | Yes | Script execution forwards multiple real failed findings; chmod and project-root launch visible |
| 078 | [Screenshot 2026-10-06 111508.png](wazuh/078-2026-10-06-111508.png) | README proof | Yes | Final historical script corrects Terraform working directory and ../checkov-output.json paths |
| 079 | [Screenshot 2026-10-06 111621.png](wazuh/079-2026-10-06-111621.png) | README proof | Yes | Manager alerts.json contains multiple real Checkov findings, Rule 110701 Level 12, iac-lab |
| 081 | [Screenshot 2026-10-06 112340.png](wazuh/081-2026-10-06-112340.png) | README proof | Yes | Dashboard list: multiple real Checkov alerts, iac-lab, Rule 110701, Level 12 |
| 082 | [Screenshot 2026-10-06 112401.png](wazuh/082-2026-10-06-112401.png) | supporting evidence | No | S3 lifecycle document: integration/check_id/resource/result/decoder/location; rule fields below visible portion |
| 083 | [Screenshot 2026-10-06 112414.png](wazuh/083-2026-10-06-112414.png) | README proof | Yes | Same S3 document scrolled to rule.id 110701 and rule.level 12; complementary fields to image 082 |
| 086 | [Screenshot 2026-10-10 193200.png](remediation/086-2026-10-10-193200.png) | README proof | Yes | SSH restricted to 10.7.0.0/16; description updated (historical lap VPC spelling) |
| 087 | [Screenshot 2026-10-10 193324.png](remediation/087-2026-10-10-193324.png) | supporting evidence | No | Post-remediation terraform fmt and terraform validate success |
| 088 | [Screenshot 2026-10-10 193452.png](remediation/088-2026-10-10-193452.png) | README proof | Yes | Focused CKV_AWS_24 PASS: 1 passed / 0 failed / 0 skipped |
| 090 | [Screenshot 2026-10-10 201214.png](github-actions/090-2026-10-10-201214.png) | supporting evidence | No | Historical workflow YAML: Terraform/workflow triggers; install Checkov; scan terraform directory |
| 095 | [Screenshot 2026-10-10 212252.png](github-actions/095-2026-10-10-212252.png) | supporting evidence | No | Git ignore protections expanded for Terraform state, plans, local variables, keys and generated JSON |
| 097 | [Screenshot 2026-10-10 212555.png](github-actions/097-2026-10-10-212555.png) | supporting evidence | No | Historical staged diff review of ignore rules and Terraform source |
| 099 | [Screenshot 2026-10-10 220430.png](github-actions/099-2026-10-10-220430.png) | supporting evidence | No | Historical push succeeds to standalone lab repo; no new push in this task |
| 100 | [Screenshot 2026-10-10 220916.png](github-actions/100-2026-10-10-220916.png) | supporting evidence | No | CI failure summary and environment annotations; exit code 1 |
| 102 | [Screenshot 2026-10-10 222925.png](github-actions/102-2026-10-10-222925.png) | README proof | Yes | Expanded CI log: CKV2_AWS_61 S3 failure followed by Checkov exit code 1 |

See [source audit](../documentation/source-audit.md) for the manual reconciliation and [troubleshooting](../documentation/troubleshooting.md) for failure-to-fix chains. The full 105-image decision ledger is supplied separately with the local approval package; raw excluded files are not in the repository proposal.
