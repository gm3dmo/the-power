.  ./.gh-api-examples.conf

JWT=$(ruby tiny-get-jwt.rb ${private_pem_file} ${default_app_id})

echo ""  >&2
echo ""  >&2
echo "================= Private Pem File ===================="  >&2
echo " pem file: (private key): ($private_pem_file)" >&2
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
