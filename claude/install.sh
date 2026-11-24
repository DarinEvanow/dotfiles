#!/usr/bin/env zsh
############################
# Sets up Claude Code's status line from this repo:
# - links ~/.claude/statusline.sh to claude/statusline.sh
# - sets "statusLine" in ~/.claude/settings.json, keeping every other setting
# Safe to re-run.
############################

set -euo pipefail

script_dir="${0:A:h}"
claude_dir="${HOME}/.claude"
settings="${claude_dir}/settings.json"

if ! command -v jq &>/dev/null; then
    echo "jq is required for the Claude status line; skipping."
    exit 0
fi

mkdir -p "${claude_dir}"
chmod +x "${script_dir}/statusline.sh"
ln -sfn "${script_dir}/statusline.sh" "${claude_dir}/statusline.sh"

[[ -f "${settings}" ]] || echo '{}' > "${settings}"
tmp="$(mktemp)"
jq '.statusLine = {type: "command", command: "~/.claude/statusline.sh", padding: 0}' "${settings}" > "${tmp}"
cat "${tmp}" > "${settings}"
rm -f "${tmp}"

echo "Claude status line linked. Restart Claude Code (or start a new session) to see it."
