# libs

Pinned upstream tool checkouts live here when the tools are not installed globally.

Expected local paths:

```text
libs/firstmate/
libs/treehouse/
libs/no-mistakes/
libs/gh-axi/
libs/chrome-devtools-axi/
libs/lavish-axi/
```

Use Git submodules for these directories. Do not copy upstream tool scripts into dotfiles.

```sh
git submodule update --init libs/firstmate libs/treehouse libs/no-mistakes libs/gh-axi libs/chrome-devtools-axi libs/lavish-axi
```

The current reference URLs and revisions are tracked in `../tools/toolchain.json` and pinned by the superproject gitlinks.
