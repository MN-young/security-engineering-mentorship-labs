# Troubleshooting Chronology

This record keeps the failed states and recovery path that led to the final Week 5 playbook. Root causes are stated only where the evidence supports them; otherwise the entry records the observed symptom and the checks that narrowed it.

## 1. Fresh VM and baseline connectivity

**Issue / risk:** A new SOAR VM introduced another network and resource dependency into the lab.

**Evidence:** Host, address, route, and basic connectivity checks were captured before deployment.

**Investigation:** The VM's Ubuntu baseline, local address, and reachability to existing lab systems and external services were checked.

**Fix / action:** Network settings were corrected as needed before installing Shuffle.

**Validation:** The host could proceed to package and Docker installation. See [baseline evidence](../evidence/00-baseline-install/).

## 2. Docker installation and Shuffle deployment

**Issue:** Shuffle could not be meaningfully debugged until the container runtime was known-good.

**Evidence:** The standard Docker test initially documented the runtime state; the repository clone and deployment commands followed.

**Investigation:** Docker service behavior, image execution, compose files, and container state were checked.

**Fix / action:** Docker was installed correctly and Shuffle was cloned/deployed from its repository.

**Validation:** Docker's test container completed and Shuffle containers were created.

## 3. OpenSearch and `vm.max_map_count`

**Issue:** OpenSearch startup showed the expected sensitivity to host virtual-memory settings, and dependent services did not immediately settle.

**Evidence:** OpenSearch logs and container state were inspected during the initial bring-up.

**Investigation:** The host's `vm.max_map_count` value was compared with the deployment prerequisite.

**Fix / action:** `vm.max_map_count` was set to `262144` and the stack was restarted/observed.

**Validation:** OpenSearch progressed far enough for Shuffle's frontend/backend to become usable. Evidence: [OpenSearch inspection](../evidence/00-baseline-install/2026-09-18-095639.png) and [core services](../evidence/00-baseline-install/2026-09-18-095717.png).

## 4. Shuffle UI and app-store usability

**Issue:** The UI was reachable, but expected actions/apps were unavailable, inactive, or difficult to load.

**Evidence:** Screenshots show the initial administrator setup, app search/activation attempts, and incomplete action availability.

**Investigation:** App activation state, UI search behavior, backend responses, and available local images were checked.

**Fix / action:** The workflow was simplified for testing while app/tool availability was repaired; the required utility and HTTP actions were loaded through the backend path.

**Validation:** Test nodes became selectable and later executions produced results. Evidence is retained across [baseline/install](../evidence/00-baseline-install/) and [runtime troubleshooting](../evidence/01-shuffle-runtime-troubleshooting/).

## 5. `shuffle-tools` availability and image build

**Issue:** The `shuffle-tools` action was not reliably available to executions.

**Evidence:** The source was cloned/hot-loaded, and backend logs showed attempts to prepare the corresponding image.

**Investigation:** Local app files, backend build behavior, image names, and the worker execution path were inspected.

**Fix / action:** The app source was made available to Shuffle and the backend build path was exercised.

**Validation:** Evidence shows the backend successfully building the tools image, after which a basic action could complete. See [runtime evidence](../evidence/01-shuffle-runtime-troubleshooting/).

## 6. Orborus, workers, and Docker Swarm execution path

**Issue:** Containers repeatedly remained in preparing/restarting states and workflow jobs did not consistently execute.

**Evidence:** Orborus environment output, worker/backend network inspection, Swarm service state, runtime errors, and repeated container preparation were captured.

**Investigation:** Checks covered:

- Orborus configuration and worker image values;
- Docker Swarm services and stale service removal;
- worker/backend shared networks;
- backend port reachability;
- DNS inside execution containers;
- availability of tools such as `nc`, `wget`, and a Python runtime;
- image pull/build behavior.

**Fix / action:** Stale services were removed, Orborus was recreated/restarted with the intended configuration, networks were rechecked, and required images/tools were prepared.

**Validation:** A webhook-sourced test execution later finished in Shuffle. This validates the recovered path without claiming every transient runtime symptom had one proven root cause.

## 7. Resource pressure and soft-lockup symptoms

**Issue:** The host displayed soft-lockup/resource-pressure symptoms while multiple Shuffle containers and builds were active.

**Evidence:** Memory usage, per-container resource consumption, system messages, and container restart/preparation behavior were captured.

**Investigation:** `free`-style memory checks, container statistics, and kernel messages were reviewed to determine whether resource exhaustion contributed to instability.

**Fix / action:** Container state was reduced/cleaned where possible and the stack was allowed to recover before repeating focused tests.

**Validation:** Later webhook, Wazuh, Slack, and VirusTotal runs completed. The evidence supports resource pressure as a relevant observation, but not a single exclusive cause for all worker failures.

## 8. HTTP app/service image pull and recovery

**Issue:** The HTTP action needed for Slack and VirusTotal could not run consistently while its service image was missing, preparing, or failing to pull.

**Evidence:** Image pull/build attempts and action availability checks appear in the runtime and networking evidence sets.

**Investigation:** The host's external reachability, Docker image state, backend logs, and execution-container behavior were separated from the later API-level tests.

**Fix / action:** The required image was pulled/built after connectivity recovered and the HTTP action was retried.

**Validation:** Subsequent HTTP actions returned real Slack and VirusTotal responses.

## 9. Manual webhook test

