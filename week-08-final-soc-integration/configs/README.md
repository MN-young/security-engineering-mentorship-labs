# Configuration provenance

[week8-recon-rule.xml](week8-recon-rule.xml) transcribes the complete corrected rule visible in E66. It preserves the historical lab IP pair and detection metadata; it contains no credential. It is a documented example, not a recovered VM export or a new installed rule. XML parsing was checked locally; semantic operation is supported by the historical screenshots E70, not a fresh Wazuh execution.

The complete SQLi signature appears in the [detection document](../documentation/detection-engineering.md). The scan signature's source line is clipped, so no full port-scan rule is invented. Full Compose configuration, Wazuh integration blocks, environment files, Slack/Shuffle hooks and API credentials are deliberately absent. The supplied screenshots do not establish enough safe complete configuration to publish these as recovered files.
