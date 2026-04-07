# configure

Set up the-power's `.gh-api-examples.conf` for a target GitHub instance (GHES or dotcom).

## When to use

Before running any the-power script for the first time, or when switching to a different GitHub instance.

## Quick start

```bash
cd the-power
python3 configure.py
```

## What it does

Generates `.gh-api-examples.conf` with connection settings (hostname, token, org, repo) that every script in the-power sources at startup.

## See also

- [docs/setup.md](../../docs/setup.md) — Full setup guide
- [SKILL.md](SKILL.md) — Agent-facing instructions
