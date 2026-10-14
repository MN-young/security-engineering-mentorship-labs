# Setup, reproduction and provenance

## Artifact provenance

| Artifact | Basis | Handoff treatment |
| --- | --- | --- |
| `terraform/main.tf` | Existing standalone Week 7 source plus corrected-source screenshot | Preserve resource names, provider constraint, tags, CIDR and S3 baseline; correct `lap VPC` description typo and add training comments |
| `terraform/variables.tf` | Original variable source screenshot 031 reviewed; no original file export | Retain `us-east-1`, now corroborated by screenshot 031 |
| `examples/before/` | Failed Checkov screenshot | Reconstruct the same baseline with world-open SSH |
| Agent localfile snippet | Conversation configuration and dashboard `location` | Exact demonstrated path and JSON log format |
| Manager rule snippet | Observed Rule `110701` / Level 12 and reported `110700 → 110701` chain | Historical Level 5 parent and Level 12 child from manual section 8 and screenshot 062; no complete manager-file export |
| Python normalizer and shell runner | Observed normalized fields and reported original runner workflow | New reference implementation; not the original VM script |
| Screenshots | 105 originals from the supplied complete evidence package | 42 selected; 12 in README; catalog and separate 105-image ledger identify decisions |

The existing source repository is [MN-young/week7-checkov-terraform-lab](https://github.com/MN-young/week7-checkov-terraform-lab). It was inspected as a source reference. This handoff lives in the shared mentorship repository and does not create or modify a separate repository.

## Static prerequisites

Use Terraform `>= 1.6.0`, Python 3 and Checkov. The original screenshots show Checkov `3.3.22`; the source uses AWS provider `~> 6.0`; original initialization screenshot 041 installed 6.67.0. An isolated virtual environment avoids changing system Python:

```bash
python3 -m venv .venv
. .venv/bin/activate
python -m pip install 'checkov==3.3.22'
checkov --version
terraform version
```

The Checkov pin reproduces the lab version; it is not a recommendation to keep an old tool indefinitely. Evaluate updates and record rule-set differences separately.

## Baseline and selected-policy comparison

Run from `week-07-terraform-checkov-wazuh/`:

```bash
mkdir -p reports
terraform -chdir=terraform init -backend=false -input=false
terraform -chdir=terraform fmt -check
terraform -chdir=terraform validate

# Expected: CKV_AWS_24 fails; nonzero exit is the control working.
checkov -d examples/before --framework terraform --check CKV_AWS_24

# Expected: CKV_AWS_24 passes on the corrected source.
checkov -d terraform --framework terraform --check CKV_AWS_24

# Full scan: other failures are expected and must be reviewed.
checkov -d terraform --framework terraform -o json > reports/checkov-output.json
python3 scripts/normalize-checkov.py reports/checkov-output.json > reports/checkov-events.jsonl
```

Run these commands individually. A failing Checkov command must not prevent later investigation of its report; do not hide the failure with `--soft-fail` and then describe the result as clean. The reference runner captures the scan exit code, validates JSON, forwards failures, and returns the original status.

For the exact screenshot form, change into `terraform/` and use `checkov -d . --framework terraform --check CKV_AWS_24`. The original failed screenshot used `checkov -f main.tf --check CKV_AWS_24`.

Only the `terraform/` directory is the remediated target. Scanning the week folder recursively also includes `examples/before/`, which deliberately fails.

`terraform init -backend=false` initializes providers for local validation. It does not apply resources. No AWS credentials, plan, apply or state export is required here. See [Terraform validate](https://developer.hashicorp.com/terraform/cli/commands/validate) and [Checkov CLI options](https://www.checkov.io/2.Basics/CLI%20Command%20Reference.html).

The handoff includes a reviewed `.terraform.lock.hcl` selecting AWS provider `6.68.0` from local validation. That selection is distinct from the unspecified original VM provider version. Retain and review this lock file for reproducible initialization.

## Endpoint integration prerequisites

The IaC endpoint must already have an enrolled, healthy Wazuh agent connected to the existing manager. Configure file permissions for the actual collector process. A typical root-run Linux lab agent can read a root-owned `0640` log; verify the effective service account if your installation differs.

```bash
sudo install -d -m 0750 -o root -g root /var/log/checkov
sudo touch /var/log/checkov/checkov.log
sudo chown root:root /var/log/checkov/checkov.log
sudo chmod 0640 /var/log/checkov/checkov.log
```

This creates the directory and file without truncating existing evidence. Merge the [localfile snippet](../configs/wazuh-agent-localfile.xml) into the current `/var/ossec/etc/ossec.conf`. Back up and inspect that configuration first. Follow [checkov-to-wazuh.md](checkov-to-wazuh.md) for validation and manager steps.

Run the reference forwarding script on that endpoint, using the virtual environment that provides Checkov:

```bash
bash scripts/run-checkov-wazuh.sh
```

Findings cause a nonzero exit even when forwarding succeeds. Invalid/missing reports stop before log append. Repeated invocations append duplicate findings; there is no deduplication or scheduler in this reference. It does not update cloud resources or install manager rules automatically.

## Preserving evidence

Save selected CLI output with the exit status separately from raw JSON, and review it before committing. Keep source, scanner version, check selection, result and resource name visible. Never commit Terraform state, AWS credentials, local secret variables or unreviewed full reports. This week folder's ignore rules cover those runtime artifacts and retain the policy-changing sample CIDR.

## Original planned outputs

Screenshot 032 shows `outputs.tf` exposing `vpc_id`, `security_group_id` and `s3_bucket_name`. Screenshot 047 shows those outputs as known after apply during a successful plan. The prepared reference source is a documented sample, not a byte-for-byte export of the VM project; a standalone outputs file is not added here.

## Historical runner

The manual's corrected historical design is retained separately as `scripts/run-checkov-wazuh-historical.sh`. It hardcodes the original Linux project path and uses `|| true`; its limitations are preserved in the integration guide. The default `scripts/run-checkov-wazuh.sh` remains the earlier strict reference runner. No script was installed or executed on a live endpoint during this documentation update.
