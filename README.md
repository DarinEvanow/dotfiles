# dotfiles

Personal machine setup: shell config, Neovim config, and Claude Code skills. Clone this on any new computer to get everything back in place.

```sh
git clone https://github.com/DarinEvanow/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

`install.sh` symlinks the shell files (`.zshrc`, `.zprofile`, `.bashrc`, `.bash_profile`) and `nvim/` into place, links the Claude Code skills (see below), then runs `brew.sh` to install Homebrew packages/casks.

## Claude Code skills (Matt Pocock's skills)

`claude-skills/matt-pocock/` vendors a copy of the engineering/productivity skills from [mattpocock/skills](https://github.com/mattpocock/skills) — things like `tdd`, `code-review`, `triage`, `domain-modeling`, etc. See `claude-skills/matt-pocock/SOURCES.md` for the full list and each skill's upstream path.

They're vendored (copied) rather than pulled live so a fresh machine only needs one `git clone` — no extra tool, no network access to GitHub required at install time beyond cloning this repo.

### Setting them up on a new Mac

Prerequisite: [Claude Code](https://claude.com/claude-code) installed (`npm install -g @anthropic-ai/claude-code` or the native installer).

Claude Code loads skills from two places on disk:

- `~/.agents/skills/<name>/` — where a skill's actual files live
- `~/.claude/skills/<name>/` — Claude Code scans this directory to know what skills exist; each entry here is normally a symlink into `~/.agents/skills/`

`claude-skills/install.sh` sets up exactly that: for every skill vendored in this repo, it symlinks `~/.agents/skills/<name>` to the copy in this repo, then symlinks `~/.claude/skills/<name>` to that. Because both are symlinks, `git pull` in this repo instantly updates the skills everywhere on the machine — no re-install step needed after the first time.

**On a brand-new Mac**, this happens automatically as part of `./install.sh` above. If you ever need to (re-)link the skills on their own — e.g. after adding a new skill to `claude-skills/matt-pocock/`, or setting up Claude Code after the fact — run just that step:

```sh
cd ~/dotfiles
./claude-skills/install.sh
```

It's safe to re-run any time. It only ever touches symlinks it created itself; if something already exists at `~/.agents/skills/<name>` or `~/.claude/skills/<name>` as a real file/directory (not a symlink), it leaves it alone and prints a warning instead of overwriting it.

After it runs, **start a new Claude Code session** (or open a new project) — skills are discovered at session start, so one already running won't pick up new ones.

### Adding or updating a skill

1. Fetch the skill's folder from `mattpocock/skills` at the path listed in `SOURCES.md` (or a new path, for a new skill).
2. Drop it into `claude-skills/matt-pocock/<name>/`, overwriting the old copy.
3. Update `SOURCES.md`.
4. Commit. Any machine that already ran `claude-skills/install.sh` picks up the change on its next `git pull` — no need to re-run the install script.

### Known limitation

In testing, a project with many skills symlinked into `.claude/skills` didn't surface all of them as "available" in a given Claude Code session — only a subset showed up, with no visible config explaining the cut. If a skill you expect to see isn't listed, that's a known Claude Code quirk rather than a problem with the symlinks; try naming the skill directly (e.g. `/skill-name` or asking for it by name) rather than assuming it's missing.
