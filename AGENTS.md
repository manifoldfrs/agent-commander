# AGENTS.md - agent-commander

## Scope
This repository is the operating home for firstmate, treehouse, no-mistakes, AXI tools, and related agent harness work.
It owns local runtime configuration, pinned tool checkouts, generated shims, and durable fleet records.

## User Writing Preferences
These preferences are copied from `/Users/farishabib/dotfiles/AGENTS.md` and `/Users/farishabib/dotfiles/AGENTS.local.md`.
Apply them to chat replies, reports, PR descriptions, code comments, commit messages, and generated agent briefs.

When writing for this user, avoid:
- AI babble, generic filler, or overly polished phrasing.
- Em dashes. Use commas, periods, or parentheses instead.
- Dramatic contrast phrasing like "This isn't X, it's Y".
- Phrases like "that's the footgun", "the smoking gun is", or close variants.
- Jargon like "fail-fast", "fails the boot", "surface early", or "shift left".
- Verbose responses when a simple explanation is enough.

Explain concepts and solutions in simple terms, like a senior engineer teaching a new teammate.
When writing or substantially editing long Markdown files, put each full sentence on its own physical line.
Preserve normal Markdown structure, but avoid wrapping multiple sentences onto one physical line.
Review prose, summaries, code comments, PR descriptions, and chat replies for these patterns before presenting them.

## Repository Shape
- `libs/` contains pinned upstream tool checkouts as submodules.
- `bin/` contains generated command shims and firstmate helper scripts.
- `config/`, `data/`, `state/`, `projects/`, and `logs/` are local runtime areas and must stay out of git.
- `tools/toolchain.json` records the pinned toolchain.

## Commands
```bash
scripts/detect-tools.sh
scripts/detect-tools.sh --strict
agent-commander doctor
agent-commander install all
agent-commander shims
```

For submodule changes, read that submodule's own `AGENTS.md` or `CLAUDE.md` before editing.
For example, `libs/chrome-devtools-axi/AGENTS.md` says its committed skill file is generated from `src/skill.ts`.

## Change Rules
- Keep changes scoped to the requested tool or runbook.
- Do not introduce secrets in tracked files.
- Do not commit unless explicitly asked.
- Never add an agent name as a co-author.
- Do not manually edit generated files.
- Update source files and run the generator when a generated artifact is part of the checked-in contract.
- Prefer adding reusable runbooks under tracked `docs/` or project-specific docs instead of burying durable behavior in chat.

## Tool and Debugging Expectations
- If the user explicitly requires a named tool and that tool is unauthenticated, missing, pointed at the wrong root, or otherwise unusable, stop and report that exact blocker.
- Do not silently route around required tools when the user made tool usage part of the task.
- For bug work, start by reproducing the bug as close as practical to the end-user path.
- If external service behavior is the question, prefer a small direct probe script or request before relying on stale docs.
- When end-to-end testing a product, call out UI behavior that clearly looks wrong, even if it is adjacent to the current change.
- Fix lint failures, test failures, and obvious test flakiness you encounter when they are in scope for the touched project.

## Validation
Run targeted validation for each touched area:
- Root shell/tooling changes: `scripts/detect-tools.sh --strict`
- `libs/firstmate`: follow its `AGENTS.md`, usually `bash -n bin/*.sh` and the relevant `tests/*.test.sh`
- `libs/chrome-devtools-axi`: `pnpm run build:skill -- --check` after generator changes, plus targeted tests when code changes

Before handoff, report the changed files and the validation you ran.
