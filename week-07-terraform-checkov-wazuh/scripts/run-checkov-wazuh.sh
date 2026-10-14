#!/usr/bin/env bash
# Reference handoff implementation. Run on an enrolled Linux IaC agent.
# A scan with findings is forwarded and still returns its nonzero scan status.
set -euo pipefail
week_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
mkdir -p "$week_root/reports"
raw_report="$week_root/reports/checkov-output.json"
event_report="$week_root/reports/checkov-events.jsonl"
scan_status=0
checkov -d "$week_root/terraform" --framework terraform -o json > "$raw_report" || scan_status=$?
python3 "$week_root/scripts/normalize-checkov.py" "$raw_report" > "$event_report"
if [[ -s "$event_report" ]]; then
  # Agent log must already exist with ownership/permissions set by the operator.
  sudo tee -a /var/log/checkov/checkov.log < "$event_report" > /dev/null
fi
printf 'Scan exit: %s; forwarded failed-check events: %s\n' "$scan_status" "$(wc -l < "$event_report" | tr -d ' ')"
exit "$scan_status"
