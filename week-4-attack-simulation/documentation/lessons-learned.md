# Week 4 Lessons Learned

## 1. Attack execution and detection are independent results

Atomic can fail a prerequisite, time out, or encounter a logging problem while still generating useful telemetry. Conversely, an Atomic can return exit code `0` and still reveal a detection gap. Every stage must be checked separately.

## 2. “No alert” is not one failure mode

Week 4 produced several different reasons for missing alerts:

- no process-execution telemetry for T1059.004,
- no decoder match and incomplete live collection for T1053.003,
- no current rule for credential-file search in T1552.001,
- a test artifact outside FIM scope for T1070.004,
- intentional TheHive routing scope that excluded host rule `111801`.

Accurate classification is more valuable than treating every miss as a broken SIEM.

## 3. Host telemetry is necessary but not sufficient

Linux clearly logged the Cron execution, but Wazuh did not initially alert. The event still had to be collected, decoded, and matched to a rule.

## 4. Offline and live validation answer different questions

`wazuh-logtest` proved that the new decoder and rule could analyze a sample. It did not prove that `wazuh-linux-agent` was forwarding the live source. Explicit syslog collection completed that second half.

## 5. Agent attribution matters

Rule `111801` first appeared live for `wazuh-docker-agent`. That demonstrated rule health, but not success on the Atomic endpoint. Checking `agent.name` prevented a false conclusion.

## 6. Integration scope must be documented

TheHive received T1046 because the Week 3 bridge was designed around rule `86601`. It did not receive T1053 rule `111801`. This was expected routing behavior, not evidence that the Cron alert failed.

## 7. Coverage gaps are useful results

The three gaps translate directly into an engineering roadmap: process telemetry, credential-access detections, and risk-based FIM scope. Honest negative results make the portfolio more credible and the SOC more actionable.

## 8. Do not tune only for a green matrix

Adding all of `/tmp` to real-time FIM would make the controlled T1070 test easier to detect, but it could create substantial operational noise. Detection design should follow risk, telemetry value, and maintainability—not a desire for every test to pass.

## 9. Elevated shells are different environments

Changing to root altered `$HOME`, module discovery, dependency visibility, default Atomics paths, and ownership of the shared execution log. Tooling state must be validated after privilege changes.

## 10. Evidence boundaries protect technical accuracy

The Microsoft repository download recovered after connectivity checking and an explicit retry, but the original cause was not proven. The documentation preserves what happened without inventing certainty.
