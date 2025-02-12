.  ./.gh-api-examples.conf

shopt -s -o nounset
JWT=$(ruby tiny-get-jwt.rb ${ent_app_private_pem} ${ent_app_id})

echo ""  >&2
echo ""  >&2
echo "================= Private Pem File ===================="  >&2
echo " pem file: (private key): ($ent_app_private_pem)" >&2
echo ""  >&2
echo "======================================================="  >&2
echo ""  >&2
echo ""  >&2

echo "======================== JWT =========================="  >&2
echo ""  >&2
echo ${JWT}
echo ""  >&2
echo "======================================================="  >&2
echo ""  >&2
echo ""  >&2

echo "==================== Decoded JWT ======================"  >&2
echo ""  >&2
echo ${JWT} | jq -R 'split(".") | .[1] | @base64d | fromjson'  >&2
echo ""  >&2
echo "======================================================="  >&2
