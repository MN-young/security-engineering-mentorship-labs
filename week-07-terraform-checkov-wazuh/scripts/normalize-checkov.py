#!/usr/bin/env python3
"""Reference handoff implementation, not a recovered VM script.

Convert Checkov Terraform failed_checks into compact JSON lines for Wazuh.
Validate the complete report before emitting anything; never copy code blocks.
"""
import json
import sys
from pathlib import Path


def normalize(report):
    reports = report if isinstance(report, list) else [report]
    if not reports or any(not isinstance(item, dict) for item in reports):
        raise ValueError("Expected a Checkov report object or list of reports")
    terraform_reports = [item for item in reports if item.get("check_type") == "terraform"]
    if not terraform_reports:
        raise ValueError("No Terraform report found; a missing report is not a clean scan")
    events = []
    for item in terraform_reports:
        results = item.get("results")
        if not isinstance(results, dict) or not isinstance(results.get("failed_checks"), list):
            raise ValueError("Missing results.failed_checks array")
        if results.get("parsing_errors"):
            raise ValueError("Terraform parsing errors present; investigate the raw report")
        for finding in results["failed_checks"]:
            if not isinstance(finding, dict):
                raise ValueError("Invalid failed-check object")
            fields = {key: finding.get(key) for key in ("check_id", "check_name", "resource", "file_path")}
            if any(not isinstance(value, str) or not value for value in fields.values()):
                raise ValueError("Failed check is missing required string fields")
            if finding.get("check_result", {}).get("result") != "FAILED":
                raise ValueError("Unexpected result in failed_checks")
            events.append({"integration": "checkov", **fields, "result": "FAILED"})
    return events


def main():
    if len(sys.argv) != 2:
        print("Usage: normalize-checkov.py REPORT.json", file=sys.stderr)
        return 2
    try:
        report = json.loads(Path(sys.argv[1]).read_text(encoding="utf-8"))
        events = normalize(report)
    except (OSError, ValueError, TypeError, AttributeError) as error:
        print(f"Normalization failed: {error}", file=sys.stderr)
        return 2
    for event in events:
        print(json.dumps(event, separators=(",", ":")))
    return 0


if __name__ == "__main__":
    sys.exit(main())
