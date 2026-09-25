# Reflection — unifying AppSec and SOC visibility

Week 6 showed that application-security findings do not have to remain isolated inside a CI/CD pipeline. Semgrep detected insecure code and pip-audit identified vulnerable dependencies, while Wazuh brought both finding types into the same monitoring environment used by the SOC.

Extending the flow through Shuffle and Slack made high-severity AppSec findings actionable by notifying the analyst. Developers received security feedback before vulnerable code could be deployed, while analysts gained application-risk visibility beside endpoint and infrastructure alerts.

The routing correction also demonstrated that integration quality is more than forwarding every alert through every tool. Rules `100202` and `100203` needed to reach Slack, but they did not need VirusTotal hash enrichment. Excluding them after Slack preserved analyst visibility and removed an irrelevant response step.

Overall, bringing code-level and dependency risks into the wider detection-and-response process created a stronger DevSecOps workflow without overstating the implementation boundary. The CI scanners were automated, the GitHub-to-endpoint artifact transfer remained manual, and the Wazuh-to-Shuffle-to-Slack path was automated.
