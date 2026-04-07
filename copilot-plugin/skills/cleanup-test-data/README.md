# cleanup-test-data

Remove test organisations, repos, teams, and other resources created by the-power scripts.

## When to use

After testing is complete and you need to tear down resources. Always clean up shared instances.

## Quick start

```bash
cd the-power
./delete-repo.sh my-test-repo        # delete a single repo
# Or delete the entire org:
curl -X DELETE -H "Authorization: token ${GITHUB_TOKEN}" "${GITHUB_API_BASE_URL}/orgs/${org}"
```

## See also

- [SKILL.md](SKILL.md) — Agent-facing instructions