**Issue:** Wazuh integration could not be debugged safely until Shuffle ingress worked independently.

**Evidence:** A manual POST returned HTTP `200` and an execution ID; the corresponding run completed with `TASK26_OK`.

**Investigation:** Payload shape, endpoint reachability, trigger status, and execution details were reviewed.

**Fix / action:** The webhook was kept active and used as the known-good entry point for the next stage.

**Validation:** [Finished manual execution](../evidence/02-webhook-wazuh-integration/2026-09-19-141133.png). The raw request screenshots were withheld because they expose the live webhook identifier.

## 10. Wazuh integration configuration and service restart

**Issue:** A working manual webhook did not yet prove the Wazuh manager could deliver alerts.

**Evidence:** Integration configuration, Wazuh restart output, `wazuh-integratord` status, and subsequent real alert payloads were captured.

**Investigation:** The integration block, JSON format, manager process state, and endpoint reachability were checked.

**Fix / action:** The integration was configured and Wazuh was restarted; the integratord process was verified.

**Validation:** A real Linux-agent FIM event reached Shuffle as Rule `550`.

## 11. Wazuh connection failures while Shuffle was unreachable

**Issue:** Wazuh integration logs showed connection failures and maximum-retry messages when the Shuffle endpoint could not be reached.

**Evidence:** The raw log screenshot contains the live webhook URL and is therefore excluded from the repository.

**Investigation:** The observed error was correlated with Shuffle availability, container state, port reachability, and subsequent recovery. The evidence demonstrates an unreachable endpoint; it does not justify inventing a more specific network root cause.

**Fix / action:** Shuffle service/network availability was restored and delivery was retried.

**Validation:** Later Rule `550` events arrived at Shuffle, proving recovery.

## 12. Shuffle DNS and outbound HTTPS for VirusTotal

**Issue:** VirusTotal access behaved inconsistently between the host and execution-container paths. Evidence included DNS results, failed outbound attempts, an IPv6/NAT64-looking address with a network-unreachable result, and later HTTP responses.

**Evidence:** [VirusTotal/networking evidence](../evidence/03-networking-virustotal/) includes name-resolution, packet, and HTTP tests.

**Investigation:** Tests deliberately separated:

- DNS resolution;
- raw IP reachability;
- general outbound HTTPS;
- host versus container behavior;
- VirusTotal endpoint reachability;
- authenticated API lookup results.

An HTTP `405` from an inappropriate method/path proved that an HTTP service answered; it did **not** prove that enrichment worked.

**Fix / action:** Container DNS/network configuration and image availability were rechecked, then the actual authenticated lookup was repeated.

**Validation:** Real API calls later returned both `404` and `200`, which is the correct enrichment proof.

## 13. Slack app/webhook and placeholder messages

**Issue:** Delivery and formatting needed to be validated separately.

**Evidence:** Direct test posts and early Hello World/placeholder messages were captured before the final alert format.

**Investigation:** Webhook response, target channel, JSON payload, and visual readability were checked.

**Fix / action:** The message was progressively replaced with Wazuh fields and a consistent security-alert layout.

**Validation:** The clean Rule `550` message appeared in `#soc-alerts`. Screenshots showing the webhook URL are excluded; safe Slack/channel screenshots remain in [Slack evidence](../evidence/04-slack-alerting/).

## 14. Alert noise and conditional logic

**Issue:** Repeated Rule `111801` Cron messages cluttered the Slack output.

**Evidence:** The channel captured repeated Cron alerts, and the Shuffle condition editor shows the final two-condition branch.

**Investigation:** The rule ID and severity of noisy events were compared with the desired FIM validation event.

**Fix / action:** Added `level > 6` and `rule.id != 111801` as AND conditions.

**Validation:** A new Rule `550` FIM event passed and produced the clean Slack alert; the demonstrated Cron rule was excluded from this branch.

## 15. VirusTotal 404 handling

**Issue:** A 404 can be misclassified as a failed integration.

**Evidence:** The API returned `404` with `NotFoundError` for the unique file hash; the Slack message stated that no record existed.

**Investigation:** The response status/body and queried SHA-256 were checked, and the result was compared with the deliberately unique test input.

**Fix / action:** A dedicated 404 condition and Slack Not Found action were added.

**Validation:** The unknown-file test followed the correct route. It is neither a connectivity failure nor a clean verdict.

## 16. VirusTotal 200 handling

**Issue:** The known-hash path required a safe, repeatable validation artifact and analyst-readable statistics.

**Evidence:** The harmless EICAR test string generated a Rule `550` event; VirusTotal returned `200`; Slack showed the analysis counts and report context.

**Investigation:** The file hash, HTTP status, response object, branch condition, and downstream Slack result were correlated within the run.

**Fix / action:** The 200 branch extracted the analysis statistics and formatted the Slack Enrichment message.

**Validation:** The final handoff run showed `65` malicious, `0` suspicious, `0` harmless, and `2` undetected. An earlier screenshot showed `66` malicious, demonstrating why vendor totals must be presented as dynamic point-in-time observations.

## 17. Final two-branch validation

The last validation sequence repeated both tests and preserved:

- the endpoint command/artifact;
- the initial Rule `550` alert;
- the Shuffle execution;
- the VirusTotal `404` or `200` result;
- the matching analyst-facing Slack message.

This completed the technical basis for the Task 31 analyst handoff.

