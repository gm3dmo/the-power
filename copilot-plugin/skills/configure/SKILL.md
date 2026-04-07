---
name: configure
description: >
  Configure the-power for a target GitHub instance. Run configure.py to
  generate .gh-api-examples.conf with hostname, token, org, repo, and other
  settings. Covers interactive and non-interactive setup, GHES vs dotcom
  differences, curl flags for self-signed certs, and GitHub App configuration.
keywords:
  - configure
  - setup
  - config
  - .gh-api-examples.conf
  - hostname
  - token
  - GHES
  - dotcom
  - configure.py
---

# Configure

Generate the `.gh-api-examples.conf` file that every script in the-power
sources for connection settings.

## Working directory

All scripts **must** be run from the root of a the-power repository clone.

Find an existing clone:

```bash
find ~ -maxdepth 5 -name "configure.py" -path "*/the-power/*" -not -path "*/copilot-plugin/*" 2>/dev/null
```

Or clone fresh:

```bash
git clone https://github.com/gm3dmo/the-power.git
cd the-power
```

## Interactive mode

```bash
python3 configure.py
```

You will be asked for:

1. **GitHub hostname** — the API hostname (e.g. `myserver.example.com` for
   GHES, or `api.github.com` for dotcom)
2. **Personal Access Token** — a PAT with the scopes you need
3. **Organisation name** — defaults to `acme`
4. **Webhook URL** — defaults to a smee.io channel

## Non-interactive mode

```bash
python3 configure.py \
  --hostname myserver.example.com \
  --token ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx \
  --webhook-url https://events.hookdeck.com/e/src_abc123
```

Common flags:

| Flag | Default | Purpose |
|------|---------|---------|
| `--hostname HOST` | (prompted) | API hostname |
| `--token TOKEN` | (prompted) | Personal access token |
| `--org NAME` | `acme` | Organisation name |
| `--repo NAME` | `testrepo` | Default repository name |
| `--repo-webhook-url URL` | `smee` | Webhook URL |
| `--primer SCRIPT` | `pwr-get-octocat.sh` | Script to run after setup |
| `--curl_custom_flags FLAGS` | `--no-progress-meter --fail-with-body` | Custom curl flags |
| `--app-configure` | `no` | Set to `yes` for GitHub App setup |

Run `python3 configure.py --help` for the full list.

## Key config variables

### Connection

| Variable | Example | Description |
|----------|---------|-------------|
| `hostname` | `myserver.example.com` | API hostname |
| `GITHUB_TOKEN` | `ghp_...` | Bearer token |
| `GITHUB_API_BASE_URL` | `https://HOST/api/v3` | REST base URL |
| `GITHUB_APIV4_BASE_URL` | `https://HOST/api/graphql` | GraphQL base URL |

### Organisation and repo

| Variable | Default | Description |
|----------|---------|-------------|
| `org` / `owner` | `acme` | Target organisation |
| `repo` | `testrepo` | Target repository |
| `team_slug` | `justice-league` | Default team slug |

### GHES self-signed certificates

For instances with self-signed certs, set:

```
curl_custom_flags="--insecure"
```

## GHES vs dotcom

`configure.py` adjusts paths automatically:

| Setting | GHES | dotcom |
|---------|------|--------|
| `GITHUB_API_BASE_URL` | `https://HOST/api/v3` | `https://api.github.com` |
| `GITHUB_APIV4_BASE_URL` | `https://HOST/api/graphql` | `https://api.github.com/graphql` |

## Integration with ghe-boot / cs-boot

On instances provisioned by ghe-boot or cs-boot, `configure.py` reads
`environment.json` from the current or home directory and uses its hostname
and token as defaults.

## Validating the configuration

```bash
./get-authenticated-user.sh     # Confirm token is valid
./get-an-organization.sh        # Verify target org exists
```

## Error handling

- If `configure.py` fails with an SSL error, see the `troubleshoot` skill.
- If `get-authenticated-user.sh` returns 401, the token is invalid or expired.
- If `get-an-organization.sh` returns 404, the org does not exist yet.
  On GHES, use `build-all.sh` to create it automatically.

## Boundaries

- **Do not display the full GITHUB_TOKEN value.** When confirming config,
  show only the first 8 characters.
- **Do not modify `.gh-api-examples.conf` directly** unless the user
  explicitly asks. Always use `configure.py` or `gh-set-value.py`.
