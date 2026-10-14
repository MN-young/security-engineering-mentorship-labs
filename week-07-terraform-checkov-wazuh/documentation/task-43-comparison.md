# Task 43 — Preventive scanning and runtime detection

Checkov evaluates infrastructure code before deployment. In this lab it identified unrestricted IPv4 SSH ingress (`CKV_AWS_24`), and Wazuh also displayed the imported S3 lifecycle finding (`CKV2_AWS_61`). Fixing the source early lets an engineer review and validate the change before creating an exposed resource.

Wazuh supplies a different kind of visibility through endpoint logs, integrity monitoring, configuration assessment and other collected telemetry. Its ability to identify suspicious authentication or file changes depends on what is collected and which rules apply. In Week 7, Wazuh centralized Checkov's existing findings; it did not discover the Terraform weakness independently. See [Wazuh capabilities](https://documentation.wazuh.com/current/user-manual/capabilities/index.html).

Suricata analyzes network traffic visible to its sensor. Applicable rules can identify scan patterns, exploit signatures and other suspicious network activity. Sensor placement, encrypted traffic and rule coverage constrain what it sees. See [Suricata's overview](https://docs.suricata.io/en/latest/what-is-suricata.html).

| Question | Checkov | Wazuh | Suricata |
| --- | --- | --- | --- |
| What is examined? | IaC source and selected policies | Collected endpoint/security events and imported findings | Traffic presented to the sensor |
| Typical timing here | Before deployment | Existing monitored lab and runtime telemetry | Runtime network activity |
| Relevant example | World-open SSH in Terraform | Suspicious login events, monitored file changes, Checkov failure alert | Rule-matching scan or exploit traffic |
| Does it prove exploitation? | No | Only supporting event evidence within detection coverage | Only supporting network evidence within coverage |
| Does a pass prove complete security? | No; policy selection and parsing matter | No; collection/rules limit visibility | No; placement/rules/traffic visibility limit detection |

Earlier checks reduce the chance that a known source-level weakness becomes live exposure. Runtime controls remain necessary because source scans do not cover every attack, later configuration drift or operational mistake. The tools complement one another at different points in the lifecycle.

The result demonstrated here is narrowly bounded: the selected unrestricted-SSH policy changed from failed to passed. The allowed `10.7.0.0/16` range still spans the entire lab VPC. No AWS deployment, production hardening assessment or new Suricata attack test is claimed.

## Reflection and skills

The lab extended Week 6's developer-to-SOC visibility idea to infrastructure configuration. It reinforced three distinctions: valid Terraform is not automatically secure Terraform; one passing policy is not a passing full scan; an imported SIEM event is not evidence of live exploitation. Maintaining those distinctions makes the portfolio evidence useful to an engineer or analyst reviewing the work.
