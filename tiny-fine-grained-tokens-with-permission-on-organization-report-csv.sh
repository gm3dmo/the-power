./tiny-list-fine-grained-personal-access-tokens-with-access-to-organization-resources.sh |\
 jq -r '["id", "owner_login", "token_last_used_at", "token_expires_at"], ( .[] | [ .id, .owner.login, .token_last_used_at, .token_expires_at ]) | @csv'
