# ~/dotfiles

> My personal dotfiles

## Installation

Give your terminal Full Disk Access first (System Settings → Privacy & Security → Full Disk Access, then restart it). `macos.sh` needs it to add Spotlight exclusions.

```bash
./bootstrap.sh
```

Runs everything (dotfiles, Homebrew, zsh, macOS defaults). Re-runnable: already-installed packages and plugins are skipped or updated.

Partial runs:

```bash
./bootstrap.sh --dotfiles
./bootstrap.sh --brew
./bootstrap.sh --zsh
./bootstrap.sh --macos
./bootstrap.sh --yes          # skip confirmation
```

Machine-specific config (Android SDK, extra PATH, extra brew packages) goes in gitignored local files:

- `~/.zshrc.local`
- `~/.zprofile.local`
- `~/.gitconfig.local`
- `Brewfile.local` (next to `Brewfile`, before bootstrap)

Set Homebrew zsh as default shell (optional — macOS’s `/bin/zsh` is fine):

```bash
sudo sh -c "echo /opt/homebrew/bin/zsh >> /etc/shells"
chsh -s /opt/homebrew/bin/zsh
```
