# Troubleshooting screenshot manifest

| Final filename | Evidence |
| --- | --- |
| `01-linux-xml-parser-error.png` | Malformed agent XML identified during validation |
| `02-auth-log-collection-added.png` | `/var/log/auth.log` collection block added |
| `03-rule-5710-discovered.png` | Test event matched Rule `5710` |
| `04-parent-rule-corrected.png` | Custom rule changed from parent `5716` to `5710` |
| `05-docker-manager-variable-investigation.png` | Container initialization script variable investigation |
| `06-indexer-keystore-failure.png` | Indexer failed after keystore change |
| `07-indexer-keystore-recovered.png` | Indexer recovered after ownership and permission fix |
| `08-docker-agent-id-conflict.png` | Duplicate Docker agent enrollment conflict |

Never publish the screenshots that expose `wazuh-passwords.txt` or an exported Wazuh agent authentication key.

