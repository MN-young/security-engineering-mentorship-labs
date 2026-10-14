# GitHub Actions stretch attempt

The separate existing `MN-young/week7-checkov-terraform-lab` repository held the historical Checkov workflow. This portfolio update is for the main mentorship repository; the standalone repository stays unchanged.

Screenshot 090 shows push and pull-request path filters for `terraform/**` and `.github/workflows/checkov.yml`, an Ubuntu runner, checkout, `pip install checkov` and `checkov -d terraform --framework terraform`. Screenshots 095/097 document ignore-file hardening and staged review, and 099 shows a historical successful push to that standalone repository.

The workflow actually executed. Screenshot 100 shows its failed status and exit code 1. Expanded screenshot 102 shows `CKV2_AWS_61` failing for `aws_s3_bucket.week7_bucket`, followed by `Process completed with exit code 1`. This is the scanner's failure on findings. Node.js migration and Ubuntu runner notices are environment annotations, not the cause of the Checkov failure.

The attached manual's earlier status was execution unverified. The newly supplied original screenshots substantiate execution and expected failure on findings. They do not establish a fully completed stretch goal, preserved scan artifacts, an accepted before/after gate, or automatic CI finding delivery into Wazuh.

No active workflow is added to the mentorship repository by this proposal. Its remediated sample and intentionally insecure before example are separate scan targets. If CI is extended later, scope and remaining policy disposition need an explicit decision; scanning every folder would include the deliberate before failure.
