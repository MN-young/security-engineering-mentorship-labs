# Setup and execution record

## Safety scope

Use this application only in an isolated training network. The SQL injection and hardcoded training credentials are deliberate. Do not expose the Flask development server to the public internet.

## Application setup

The verified environment used Python 3.12 and a virtual environment. The initial venv attempt failed because the `python3.12-venv` package and `ensurepip` support were missing; the recovery is documented in [troubleshooting.md](troubleshooting.md).

Representative setup:

```bash
python3 -m venv .venv
source .venv/bin/activate
python -m pip install -r requirements.txt
```

The application source defaults to loopback. For validation from another host inside the isolated lab, it was run explicitly with:

```bash
flask --app app run --host 0.0.0.0 --port 5000
```

That runtime command explains the bind correction without changing the training source file.

## GitHub Actions workflow

The checked-in `.github/workflows/semgrep.yml` triggers on pushes and pull requests to `main` and contains two independent jobs.

### Semgrep job

1. Check out the repository.
2. Configure Python 3.12.
3. Install Semgrep.
4. Export JSON findings with `semgrep scan --config auto --json --output semgrep-results.json .`.
5. Upload `semgrep-security-findings`.
6. Enforce the blocking gate with `semgrep scan --config auto --error .`.

The export and upload occur before the blocking command. The final verified run reported 6 findings, 6 blocking findings, 341 rules, 11 targets, and exit code `1`.

### pip-audit job

1. Check out the repository.
2. Configure Python 3.12.
3. Install or upgrade `pip` and `pip-audit`.
4. Audit `requirements.txt` and export `pip-audit-results.json`.
5. Upload `pip-audit-security-findings` with `if: always()`.

The jobs are independent: the expected Semgrep failure does not convert a clean dependency scan into a failure.

## Controlled dependency test

The dependency test followed this sequence:

1. Temporarily pin Flask `3.0.3`.
2. Run pip-audit and retain the JSON artifact.
3. Verify advisory `PYSEC-2026-2151` and fix version `3.1.3`.
4. Restore Flask `3.1.3`.
5. Rerun pip-audit and verify `No known vulnerabilities found`.

Flask `3.0.3` is evidence of the controlled test, not the final dependency state.

## Manual artifact handoff

The JSON artifacts were downloaded to Windows, copied to the Linux endpoint with SCP, normalized, and replayed into Wazuh-monitored files. This was a manual boundary; no automatic GitHub artifact retrieval was configured.

## Files intentionally preserved

This documentation update does not change:

- `app.py`
- `requirements.txt`
- `.github/workflows/semgrep.yml`
- application templates or styling

The final source remains the verified lab state: Flask `3.1.3`, deliberate SQL injection present, Semgrep red by design, and pip-audit green.
