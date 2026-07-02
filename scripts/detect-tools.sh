#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AGENT_COMMANDER_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
STRICT=0
MISSING=0

usage() {
  cat <<'USAGE'
Usage: scripts/detect-tools.sh [--strict] [--agent-commander-dir PATH]

Detect agent toolchain commands from global commands or local libs/ checkouts.

Options:
  --strict                    Exit non-zero when a tool is missing.
  --agent-commander-dir PATH  Override the agent-commander root.
  -h, --help                  Show this help.
USAGE
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --strict)
      STRICT=1
      ;;
    --agent-commander-dir)
      if [ "$#" -lt 2 ]; then
        echo "error: --agent-commander-dir requires a path" >&2
        exit 2
      fi
      AGENT_COMMANDER_DIR="$2"
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "error: unknown argument: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
  shift
done

AGENT_COMMANDER_DIR="$(cd "$AGENT_COMMANDER_DIR" && pwd)"

mark_found() {
  local tool="$1"
  local source="$2"
  local detail="$3"

  printf 'ok\t%s\t%s\t%s\n' "$tool" "$source" "$detail"
}

mark_missing() {
  local tool="$1"
  local detail="$2"

  printf 'missing\t%s\t-\t%s\n' "$tool" "$detail"
  MISSING=1
}

detect_firstmate() {
  local path
  local local_dir="$AGENT_COMMANDER_DIR/libs/firstmate"

  if path="$(command -v fm-bootstrap.sh 2>/dev/null)"; then
    mark_found "firstmate" "global" "$path"
  elif [ -f "$local_dir/bin/fm-bootstrap.sh" ] && [ -f "$local_dir/AGENTS.md" ]; then
    mark_found "firstmate" "local" "$local_dir"
  else
    mark_missing "firstmate" "expected fm-bootstrap.sh or libs/firstmate"
  fi
}

detect_treehouse() {
  local path
  local local_dir="$AGENT_COMMANDER_DIR/libs/treehouse"

  if path="$(command -v treehouse 2>/dev/null)"; then
    mark_found "treehouse" "global" "$path"
  elif [ -x "$local_dir/treehouse" ]; then
    mark_found "treehouse" "local-binary" "$local_dir/treehouse"
  elif [ -f "$local_dir/go.mod" ] && [ -f "$local_dir/main.go" ]; then
    mark_found "treehouse" "local-source" "$local_dir"
  else
    mark_missing "treehouse" "expected treehouse command or libs/treehouse"
  fi
}

detect_no_mistakes() {
  local path
  local local_dir="$AGENT_COMMANDER_DIR/libs/no-mistakes"

  if path="$(command -v no-mistakes 2>/dev/null)"; then
    mark_found "no-mistakes" "global" "$path"
  elif [ -x "$local_dir/bin/no-mistakes" ]; then
    mark_found "no-mistakes" "local-binary" "$local_dir/bin/no-mistakes"
  elif [ -f "$local_dir/go.mod" ]; then
    mark_found "no-mistakes" "local-source" "$local_dir"
  else
    mark_missing "no-mistakes" "expected no-mistakes command or libs/no-mistakes"
  fi
}

detect_gh_axi() {
  local path
  local local_dir="$AGENT_COMMANDER_DIR/libs/gh-axi"

  if path="$(command -v gh-axi 2>/dev/null)"; then
    mark_found "gh-axi" "global" "$path"
  elif [ -f "$local_dir/dist/bin/gh-axi.js" ]; then
    mark_found "gh-axi" "local-build" "$local_dir/dist/bin/gh-axi.js"
  elif [ -f "$local_dir/package.json" ]; then
    mark_found "gh-axi" "local-source" "$local_dir"
  else
    mark_missing "gh-axi" "expected gh-axi command or libs/gh-axi"
  fi
}

detect_chrome_devtools_axi() {
  local path
  local local_dir="$AGENT_COMMANDER_DIR/libs/chrome-devtools-axi"

  if path="$(command -v chrome-devtools-axi 2>/dev/null)"; then
    mark_found "chrome-devtools-axi" "global" "$path"
  elif [ -f "$local_dir/dist/bin/chrome-devtools-axi.js" ]; then
    mark_found "chrome-devtools-axi" "local-build" "$local_dir/dist/bin/chrome-devtools-axi.js"
  elif [ -f "$local_dir/package.json" ]; then
    mark_found "chrome-devtools-axi" "local-source" "$local_dir"
  else
    mark_missing "chrome-devtools-axi" "expected chrome-devtools-axi command or libs/chrome-devtools-axi"
  fi
}

detect_lavish_axi() {
  local path
  local local_dir="$AGENT_COMMANDER_DIR/libs/lavish-axi"

  if path="$(command -v lavish-axi 2>/dev/null)"; then
    mark_found "lavish-axi" "global" "$path"
  elif [ -f "$local_dir/dist/cli.mjs" ]; then
    mark_found "lavish-axi" "local-build" "$local_dir/dist/cli.mjs"
  elif [ -f "$local_dir/package.json" ]; then
    mark_found "lavish-axi" "local-source" "$local_dir"
  else
    mark_missing "lavish-axi" "expected lavish-axi command or libs/lavish-axi"
  fi
}

printf 'status\ttool\tsource\tdetail\n'
detect_firstmate
detect_treehouse
detect_no_mistakes
detect_gh_axi
detect_chrome_devtools_axi
detect_lavish_axi

if [ "$STRICT" -eq 1 ] && [ "$MISSING" -ne 0 ]; then
  exit 1
fi
