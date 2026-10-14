# Troubleshooting record

This record preserves the manual's failed attempts, corrections and validation. Screenshot IDs refer to the [evidence catalog](../evidence/README.md); unselected originals were still reviewed. Commands below describe historical steps, not actions executed on the current lab during this update.

## Checkov not found outside the virtual environment

The symlink pointed to a literal `HOME/.venvs/checkov/bin/checkov`. Leaving the virtual environment produced command-not-found/no-such-file output. Inspecting PATH and the executable exposed the mismatch. The correction removed the bad link, linked `/usr/local/bin/checkov` to `/home/sysadmin/.venvs/checkov/bin/checkov`, cleared shell command caching with `hash -r`, and verified `command -v checkov` plus version 3.3.22. Screenshot 016 retains the full correction. Earlier repeated link attempts are excluded from the selected set.

## IP works while DNS fails

Screenshot 019 shows 8.8.8.8 ping replies but repeated hostname-resolution failures. Route inspection, systemd-resolved status and the resolver-stub symlink were checked. Public resolver overrides and a VMware-gateway override still produced `No route to host` at those checkpoints.

Screenshot 021 records Windows VMware NAT/DHCP restart attempts and waiting warnings. It is not the final recovery proof. Screenshot 020 shows the observed recovery sequence: `resolvectl revert ens33`, restart the resolver, `networkctl renew ens33`, restart systemd-networkd and the resolver, then query and ping verification. Gateway and hostname pings succeeded, and the DNS query returned answers. The record does not isolate one decisive command or establish a durable root cause.

## Terraform syntax repair and command typo

`Invalid multi-line string` errors appear in 033. The operator inspected source with sed, tried awk quote diagnostics and Python inspection, and encountered further syntax errors in those diagnostic commands (034). The broken source was copied to `main.tf.broken`; editing continued over SSH. Screenshot 038 preserves the `terraform ftm` typo and correction to `terraform fmt`. Screenshot 041 establishes successful initialization and configuration validation after repair.

Original screenshot 035 and earlier terminal output contain watchdog soft-lockup messages. These are observations only; their cause and relationship to Terraform or networking are not established.

## AWS session and Terraform planning

Screenshot 042 shows no valid credential sources and an expired login session. The historical recovery involved logout, a time/synchronization check, remote login and profile refresh. Browser `400 Bad Request` was also observed (043). The identity check succeeded in 046, but that image exposes Account/ARN/UserId and is excluded. Authorization URLs/codes in 025–027 and 044–045 are excluded entirely.

The resulting successful plan in 047 proposes 3 additions, 0 changes and 0 destructions. The plan is not an apply. The record does not establish that every authorization retry succeeded or that resources were deployed.

## Report exports, directories and log paths

A terminal scan did not automatically create a report. Explicit `-o json` redirection and file checks followed. Screenshot 052 shows a 9.1K report at the earlier `../reports/checkov-results.json` checkpoint; later 069/070 show a 92K root `checkov-output.json`. Screenshot 065 shows the reports directory absent at another checkpoint. Inspect actual paths before extracting findings.

The manual separately records genuine missing collection-file and missing-localfile checkpoints; the historical response was to create `/var/log/checkov`, touch/populate the log, merge collection configuration, test and restart the agent. Screenshot 057 has a more specific visible error: the command uses `/var/log/chceckov/checkov.log` (a typo), then the correctly spelled path successfully displays a populated normalized record. Do not use that screenshot alone to claim the correctly named file was absent.

## Raw JSON, schema transition and one-finding extraction

The raw Checkov report contains arrays, result objects and source snippets. The collector input was reduced to compact one-event-per-line JSON. Early `source/event_type/status` records and final `integration/result` records differ. The first Python extraction selected `failed_checks[0]`; it demonstrated one actual finding but assumed nonempty results and ordering. The corrected final automation iterated all failed checks. The strict reference normalizer in the handoff is a later improvement, not an original VM script.

