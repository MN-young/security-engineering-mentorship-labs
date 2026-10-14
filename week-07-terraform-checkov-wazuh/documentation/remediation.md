# Task 42 remediation and Task 43 before/after

The selected target was `CKV_AWS_24` on `aws_security_group.week7_sg`: TCP/22 ingress from `0.0.0.0/0`. Screenshot 049 shows the intentional source weakness; focused scan 051 reports 0 passed, 1 failed and 0 skipped.

The ingress was changed to `cidr_blocks = ["10.7.0.0/16"]`. An intermediate capture (084) still described SSH as allowed from anywhere; final capture 086 updates the description, with the historical spelling `Restrict SSH to lap VPC`. The prepared source corrects only that spelling to `lab VPC` and labels itself a training reference.

```hcl
ingress {
  description = "LAB TEST - Restrict SSH to lab VPC"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["10.7.0.0/16"]
}
```

Screenshot 087 directly shows `terraform fmt` followed by `terraform validate` and `Success! The configuration is valid.` Screenshot 088 directly shows the focused Checkov rescan passing 1, failing 0 and skipping 0.

| Measure | Before | After |
| --- | --- | --- |
| Selected resource | `aws_security_group.week7_sg` | Same resource |
| Inbound TCP/22 CIDR | `0.0.0.0/0` | `10.7.0.0/16` |
| CKV_AWS_24 result | Failed | Passed |
| Focused passed/failed/skipped | 0/1/0 | 1/0/0 |
| Other IaC findings | Present | Not claimed fixed |

The /16 covers the lab VPC, not one administration host. Outbound HTTPS is a separate declaration. Terraform validity is not a security certification, and the focused pass is not a clean full scan.

Other failures are visible in the historical broad scan, real Wazuh alerts and later CI result. The CI screenshot from October 10 shows `CKV2_AWS_61` still failing. Do not label October 6 manager/dashboard captures as a post-remediation rescan: their historical timestamps precede the final October 10 proof.

The manual's separate October 12 prepared-source full scan reported 11 passed, 10 failed and 0 skipped. That is additional local handoff verification, not an original VM full report. No new full VM scan was run during this documentation update.

The manual frames Task 43 as preventive versus runtime controls. [The control comparison](task-43-comparison.md) retains that framing alongside this requested before/after evidence.
