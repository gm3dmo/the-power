---
name: troubleshoot
description: >
  Diagnose and fix common issues in the-power GitHub API test environment.
  Covers SSL/certificate errors, token and authentication problems,
  HTTP error codes, rate limits, GHES admin API issues, and configuration
  verification.
keywords:
  - troubleshoot
  - debug
  - error
  - fix
  - SSL
  - certificate
  - token
  - rate limit
  - 401
  - 403
  - 404
  - 422
---

# Troubleshoot

Diagnose and resolve common issues when working with the-power scripts.

## Known issues

### SSL certificate verification failures (macOS Python)

`configure.py` fails with `SSL: CERTIFICATE_VERIFY_FAILED`.

**Fix:** Go to your Python.framework directory and run
`Install Certificates.command`.

### Self-signed certificates on GHES

curl fails with "SSL certificate problem: self signed certificate".

**Fix:** Set in `.gh-api-examples.conf`:

```
curl_custom_flags="--insecure"
```

### base64 encoding breaks scripts

**Always use `python3 base64encode.py`** for base64 encoding. Never use
native `base64` CLI tools — they behave inconsistently across platforms.
See [#70](https://github.com/gm3dmo/the-power/issues/70).

### Chrome storage issues with smee.io

**Fix:** Chrome > Developer Tools > Application > Storage. Clear smee entries.

## HTTP error diagnosis

### 401 Unauthorised

| Cause | Fix |
|-------|-----|
| Bad token | Re-generate and update config |
| Expired token | Generate a new PAT |
| Wrong hostname | Token was created on a different instance |

### 403 Forbidden

| Cause | Fix |
|-------|-----|
| Insufficient scope | Add required scopes (`admin:org`, `repo`, `delete_repo`) |
| SSO not authorised | Authorise the token for SSO access |
| IP restrictions | Check org/enterprise IP allow list |

### 404 Not Found

| Cause | Fix |
|-------|-----|
| Wrong org/repo name | Check for typos |
| Resource does not exist | Create it first |
| Insufficient permissions | GitHub returns 404 instead of 403 for private resources |

### 422 Unprocessable Entity

| Cause | Fix |
|-------|-----|
| Validation error | Check required fields in the JSON payload (`tmp/` directory) |
| Resource already exists | Change name or delete the existing one |
| Invalid field values | Check API docs for valid enum values |

## Diagnostic scripts

| Script | Purpose |
|--------|---------|
| `./get-authenticated-user.sh` | Confirm token is valid |
| `./get-an-organization.sh` | Verify target org exists |
| `./get-rate-limit-status-for-the-authenticated-user.sh` | Check rate limits |

> **Note:** `check-a-token.sh` often returns 401 on GHES even with a valid
> token. Use `get-authenticated-user.sh` instead.

## GHES admin API issues

- **Site admin endpoints** (`/admin/`) require site-admin privileges.
- **Management console API** uses a separate password, not a PAT.
- If admin endpoints return 404/403, confirm the token user is a site admin.

## Config verification

```bash
cat .gh-api-examples.conf | grep -E '^(hostname|org|repo|team_slug)='
```

Check for:
- `hostname` matches target instance
- `org` and `team_slug` match existing resources
- `curl_custom_flags` includes `--insecure` if needed for self-signed certs

## Boundaries

- **Do not display the full GITHUB_TOKEN value.** Show only the first
  8 characters when confirming configuration.
- **Do not modify `.gh-api-examples.conf`** without user consent.