## Wazuh decodes JSON but initially matches Rule 1002

Screenshot 061 shows JSON decoding succeeded while filtering reached generic Rule 1002 Level 2. Matching fields and rule structure were corrected. The manual also records a Week 7 block placed inside Week 6's Semgrep group; the correction closed Week 6 and opened a separate Checkov group. Existing rules were preserved.

The historical rule family is 110700 Level 5 parent, 110701 Level 12 FAILED child. Screenshot 062 corroborates the definition; 064 directly proves final matching with a synthetic `insecure_sg` event. The earlier reference package's Level 0 parent is replaced by the documented Level 5 logic in this proposal.

## Wazuh warnings and configuration checks

CDB/malicious-IOC warnings `(7616)` and related warnings concern older rules/lists. The manual records `wazuh-analysisd -t` exit 0; cropped screenshot 063 shows zero status and warning context, without the full test command. Screenshot 064 independently shows successful Checkov matching despite warning noise. Neither establishes that unrelated CDB rules were repaired.

`wazuh-control configtest` returned usage because that argument was unsupported. Process status and collector validation are different checks: use the documented `wazuh-logcollector -t` on the agent and `wazuh-analysisd -t` on the manager. Usage text is not a validation pass.

The manual also records a trailing slash in the collection location and an apparent closing-tag paste mistake. Preserve the corrected `/var/log/checkov/checkov.log` and inspect the surrounding XML. The pasted closing-tag issue is not independently established as a separate runtime parser failure.

## Script permissions, absent file and working directory

The manual reports `Permission denied` on direct execution; running via Bash or granting execute permission were the corrections. Earlier manager alerts did not prove that failed script run succeeded. It also records launching from `terraform/`, checking the root with `cd ..`, `pwd` and `ls`, then discovering an absent script at a later checkpoint and recreating it. These are separate observations, not proof of deletion.

Intermediate screenshot 076 scans `.` and opens `checkov-output.json` relative to the launch directory. Final 078 explicitly changes into the Terraform directory and uses `../checkov-output.json` consistently. Screenshot 077 shows root launch, execute permission and multiple failures forwarded. Acceptance was then checked in manager output (079) and dashboard records (081–083). The historical script's `|| true` and limited downstream error handling remain documented.

## Dashboard query and time window

The manual reports initial `No Results`, followed by tighter field/rule queries and a wider event window. Original records have historical timestamps. Final documents were found. Query/time filtering was investigated, but the original root cause is not conclusively established. The final S3 document is not the SSH pass or an AWS runtime event.

## Remote editing and command hygiene

Long JSON and VMware clipboard limitations led to compact events and two SSH sessions. Nano `Ctrl+V` pages down; terminal paste was used where supported. Save/discard and VM/session confusion were resolved deliberately. SCP was suggested but its successful execution is unverified. An SSH disconnect returned to PowerShell; no specific network cause is proven.

Historical `git log -1 -oneline` and the later malformed `git log -2 --oneline` attempt produced option errors (093/098). These are lightweight workflow observations, not README highlights. Source and ignore-file review preceded the historical commit/push. The current proposal creates no new commit or push.

## CI job failed on findings

Screenshot 102 shows an actual Checkov S3 failure followed by exit code 1. Screenshot 100 includes Node/runner notices. Those notices are not the demonstrated cause of the job failure. Local Wazuh ingestion was validated separately; automatic CI-to-Wazuh delivery is unproven.

## Handoff history and task framing

The manual's earlier local handoff publication attempt was denied with HTTP 403. That is historical context, not a new failure in this task. The current user-approved workflow requires a complete review before any GitHub write, regardless of access availability.

Task 42 is the selected SSH correction. The manual defines Task 43 as preventive Checkov versus Wazuh/Suricata monitoring; this update also preserves the requested before/after comparison. Earlier contradictory numbering is not silently adopted.
