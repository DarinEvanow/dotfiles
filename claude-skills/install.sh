#!/usr/bin/env zsh
############################
# Links the vendored Claude Code skills in this repo (claude-skills/matt-pocock)
# into Claude Code's global skill directories, so they're available in every
# project on this machine, not just repos that vendor them locally.
#
# Safe to re-run: it only ever replaces symlinks it created itself. If a name
# already exists as a real file/directory (not a symlink), it's left alone
# and reported so you can resolve the conflict by hand.
############################

set -euo pipefail

# Resolve this script's directory so it works regardless of cwd.
script_dir="${0:A:h}"
skills_src="${script_dir}/matt-pocock"

agents_skills_dir="${HOME}/.agents/skills"
claude_skills_dir="${HOME}/.claude/skills"

mkdir -p "${agents_skills_dir}" "${claude_skills_dir}"

linked=()
skipped=()

for skill_path in "${skills_src}"/*/; do
    name="$(basename "${skill_path%/}")"
    agents_target="${agents_skills_dir}/${name}"
    claude_target="${claude_skills_dir}/${name}"

    # Don't clobber a real (non-symlink) directory someone else put there.
    if [[ -e "${agents_target}" && ! -L "${agents_target}" ]]; then
        skipped+=("${name} (${agents_target} exists and isn't a symlink)")
        continue
    fi
    if [[ -e "${claude_target}" && ! -L "${claude_target}" ]]; then
        skipped+=("${name} (${claude_target} exists and isn't a symlink)")
        continue
    fi

    ln -sfn "${skills_src}/${name}" "${agents_target}"
    ln -sfn "../../.agents/skills/${name}" "${claude_target}"
    linked+=("${name}")
done

echo "Linked ${#linked[@]} skill(s):"
for name in "${linked[@]}"; do
    echo "  - ${name}"
done

if (( ${#skipped[@]} )); then
    echo
    echo "Skipped ${#skipped[@]} skill(s) (already present as a real file/dir):"
    for entry in "${skipped[@]}"; do
        echo "  - ${entry}"
    done
fi

echo
echo "Done. Start a new Claude Code session for the skills to be picked up."
