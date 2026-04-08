---
name: setup-github-app
description: >
  Guide agents through registering, configuring, and installing a GitHub App
  for use with the-power. Covers private key generation, .gh-api-examples.conf
  setup, JWT creation, installation token exchange, and verification.
keywords:
  - GitHub App
  - app
  - authentication
  - JWT
  - token
  - installation
  - private key
  - app ID
  - client ID
  - ghs
  - tiny
---

# Setup a GitHub App

Walk through creating a GitHub App and configuring the-power to authenticate
with it. At the end you will have a working `ghs_` installation token.

## Working directory

All scripts **must** be run from the root of a the-power repository clone
(the directory containing `.gh-api-examples.conf`).

Find an existing clone:

```bash
find ~ -maxdepth 5 -name "tiny-dump-app-token.sh" -path "*/the-power/*" 2>/dev/null
```

## Prerequisites

1. `.gh-api-examples.conf` must exist (see the `configure` skill).
2. A GitHub organisation where you have admin access.
3. The Ruby JWT gem:

   ```bash
   sudo gem install jwt
   ```

## Step-by-step process

### 1. Register the app

In the GitHub UI navigate to:

**Organisation → Settings → Developer settings → GitHub Apps → New GitHub App**

Fill in the basics:

| Field | Example value |
|---|---|
| App name | `test-app` (must be unique across GitHub) |
| Homepage URL | `https://example.com/homepage` |
| Webhook URL | `https://example.com/webhook` or a [smee.io](https://smee.io) channel |

### 2. Set permissions

Choose the permissions the app needs for the scripts you plan to run. Start
with a minimal set and add more later — but remember to approve permission
changes in the installation UI (see below).

### 3. Create the app

Click **Create GitHub App**. You will land on the app's settings page.

### 4. Generate a private key

On the app settings page, scroll to **Private keys** and click
**Generate a private key**. A `.pem` file downloads automatically.

Keep it safe — you need the path to this file in step 6.

### 5. Install the app on your organisation

In the left sidebar click **Install App**, then **Install** next to your
organisation. Choose repository access (all or selected).

### 6. Configure the-power

Set the GitHub App values in `.gh-api-examples.conf`:

```bash
python3 gh-set-value.py --key private_pem_file --value /path/to/your-app.private-key.pem
python3 gh-set-value.py --key default_app_id --value <App ID>
python3 gh-set-value.py --key client_id --value <Client ID>
python3 gh-set-value.py --key default_installation_id --value <Installation ID>
```

### 7. Verify the setup

```bash
./tiny-dump-app-token.sh
```

Expected output:

```
++++++++++++++++++++++ App Token ++++++++++++++++++++++

ghs_w0wTh1sReAlLyIsAToKeN0rSomETH1nGLoOKSgrEAt

+++++++++++++++++++++++++++++++++++++++++++++++++++++++
```

If you see a `ghs_` token, the app is working.

## Where to find IDs

| ID | Where to find it |
|---|---|
| App ID | Organisation → Settings → Developer settings → GitHub Apps → your app (near the top) |
| Client ID | Same page as App ID |
| Installation ID | Organisation → Settings → GitHub Apps → gear icon → check the URL: `.../installations/<ID>` |

## Approving permission changes

When you update an app's permissions, you **must** approve the change in the
installation UI:

1. Go to Organisation → Settings → GitHub Apps → gear icon
2. Click **Review request**
3. Click **Accept new permissions**

If you skip this, the permission change will not take effect.

## Key scripts

| Script | Purpose |
|---|---|
| `tiny-get-jwt.py` | Generate a JWT from the private key (Python) |
| `tiny-get-jwt.rb` | Generate a JWT from the private key (Ruby) |
| `tiny-call-get-jwt.sh` | Shell wrapper that calls `tiny-get-jwt.rb` |
| `tiny-call-get-installation-token.sh` | Exchange JWT for an installation access token |
| `tiny-dump-app-token.sh` | End-to-end: generate JWT → get token → print it |
| `tiny-get-an-app.sh` | Get app metadata |
| `tiny-list-app-installations.sh` | List app installations |
| `create-an-installation-access-token-for-an-app-modified-permissions.sh` | Token with custom permissions |
| `create-an-installation-access-token-for-an-app-selected-repo-modified-permissions.sh` | Token scoped to specific repos |

## See also

- `docs/setting-up-a-gh-app.md` in the-power
- [SO YOU WANT TO USE A GITHUB APP ON YOUR ORG](https://gist.github.com/sn2b/acd544bdbe6e4fdf0dc3418b5df188a9)

## Error handling

- **401 "A JSON web token could not be decoded"** — the private key path is
  wrong, the key is corrupted, or the JWT gem is not installed.
- **404 on installation endpoint** — the installation ID is wrong, or the app
  is not installed on the organisation.
- **403 "Resource not accessible by integration"** — the app lacks the required
  permissions, or a permission change has not been approved.
- **422 "No installation found"** — the `default_installation_id` does not
  match an active installation.

## Boundaries

- **Do not display the full private key or app token.** Show only the first
  8 characters of tokens.
- **Do not commit `.pem` files** to any repository.
- **Do not modify `.gh-api-examples.conf` directly** unless asked. Use
  `python3 gh-set-value.py` to change individual values.
