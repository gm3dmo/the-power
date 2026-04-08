# setup-github-app

Register, configure, and install a GitHub App for use with the-power's API
scripts. Covers private key generation, JWT creation, installation token
exchange, and verification.

## When to use

- You need to authenticate as a GitHub App rather than a PAT.
- You want to test App-based workflows (installation tokens, webhooks).
- Scripts like `tiny-dump-app-token.sh` or `tiny-call-get-installation-token.sh`
  require App credentials.

## Quick start

```bash
# After registering the app and generating a private key:
python3 gh-set-value.py --key private_pem_file --value /path/to/key.pem
python3 gh-set-value.py --key default_app_id --value 12345
python3 gh-set-value.py --key client_id --value Iv1.abc123
python3 gh-set-value.py --key default_installation_id --value 67890

# Verify
./tiny-dump-app-token.sh
```

## Prerequisites

- `.gh-api-examples.conf` (see `configure` skill)
- Ruby JWT gem (`sudo gem install jwt`)
- A GitHub organisation with admin access

## See also

- [SKILL.md](SKILL.md) for the full step-by-step guide
