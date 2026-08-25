# Controlled validation

Run these commands only in an authorized, isolated lab.

## 1. Validate Suricata

On `wazuh-linux-agent`:

```bash
sudo suricata -T -c /etc/suricata/suricata.yaml
sudo systemctl restart suricata
sudo systemctl is-active suricata
```

## 2. Generate the test

From `wazuh-manager` (`192.168.244.128`):

```bash
sudo nmap -sS -p 1-1000 -T4 192.168.244.129
```

## 3. Verify the native Suricata alert

On `wazuh-linux-agent`:

```bash
sudo grep 'LOCAL TCP Port Scan Detected' /var/log/suricata/eve.json
```

Confirm the event contains Suricata signature ID `1000001` and category `Detection of a Network Scan`.

## 4. Verify Wazuh ingestion

In Wazuh Threat Hunting, search:

```text
data.alert.signature_id:1000001
```

Confirm that Wazuh displays `Suricata: Alert - LOCAL TCP Port Scan Detected`, maps it to rule `86601`, and records the expected source and destination addresses.
