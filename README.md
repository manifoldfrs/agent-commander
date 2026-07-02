# agent-commander

Public operating home for firstmate, treehouse, lavish-axi, and related agent harness work.

This repository owns local runtime configuration and state for agent workflows. The sibling `dotfiles` repository remains the reproducible installer/config layer and should only manage the shared launcher, docs, Stow validation, and ignore hardening.

## Repository Shape

```text
agent-commander/
|-- libs/
|   |-- firstmate/
|   |-- treehouse/
|   `-- lavish-axi/
|-- scripts/
|-- config/
|-- data/
|-- state/
`-- projects/
```

`libs/` is reserved for pinned upstream tool checkouts when tools are not installed globally. Prefer git submodules or pinned clones there over copying upstream tool scripts into dotfiles.

## Toolchain

The tracked toolchain manifest records the current upstream source and pinned reference revision for each agent-facing tool:

```text
tools/toolchain.json
```

Checkpoint 2 does not clone or install tools. It adds detection logic that prefers global commands and falls back to local checkouts under `libs/`:

```sh
scripts/detect-tools.sh
scripts/detect-tools.sh --strict
```

Detected tools:

```text
firstmate   fm-bootstrap.sh or libs/firstmate
treehouse   treehouse or libs/treehouse
lavish-axi  lavish-axi or libs/lavish-axi
```

## Local Config

Machine-specific config is local and ignored. Recommended initial files:

```text
config/backlog-backend
config/crew-harness
config/secondmate-harness
config/crew-dispatch.json
```

## Ignore Policy

Runtime state, local config, and generated output must stay out of git. The tracked `.gitignore` and local `.git/info/exclude` both cover:

```text
.env
config/
data/
state/
projects/
.no-mistakes/
treehouse/
libs/*/node_modules/
logs/
*.log
```

Do not Stow this repository. Use it as the operating home for agent tools and keep reproducible shell/editor setup in `dotfiles`.
