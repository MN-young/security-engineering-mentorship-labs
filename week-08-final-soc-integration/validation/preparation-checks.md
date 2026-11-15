# Local preparation checks

Checked on October 22, 2026. These are checks of the portfolio package; no live VM tests or fresh security scans were performed.

- Source ZIP integrity check passed.
- All 71 source PNGs decoded, matched the supplied dimensions and SHA-256 hashes, and had unique hashes.
- All 71 original source hashes still match after preparing copies.
- Exactly 45 publication copies are selected: 38 byte-identical copies and seven redacted copies.
- E06/E16 mask PHP session-cookie values. E35 masks all repeated webhook tokens. E41 masks callback tokens and every repeated hook-ID value.
- Pixels outside the explicit masks match the originals exactly; dimensions are unchanged.
- Local OCR of all four final redacted copies did not recover original cookie or webhook values. Public text files were also checked against recovered source secret values. Visual review supplemented OCR.
- Every local Markdown file/image link resolves, apart from the intentional Week 7 cross-link whose target was confirmed in the existing repository. The root index uses repository-relative links.
- The runbook has exactly four major sections: Detection, Triage, Containment, Lessons Learned.
- The README embeds ten selected images; the gallery contains all 45 actual selected copies.
- Historical configuration XML parses successfully. The supplied Task 48 diagram was extracted unchanged; all four Task 48 pages and the single Task 49 page were rendered and visually inspected. Both supplied Word documents retain their exact source hashes.
- The candidate repository excludes the raw archive, original handoff, unselected screenshots, OCR outputs, credentials and private processing files. Only the 45 selected safe image copies are included.
- Repository scope is limited to the new Week 8 folder and the main README; a separate profile README update is prepared. Weeks 1–7, active workflows and standalone projects remain unchanged. Only the selected evidence copies are included in the public portfolio.
