# Payment Debug Loop

Use this runbook for multi-service payment incidents where UI, backend, workflow, and vendor behavior can all be involved.
It captures the loop that worked during the USDT Acceptance debugging session.

## Order Of Operations
1. Define the intended contract from specs and code.
2. Reproduce the user-visible failure as close as practical to the real user path.
3. Find the concrete payment, session, operation, and workflow identifiers.
4. Read logs and workflow history for that exact operation.
5. Probe the external vendor or dependency directly with the smallest safe request.
6. Patch the smallest service boundary that violated the contract.
7. Add a regression test that would have caught the exact bug.
8. Re-run the end-to-end path and verify logs, workflow completion, and user-visible copy.

## Tool Contract
If the task requires a named tool, verify it first.
Examples: RepoPromptCE root, Datadog auth, Temporal auth, gh-axi auth, chrome-devtools-axi session, or a local vendor script.
If the tool is unavailable, stop and report the blocker instead of silently substituting another path.

## Evidence To Capture
- User-visible URL, session ID, payment operation ID, authorization ID, quote ID, and workflow ID.
- The exact log query or event that identifies the failure.
- Temporal failure cause, activity name, and retry state.
- Vendor request shape and response, with secrets removed.
- The service boundary that translated or mutated the data.
- File and line references for the fix and tests.

## Vendor Probe Pattern
When docs and live behavior disagree, trust a direct probe over memory.
Keep probes untracked.
Good locations:
- `/tmp/<vendor>-probe-*`
- `scripts/tmp_<vendor>_probe.*` when the repo already uses untracked scripts and the user approves

Probe rules:
- Print the endpoint, method, sanitized headers, and sanitized body.
- Never print API keys, bearer tokens, private keys, seed phrases, or durable wallet credentials.
- Accept pasted throwaway signatures or payloads from stdin or a local gitignored file.
- Make quote-only requests before submit or execution requests when possible.
- Keep request variants small so one field changes at a time.

## Payment UI Rule
Separate merchant-facing and payer-facing values.
The merchant order total and settlement asset can be different from the payer's funding asset and quoted input amount.
When a payer route or wallet authorization option exists, payer-facing copy should use that route's source amount and asset.
Before a route exists, avoid fake specificity.
Show the order total as an order total, not as a claim about what the payer must fund with.

## Regression Rule
Every bug found by the loop should leave one automated check behind.
Prefer the narrowest test that proves the broken contract:
- parser or converter test for wrong vendor payload handling
- workflow or activity test for wrong step selection
- hook or component test for wrong UI amount or asset display
- integration test when the bug crossed service boundaries
