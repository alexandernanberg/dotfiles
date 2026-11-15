export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_UPGRADE_AUTO_UPDATES_CASKS=1

if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Load the SSH key from Keychain into the agent, so commit signing works after a reboot.
# Only when the agent is empty: the load itself takes ~250ms.
ssh-add -l >/dev/null 2>&1 || ssh-add --apple-load-keychain -q 2>/dev/null

[[ -f ~/.zprofile.local ]] && source ~/.zprofile.local
