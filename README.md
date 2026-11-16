# dotfiles

Personal dotfiles for Ubuntu 26.04, managed with [GNU Stow](https://www.gnu.org/software/stow/).

Covers shell (Fish), terminal multiplexer (tmux), editor (Neovim), and a one-shot system updater for APT, Snap, Flatpak, and Linuxbrew.

> Check out this [video](https://youtu.be/y6XCebnB9gs) made by [Dreams of Autonomy](https://www.youtube.com/@dreamsofautonomy) if you want to understand how it works.

## Structure

The repository mirrors `$HOME` directly — there are no per-tool package folders:

```
~/dotfiles/
├── .stow-local-ignore
├── README.md
└── .config/
    ├── fish/
    │   ├── config.fish
    │   └── functions/
    │       └── update.fish
    ├── tmux/
    │   └── tmux.conf
    └── nvim/
        └── lua/
            └── config/
                └── autocmds.lua
```

Because everything lives under a single `.config/` tree, the repo itself is treated as **one package** — we invoke Stow with the package name `.` and point `-d` at the repo root.

## Prerequisites

Install the tools these dotfiles depend on:

```bash
# Stow (link manager)
sudo apt install stow

# Fish shell
sudo apt install fish

# Neovim, tmux
sudo apt install neovim tmux

# Flatpak apps (examples)
flatpak install flathub <app-id>

# Linuxbrew (if not already installed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## Install / Bootstrap

Clone the repo, then link everything into `$HOME`:

```bash
git clone <your-remote> ~/dotfiles
stow -d ~/dotfiles -t ~ -v .
```

> **Do not** use `stow -t ~ dotfiles` from inside `~` — Stow will warn `skipping target which was current stow directory .` because the stow directory and target directory resolve to the same path. Always set `-d` explicitly.

### Why `-d` and `-t` are both required

Stow derives the *stow directory* from the current working directory by default. If you `cd ~` and also pass `-t ~`, the two directories collapse into one and Stow refuses to act. Passing `-d ~/dotfiles -t ~` keeps them distinct and unambiguous.

### Optional: disable tree-folding

By default Stow symlinks whole directories (e.g. `~/.config/fish` → `~/dotfiles/.config/fish`) when a directory is managed by only one package. If another tool writes into `~/.config/fish` or `~/.config/nvim` (plugin managers, LSP servers, etc.), use `--no-folding` so you get real directories with individual file symlinks:

```bash
stow -d ~/dotfiles -t ~ --no-folding -v .
```

## Daily Workflow

**After adding, removing, or renaming files in the repo, restow:**

```bash
stow -d ~/dotfiles -t ~ -R -v .
```

`-R` removes stale symlinks and creates new ones — it will not touch unrelated files in `$HOME`.

**Preview changes first** with a dry run:

```bash
stow -d ~/dotfiles -t ~ -n -v .
```

`-n` simulates; nothing on disk is modified.

**Verify a specific symlink:**

```bash
ls -la ~/.config/fish/functions/update.fish
# expect: ... -> ../../../dotfiles/.config/fish/functions/update.fish
```

## `.stow-local-ignore`

Prevents repo metadata from being symlinked into `$HOME`:

```
^\.git$
^\.gitignore$
^README\.md$
```

Add more patterns here (e.g. `^LICENSE$`, `^\.github$`) if you add repo-only files later.

## Troubleshooting

### `WARNING: skipping target which was current stow directory .`

You passed `-t ~` while the current directory was already `~`. Use the explicit form:

```bash
stow -d ~/dotfiles -t ~ -v .
```

### `cannot stow ... over existing target ... since neither a link nor a directory`

A real file or wrong symlink exists at the target path. Diff it first:

```bash
diff ~/.config/<path> ~/dotfiles/.config/<path>
```

Then resolve with one of:

```bash
# Stale — just remove it
rm ~/.config/<path>

# Keep local changes — adopt them into the repo
stow -d ~/dotfiles -t ~ --adopt -v .

# Be cautious — back up first
mv ~/.config/<path> ~/.config/<path>.bak
```

After resolving, re-run the dry run and apply once clean.

### `WARNING: in simulation mode so not modifying filesystem`

Expected — you used `-n`. Remove `-n` to apply changes.

### Symlink exists but file "not found"

The target of the symlink is missing (file was deleted from the repo without restowing). Fix:

```bash
stow -d ~/dotfiles -t ~ -R -v .
```

## Uninstall

Remove all symlinks created by Stow:

```bash
stow -d ~/dotfiles -t ~ -D -v .
```

This removes the symlinks but leaves your real `~/dotfiles` untouched and any non-stowed files in `$HOME` intact.
