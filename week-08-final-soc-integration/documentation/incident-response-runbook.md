# Task 49 — Incident Response Runbook

[Original revised Word document](task-49-incident-response-runbook.docx). The four sections below retain the supplied runbook.

SCENARIO: RECONNAISSANCE AGAINST DVWA

This runbook is based on the controlled port scan I performed against DVWA during Week 8. It explains how I would handle the same alert as a SOC analyst, using the results I observed in my lab.

## Detection

I ran an Nmap TCP-connect scan from the Linux Agent (192.168.244.129) against the DVWA host (192.168.244.131). Suricata detected the activity with the signature “LOCAL TCP Port Scan Detected”. Wazuh first recorded it as rule 86601, level 3. I then used a targeted custom rule, 110750, to classify this specific scan as a level-8 alert.

The level-8 alert was forwarded to Shuffle, and the Wazuh SOAR Alerts app posted it in Slack #soc-alerts. I confirmed the same rule ID and alert description in Wazuh, Shuffle and Slack. That was my evidence that the notification actually came from the detected network event.

## Triage

After receiving the Slack notification, I would open the related Wazuh alert and check the timestamp, rule ID, source IP, destination IP and Suricata signature. I would confirm that the destination was the DVWA VM and compare the time of the scan with the lab test I performed. I would also check whether the scan was followed by suspicious login attempts or other alerts.

In this case, the source address belonged to my Linux lab VM and the scan was intentional. I would therefore classify it as authorized reconnaissance rather than a confirmed attack or compromise. The alert proves that the scan was detected; it does not prove that the attacker gained access.

## Containment

Because this was an approved test inside my isolated lab, I did not block the Linux Agent or shut down DVWA. Containment was not necessary for this specific event.

If I received the same alert from an unknown system or outside an approved test, I would first verify that the activity was unauthorized, then limit traffic from the source or isolate the affected VM if needed. I would make sure any blocking action was approved and did not disrupt other lab services.

## Lessons Learned

This test showed me that detecting suspicious traffic is only one part of incident response. I also needed a rule that gave the relevant event enough priority to reach Shuffle, a running webhook, and a working Slack action. The original Suricata rule was level 3, so it did not meet the Shuffle forwarding threshold of level 7. After I corrected the custom rule fields and tested again, the level-8 alert reached Slack.

I also learned to trace an alert using its rule ID and timestamp instead of assuming that a workflow execution belonged to my test. For this scenario, I verified the path from the DVWA scan to the final Slack notification. TheHive/Cortex case automation was not part of the successful response because that integration remained unavailable.

Technical clarification: the source document’s reference to the original “Suricata rule” being level 3 describes the Wazuh classification under base Rule 86601. The custom Wazuh rule is Level 8. Suricata signature metadata and the unexplained Shuffle payload severity 3 remain distinct.
