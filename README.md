# agent-commander

Public operating home for firstmate, treehouse, no-mistakes, AXI tools, and related agent harness work.

This repository owns local runtime configuration and state for agent workflows. The sibling `dotfiles` repository remains the reproducible installer/config layer and should only manage the shared launcher, docs, Stow validation, and ignore hardening.

## Repository Shape

```text
agent-commander/
|-- libs/
|   |-- firstmate/
|   |-- treehouse/
|   |-- no-mistakes/
|   |-- gh-axi/
|   |-- chrome-devtools-axi/
|   `-- lavish-axi/
|-- scripts/
|-- bin/
|-- config/
|-- data/
|-- state/
`-- projects/
```

`libs/` is reserved for pinned upstream tool checkouts when tools are not installed globally. These entries are Git submodules pinned by this repo so personal and work laptops use the same tool revisions without copying upstream tool scripts into dotfiles.

## Toolchain

The tracked toolchain manifest records the current upstream source and pinned reference revision for each agent-facing tool:

```text
tools/toolchain.json
```

Initialize pinned tool checkouts after cloning this repo:

```sh
git submodule update --init libs/firstmate libs/treehouse libs/no-mistakes libs/gh-axi libs/chrome-devtools-axi libs/lavish-axi
```

The detector prefers global commands and falls back to local submodule checkouts under `libs/`:

```sh
scripts/detect-tools.sh
scripts/detect-tools.sh --strict
```

Detected tools:

```text
firstmate              fm-bootstrap.sh or libs/firstmate
treehouse              treehouse or libs/treehouse
no-mistakes            no-mistakes or libs/no-mistakes
gh-axi                 gh-axi or libs/gh-axi
chrome-devtools-axi    chrome-devtools-axi or libs/chrome-devtools-axi
lavish-axi             lavish-axi or libs/lavish-axi
```

The dotfiles-managed `agent-commander install <tool>` command initializes these submodules when they are listed in `.gitmodules`, then builds tools that need local build output.
Use `agent-commander install all` to initialize and build the full pinned toolchain.
It also writes generated command shims into `bin/`; run `agent-commander shims` to refresh them without reinstalling tools.

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
bin/
.no-mistakes/
/treehouse/
libs/*/node_modules/
logs/
*.log
```

Do not Stow this repository. Use it as the operating home for agent tools and keep reproducible shell/editor setup in `dotfiles`.
