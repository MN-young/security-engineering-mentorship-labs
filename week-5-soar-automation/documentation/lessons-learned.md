# Lessons Learned

## Prove each boundary independently

The manual webhook test separated Shuffle ingress from Wazuh delivery. Direct Slack tests separated message transport from formatting. DNS and HTTPS checks separated connectivity from an authenticated VirusTotal lookup. This made later failures easier to localize.

## A running UI is not a working SOAR execution path

Shuffle's frontend could be available while apps, Orborus, workers, Docker networks, or images were still unhealthy. End-to-end proof requires a completed execution, not only a reachable page.

## Expected negative results deserve first-class branches

VirusTotal 404 is useful information. Treating it as an expected no-record branch improved both playbook clarity and analyst interpretation. Unknown is not the same as benign.

## Alert quality matters as much as delivery

Hello World and raw payload tests were valuable transport checks, but the useful outcome was a concise message with rule, severity, endpoint, file, hash, and time. The repeated Cron alerts also showed why routing policy and noise control must be intentional.

## Enrichment evidence must show the actual lookup

DNS resolution, an open port, or an HTTP response from a service can prove parts of a network path. They cannot prove a VirusTotal file lookup succeeded. The final evidence uses actual API statuses and response bodies.

## Vendor verdicts are dynamic

The EICAR hash produced different malicious-engine totals in separate runs. Documentation should preserve the observed timestamp/result without presenting the count as a permanent property.

## Secrets leak easily through screenshots

Webhook URLs appeared in command lines, action results, configuration, and logs. Twenty-three screenshots had to be withheld. Future evidence collection should collapse secret fields, use placeholders before capture, and rotate credentials immediately if exposed.

## Failure history strengthens the engineering story

Worker instability, image problems, network errors, and formatting mistakes explain the controls and checks that became necessary. Keeping that history makes the project more reproducible than a success-only walkthrough.
