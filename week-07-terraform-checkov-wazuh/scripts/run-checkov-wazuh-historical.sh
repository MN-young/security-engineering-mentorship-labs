#!/bin/bash
# Historical reconstruction from attached manual section 19 and screenshot 078.

 
echo "[+] Running Checkov Terraform scan..."
 
cd /home/sysadmin/week7-terraform-checkov-wazuh/terraform || exit 1
 
checkov -d . --framework terraform -o json > ../checkov-output.json || true
 
echo "[+] Extracting failed Checkov findings..."
 
python3 - <<'PY' | sudo tee -a /var/log/checkov/checkov.log
import json
 
with open("../checkov-output.json") as f:
    data = json.load(f)
 
failed_checks = data.get("results", {}).get("failed_checks", [])
 
for failed in failed_checks:
    event = {
        "integration": "checkov",
        "check_id": failed.get("check_id"),
        "check_name": failed.get("check_name"),
        "resource": failed.get("resource"),
        "file_path": failed.get("file_path"),
        "result": "FAILED"
    }
    print(json.dumps(event))
PY
 
echo "[+] Findings forwarded to Wazuh log."
