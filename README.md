# Homebrew tap for agent

This tap publishes the `agent` Homebrew formula.

## Local install from this checkout

```sh
brew tap calebcauthon/agent ~/code/agent-tap
brew install calebcauthon/agent/agent
```

## GitHub install

If this repository is pushed as `github.com/calebcauthon/homebrew-agent`, users can install with:

```sh
brew tap calebcauthon/agent
brew install calebcauthon/agent/agent
```

If it is pushed with a different repo name, pass the URL explicitly:

```sh
brew tap calebcauthon/agent https://github.com/calebcauthon/homebrew-agent
brew install calebcauthon/agent/agent
```

## Formula

- `Formula/agent.rb` installs commands: `agent`, `room`, `rooms`, `agents`, and `logs`.
- The formula currently builds from `https://github.com/calebcauthon/agent.git` on `main`.

## Validate this tap

```sh
./scripts/check.sh --verbose
```

