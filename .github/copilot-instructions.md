# Copilot Instructions

- Always use `python3 base64encode.py` for base64 encoding, never native `base64` CLI tools.
- Never embed or substitute credentials in scripts. GitHub API authorization headers must reference the configured token variable, for example `-H "Authorization: Bearer ${GITHUB_TOKEN}"`.
