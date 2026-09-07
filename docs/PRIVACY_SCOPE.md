# Website policies and beta metadata — 2026-09-07

The user requested privacy/terms/support pages, `info@cantavue.com` feedback, then a TestFlight information update. All public copy is in four ARB bundles (separate Simplified/Traditional Chinese and English). Policy/support documents are plain HTML without a Flutter dependency; home-page links preserve locale. The site's existing public audience and verified `www.cantavue.com` binding are preserved. No DNS or access changes are needed.

## Data flow evidence

- Main app local library, annotations, practice records, histories, local snapshots, and exports: README, engineering data contract, F12-07, F15-01/02, F16 and current implementation records. Deletion of one score does not imply erasure of all backups or history.
- Optional image/camera import: iOS Info.plist and scanner/photo implementations. Face gestures: `ios/Runner/AppDelegate.swift` explicitly does not persist/transfer frames, facial identifiers, landmarks or templates.
- Audio: local record/tuner adapters; no developer-hosted upload in the production main app. Permission availability varies with build/platform.
- IMSLP: `docs/product/imslp_native_search_2026-09-06.md`; explicit terms/requests to third party, temporary confirmation webview, no private-library upload. The public policy describes potential current beta flows without declaring them fully verified in build 4.
- CantaLink: F15-08 and `cantavue_link_io.dart`; session authentication, score/layout hashes, positions/commands; no PDF/title/annotation/account payload, no claim of TLS or hardware certification.
- Sites: official documentation confirms platform visitor/page-view statistics. The previous homepage claim of no visitor analytics was inaccurate and has been replaced. No custom analytics SDK, forms, account system or file uploads were added.
- User-initiated support email and Apple TestFlight diagnostics/feedback are separate from local app processing. The public address is user-provided. Mail delivery itself has not been tested; no unsolicited email was sent.

## Current primary sources consulted

- https://developer.apple.com/app-store/review/guidelines/#privacy
- https://developer.apple.com/help/app-store-connect/test-a-beta-version/provide-test-information
- https://developer.apple.com/help/app-store-connect/test-a-beta-version/invite-external-testers
- https://www.apple.com/legal/privacy/data/en/test-flight/
- https://learn.chatgpt.com/docs/sites
- https://openai.com/policies/privacy-policy/
- https://imslp.org/wiki/IMSLP:Privacy_policy

This records product-specific drafting and source checks, not a legal opinion or proof of compliance in every jurisdiction. The copy does not invent a registered operating entity, a governing jurisdiction, an arbitrary fixed retention term, or certified security. Existing Apple license agreements are not replaced or accepted through this work. App privacy labels and native permission-string completeness still need exact-binary release review, as does an easily accessible policy link within the app itself.

No new app binary, signature or app behavior is introduced by website/metadata changes. The 185 requirement records and their IDs remain unchanged. Existing main-app check failures are recorded separately, not treated as passed by website tests.

## Validation

- Website static analysis: passed, no issues. Existing widget suite: 5/5 passed, including 320 px / 200% text for all three languages.
- Production Flutter Web build and Wasm dry run passed. 12 HTML documents passed locale/canonical, internal link/asset/anchor and public-email checks; all 9 policy/support documents are readable without JavaScript. Reviewer contact details are absent from published documents.
- Four ARB bundles contain 133 messages each. Local font subsets total 1,503,120 bytes; fontTools verified each language's required characters.
- Navigation bridge checked for three localized routes and mailto; unrelated destinations rejected. No email was sent. No browser screenshots/interaction QA was performed.
- Main app `dart run tool/check.dart`: exit 1, unchanged 25 formatting differences among 630 Dart files; SDK, lockfile, 4 ARB bundles (1,913 messages) and pinned Web resources passed before the formatting gate. Main app analysis/tests did not execute in that run.
