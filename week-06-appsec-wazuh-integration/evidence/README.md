# Evidence manifest and publication review

## Curation result

- 129 unique Week 6 screenshots were recovered from the source conversation.
- 127 safe screenshots are staged in this evidence tree.
- 17 strong screenshots are referenced from the main README.
- 110 additional screenshots remain evidence-only.
- 2 raw source screenshots are withheld because they expose the training secret and password.
- A repeated final batch was deduplicated; only the additional `014454` image was retained from the duplicate set.

No screenshot has been uploaded or published by this draft.

## README-selected screenshots

| Screenshot | Purpose |
| --- | --- |
| `application/2026-09-22-232610.png` | SecureOps landing page |
| `application/2026-09-22-233319.png` | Authenticated dashboard |
| `application/2026-09-22-233708.png` | Directory search result |
| `semgrep/2026-09-23-054359.png` | JSON export and upload before gate |
| `semgrep/2026-09-23-055044.png` | Final 6 / 6 / 341 / 11 / exit 1 metrics |
| `semgrep/2026-09-23-055302.png` | Artifact preserved despite gate failure |
| `wazuh-100202/2026-09-23-185710.png` | Rule 100202 Level 12 logtest |
| `wazuh-100202/2026-09-24-120235.png` | Rule 100202 dashboard with three hits |
| `pip-audit/2026-09-24-173551.png` | Controlled Flask 3.0.3 vulnerability test |
| `final-state/2026-09-24-174720.png` | Flask restored to 3.1.3 |
| `final-state/2026-09-24-175336.png` | No known vulnerabilities found |
| `wazuh-100203/2026-09-25-003453.png` | Rule 100203 Level 12 logtest |
| `wazuh-100203/2026-09-25-011421.png` | Live Rules 100202 and 100203 |
| `shuffle-slack/2026-09-25-014348.png` | Post-Slack exclusions for both AppSec rules |
| `shuffle-slack/2026-09-25-014529.png` | Clean Rule 100202 Slack alert |
| `shuffle-slack/2026-09-25-014742.png` | Clean Rule 100203 Slack alert |
| `final-state/2026-09-25-033935.png` | Final Semgrep-red / pip-audit-green state |

## Folder inventory

The entries above also appear in the folder inventory. Every other staged filename is evidence-only and is intentionally not embedded in the README.

### application — 14 files

```text
2026-09-22-211433.png  2026-09-22-211833.png
2026-09-22-221716.png  2026-09-22-222803.png
2026-09-22-222821.png  2026-09-22-223008.png
2026-09-22-223124.png  2026-09-22-223621.png
2026-09-22-223647.png  2026-09-22-224525.png
2026-09-22-232610.png  2026-09-22-232942.png
2026-09-22-233319.png  2026-09-22-233708.png
```

### github-actions — 24 files

```text
2026-09-23-050937.png  2026-09-23-051400.png
2026-09-23-051634.png  2026-09-23-051853.png
2026-09-23-052321.png  2026-09-23-052341.png
2026-09-23-052401.png  2026-09-23-052424.png
2026-09-23-053213.png  2026-09-23-053259.png
2026-09-23-053709.png  2026-09-23-054552.png
2026-09-23-054644.png  2026-09-24-171323.png
2026-09-24-173352.png  2026-09-24-175002.png
2026-09-24-232120.png  2026-09-24-232206.png
2026-09-24-232306.png  2026-09-24-232320.png
2026-09-24-232917.png  2026-09-24-232958.png
2026-09-25-033837.png  2026-09-25-033915.png
```

### semgrep — 9 files

```text
2026-09-23-053730.png  2026-09-23-053758.png
2026-09-23-054359.png  2026-09-23-054935.png
2026-09-23-054958.png  2026-09-23-055044.png
2026-09-23-055302.png  2026-09-24-165411.png
2026-09-24-165424.png
```

### wazuh-100202 — 26 files

```text
2026-09-23-165639.png  2026-09-23-165645.png
2026-09-23-171006.png  2026-09-23-171159.png
2026-09-23-171317.png  2026-09-23-172236.png
2026-09-23-173122.png  2026-09-23-173208.png
2026-09-23-174523.png  2026-09-23-180206.png
2026-09-23-180455.png  2026-09-23-182445.png
2026-09-23-182845.png  2026-09-23-183445.png
2026-09-23-183704.png  2026-09-23-184131.png
2026-09-23-184234.png  2026-09-23-185303.png
2026-09-23-185710.png  2026-09-24-115618.png
2026-09-24-115711.png  2026-09-24-120235.png
2026-09-24-164247.png  2026-09-24-164334.png
2026-09-24-164357.png  2026-09-24-165113.png
```

Screenshots showing `decoded_as json` are retained here as failed/intermediate evidence only. They are not the final rule configuration.

### pip-audit — 14 files

```text
2026-09-24-173551.png  2026-09-24-174545.png
2026-09-24-174938.png  2026-09-24-233015.png
2026-09-24-233032.png  2026-09-24-233341.png
2026-09-24-233739.png  2026-09-24-233749.png
2026-09-24-234010.png  2026-09-24-234246.png
2026-09-24-234300.png  2026-09-24-235230.png
2026-09-24-235638.png  2026-09-24-235756.png
```

### wazuh-100203 — 10 files

```text
2026-09-25-000919.png  2026-09-25-001224.png
2026-09-25-001549.png  2026-09-25-002049.png
2026-09-25-002244.png  2026-09-25-003258.png
2026-09-25-003453.png  2026-09-25-004029.png
2026-09-25-011236.png  2026-09-25-011421.png
```

### shuffle-slack — 4 files

```text
2026-09-25-014348.png  2026-09-25-014529.png
2026-09-25-014725.png  2026-09-25-014742.png
```

### troubleshooting — 23 files

```text
2026-09-22-224921.png  2026-09-22-225253.png
2026-09-22-225554.png  2026-09-22-230121.png
2026-09-22-230526.png  2026-09-22-230913.png
2026-09-22-231022.png  2026-09-22-231406.png
2026-09-22-231709.png  2026-09-22-231900.png
2026-09-22-232301.png  2026-09-23-163707.png
2026-09-23-163722.png  2026-09-23-164930.png
2026-09-24-115312.png  2026-09-24-171408.png
2026-09-24-172923.png  2026-09-24-173113.png
2026-09-24-173207.png  2026-09-25-000501.png
2026-09-25-005415.png  2026-09-25-011554.png
2026-09-25-014454.png
```

`005415` and `011554` are pre-fix VirusTotal-routing evidence, not the final Slack design. `014454` is a post-fix replay validation image.

### final-state — 3 files

```text
2026-09-24-174720.png
2026-09-24-175336.png
2026-09-25-033935.png
```

## Withheld from the public draft

| Original screenshot | Reason |
| --- | --- |
| `Screenshot 2026-09-22 212716.png` | Raw `app.py` view exposes training authentication values; exclude rather than publish the values. |
| `Screenshot 2026-09-22 221208.png` | Raw `app.py` view exposes the training Flask secret and password; exclude rather than publish the values. |

No redacted derivative is required because safer application and Semgrep screenshots prove the same project facts without exposing the values.

## Secret rotation before publication

Rotate or revoke any live Slack incoming webhook, VirusTotal API key, or Shuffle webhook secret/token that appeared during the lab. None of those values is intentionally included in the staged evidence, but rotation is still recommended because the values were displayed during configuration.
