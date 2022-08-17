. .gh-api-examples.conf

# You can decode your jwt at: https://jwt.io/

JWT=$(ruby tiny-get-jwt.rb ${private_pem_file} ${default_app_id})

echo ${JWT}


echo "======================================================="  >&2
echo "Decoded jwt:"  >&2
echo ""  >&2
echo ${JWT} | jq -R 'split(".") | .[1] | @base64d | fromjson'  >&2
echo "======================================================="  >&2
