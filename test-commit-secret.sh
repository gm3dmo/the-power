
.  ./.gh-api-examples.conf

# This script is intended to run after build-testcase-secret-scanning

# If a secret is not being detected:

# Locate the pattern here: https://docs.github.com/en/enterprise-cloud@latest/code-security/secret-scanning/introduction/supported-secret-scanning-patterns?learn=secret_scanning&learnProduct=code-security

# It's really not a good idea to use shell scripting to test these keys.

# If the pattern has a tick only in the "Partner" column then the User
# will never get a report of the pattern, it is reported directly to the
# provider when found in a public repo.
# In this example script the datadog_api_key pattern is an example.
# Some tools that scan may be scanning for DATADOG_API_KEY as a hint
# that a token may be stored there.

cd src/${repo}
# We split the token in 2 so that it's never checked in to the power
# in a way that will set off a false positive (hopefully).

# Breaking tokens up to get past a secret scanner is a bad thing
# it will likely get you fired.


if [ -z "$1" ]
  then
    keyname=all
  else
    keyname=$1
fi

function github_pat () { 
    gh1=ghp_9
    gh2=gDO8kvREKK9toy7CsUunZEY77XvGA1pNv5F
    export gh1 gh2
    echo "Commit: GitHub PAT"
    echo export GITHUB_TOKEN=${gh1}${gh2} >github.token.compromised.secret.txt
}

function github_pat_base64 () { 
    # https://github.blog/changelog/2025-02-14-secret-scanning-detects-base64-encoded-github-tokens/
    gh1=ghp_9
    gh2=gDO8kvREKK9toy7CsUunZEY77XvGA1pNv5F
    echo "Commit: GitHub PAT Base64"
    pat_base64=$(echo ${gh1}${gh2} | ../../base64encode.py)
    echo export ${pat_base64} >github.token.base64.compromised.secret.txt
}

function entra_1 () {
   entra1_1="eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6IjdfWnVmMXR2a3dMeFlhSFMzcTZsVWpVWUlHdyIsImtpZCI6IjdfWnVmMXR2a3dMeFlhSFMzcTZsVWpVWUlHdyJ9"
   entra1_2=".eyJhdWQiOiJiMTRhNzUwNS05NmU5LTQ5MjctOTFlOC0wNjAxZDBmYzljYWEiLCJpc3MiOiJodHRwczovL3N0cy53aW5kb3dzLm5ldC9mYTE1ZDY5Mi1lOWM3LTQ0NjAtYTc0My0yOWYyOTU2ZmQ0MjkvIiwiaWF0IjoxNTM2Mjc1MTI0LCJuYmYiOjE1MzYyNzUxMjQsImV4cCI6MTUzNjI3OTAyNCwiYWlvIjoiQVhRQWkvOElBQUFBcXhzdUIrUjREMnJGUXFPRVRPNFlkWGJMRDlrWjh4ZlhhZGVBTTBRMk5rTlQ1aXpmZzN1d2JXU1hodVNTajZVVDVoeTJENldxQXBCNWpLQTZaZ1o5ay9TVTI3dVY5Y2V0WGZMT3RwTnR0Z2s1RGNCdGsrTExzdHovSmcrZ1lSbXY5YlVVNFhscGhUYzZDODZKbWoxRkN3PT0iLCJhbXIiOlsicnNhIl0sImVtYWlsIjoiYWJlbGlAbWljcm9zb2Z0LmNvbSIsImZhbWlseV9uYW1lIjoiTGluY29sbiIsImdpdmVuX25hbWUiOiJBYmUiLCJpZHAiOiJodHRwczovL3N0cy53aW5kb3dzLm5ldC83MmY5ODhiZi04NmYxLTQxYWYtOTFhYi0yZDdjZDAxMWRiNDcvIiwiaXBhZGRyIjoiMTMxLjEwNy4yMjIuMjIiLCJuYW1lIjoiYWJlbGkiLCJub25jZSI6IjEyMzUyMyIsIm9pZCI6IjA1ODMzYjZiLWFhMWQtNDJkNC05ZWMwLTFiMmJiOTE5NDQzOCIsInJoIjoiSSIsInN1YiI6IjVfSjlyU3NzOC1qdnRfSWN1NnVlUk5MOHhYYjhMRjRGc2dfS29vQzJSSlEiLCJ0aWQiOiJmYTE1ZDY5Mi1lOWM3LTQ0NjAtYTc0My0yOWYyOTU2ZmQ0MjkiLCJ1bmlxdWVfbmFtZSI6IkFiZUxpQG1pY3Jvc29mdC5jb20iLCJ1dGkiOiJMeGVfNDZHcVRrT3BHU2ZUbG40RUFBIiwidmVyIjoiMS4wIn0=.UJQrCA6qn2bXq57qzGX_-D3HcPHqBMOKDPx4su1yKRLNErVD8xkxJLNLVRdASHqEcpyDctbdHccu6DPpkq5f0ibcaQFhejQNcABidJCTz0Bb2AbdUCTqAzdt9pdgQvMBnVH1xk3SCM6d4BbT4BkLLj10ZLasX7vRknaSjE_C5DI7Fg4WrZPwOhII1dB0HEZ_qpNaYXEiy-o94UJ94zCr07GgrqMsfYQqFR7kn-mn68AjvLcgwSfZvyR_yIK75S_K37vC3QryQ7cNoafDe9upql_6pB2ybMVlgWPs_DmbJ8g0om-sPlwyn74Cc1tW3ze-Xptw_2uVdPgWyqfuWAfq6Q"

    echo "Commit: Entra token v1 microsoft_azure_entra_id_token https://learn.microsoft.com/en-us/entra/identity-platform/id-tokens#sample-v10-id-token"
    echo "${entra1_1}${entra1_2}" > microsoft_azure_entra_id_token-v1.txt
}


function entra_2 () {
   entra2_1="eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImtpZCI6IjFMVE16YWtpaGlSbGFfOHoyQkVKVlhlV01xbyJ9"
   entra2_2=".eyJ2ZXIiOiIyLjAiLCJpc3MiOiJodHRwczovL2xvZ2luLm1pY3Jvc29mdG9ubGluZS5jb20vOTEyMjA0MGQtNmM2Ny00YzViLWIxMTItMzZhMzA0YjY2ZGFkL3YyLjAiLCJzdWIiOiJBQUFBQUFBQUFBQUFBQUFBQUFBQUFJa3pxRlZyU2FTYUZIeTc4MmJidGFRIiwiYXVkIjoiNmNiMDQwMTgtYTNmNS00NmE3LWI5OTUtOTQwYzc4ZjVhZWYzIiwiZXhwIjoxNTM2MzYxNDExLCJpYXQiOjE1MzYyNzQ3MTEsIm5iZiI6MTUzNjI3NDcxMSwibmFtZSI6IkFiZSBMaW5jb2xuIiwicHJlZmVycmVkX3VzZXJuYW1lIjoiQWJlTGlAbWljcm9zb2Z0LmNvbSIsIm9pZCI6IjAwMDAwMDAwLTAwMDAtMDAwMC02NmYzLTMzMzJlY2E3ZWE4MSIsInRpZCI6IjkxMjIwNDBkLTZjNjctNGM1Yi1iMTEyLTM2YTMwNGI2NmRhZCIsIm5vbmNlIjoiMTIzNTIzIiwiYWlvIjoiRGYyVVZYTDFpeCFsTUNXTVNPSkJjRmF0emNHZnZGR2hqS3Y4cTVnMHg3MzJkUjVNQjVCaXN2R1FPN1lXQnlqZDhpUURMcSFlR2JJRGFreXA1bW5PcmNkcUhlWVNubHRlcFFtUnA2QUlaOGpZIn0.1AFWW-Ck5nROwSlltm7GzZvDwUkqvhSQpm55TQsmVo9Y59cLhRXpvB8n-55HCr9Z6G_31_UbeUkoz612I2j_Sm9FFShSDDjoaLQr54CreGIJvjtmS3EkK9a7SJBbcpL1MpUtlfygow39tFjY7EVNW9plWUvRrTgVk7lYLprvfzw-CIqw3gHC-T7IK_m_xkr08INERBtaecwhTeN4chPC4W3jdmw_lIxzC48YoQ0dB1L9-ImX98Egypfrlbm0IBL5spFzL6JDZIRRJOu8vecJvj1mq-IUhGt0MacxX8jdxYLP-KUu2d9MbNKpCKJuZ7p8gwTL5B7NlUdh_dmSviPWrw"

    echo "Commit: Entra token v2 microsoft_azure_entra_id_token source: https://learn.microsoft.com/en-us/entra/identity-platform/id-tokens#sample-v20-id-token"
    echo "${entra2_1}${entra2_2}" > microsoft_azure_entra_id_token-v2.txt
}

function gh_app_installation () { 
    gh1=ghs_
    gh2=XJWCkil21UxGYF9ZPe4Khtf2AdKOH137s09t
    echo "Commit: GitHub App Installation Access Token"
    echo export GITHUB_TOKEN=${gh1}${gh2} >github.app-installation-access-token.compromised.secret.txt
}


function firebase1 () {
  # firebase_cloud_messaging_server_key				
  # is currently (2024-11-13) the only key type in
  # https://docs.github.com/en/enterprise-cloud@latest/code-security/secret-scanning/introduction/supported-secret-scanning-patterns?learn=secret_scanning&learnProduct=code-security

  fb1="AIzaSyAHpjrqTY6c2eG"
  fb2="JExDMBLbFDa7_sXrCEgE"
  echo "Commit: Firebase cloud messaging server key?"
  echo export firebase_messaging_server_key =${fb1}${fb2} >firebase_api_key.txt

  fb3="BHEe7kXN8frjWZCCbSE3MxJgAHLgB621NB7mFFqJV"
  fb4="jpuYiK80Lb4JbsV30vXtuRszLZPxALfJja2PXgagDOxh1Y"
  echo "Commit: Firebase Messaging server public key?"
  echo export firebase_public_key=${fb3}${fb4} >firebase_messaging_server_public_key.txt

  fb5="EcUUHHTxxsSsJSR"
  fb5="_YQojRo2u-3wPyehHIzF5tadSeO0"
  echo "Commit: Firebase Messaging server private key?"
  echo export firebase_private_key =${fb5}${fb6} >firebase_messaging_server_private_key.txt

}


function aws_access_key_id () { 
    gh1=AKIARAR
    gh2=N6AUAF3VHDJQJ
    echo "Commit: AWS Access key ID"
    echo export AWS_ACCESS_KEY_ID=${gh1}${gh2} >aws-access-key-id.compromised.secret.txt
}

function aws_secret_access_key () { 
  
    gh1=YgTGNtWY0W++
    gh2=ZoDq9WfnreJ2WWscxwUksP3OlkS2
    echo "Commit: AWS Secret Access Key"
    echo export AWS_SECRET_ACCESS_KEY=${gh1}${gh2} >aws-secret-access-key.compromised.secret.txt
}

function aws_secret_access_key_id_combo () { 
    # This will trigger GitHub push protection
    
    gh1=YgTGNtWY0W++
    gh2=ZoDq8WfnreJ2WWscxwUksP3OlkS2
    echo "Commit: AWS Secret Access key"
    gh3=AKIARAR
    gh4=N6AUAF3VHDJQJ
    echo "Commit: AWS Access key ID"
    echo export AWS_ACCESS_KEY=${gh1}${gh2} >aws-secret-access-key-id-combo.compromised.secret.txt
    echo export AWS_SECRET_ACCESS_KEY=${gh3}${gh4} >>aws-secret-access-key-id-combo.compromised.secret.txt
}

function google_api_key () {
    google_api1="AIzaSyDxJB-"
    google_api2="2ocxX02LIAZiU_2_0bhhc2wDlN8g"
    echo "Commit: google_api_key"
    echo "${google_api1}${google_api2}" >google_api_key.compromised.secret.txt
}


function azure_storage () {
    azure_storage_1="e6ZZx75Z6095KHJvBZIDOD9kCLt3KjHx/"
    azure_storage_2="KKT0LWi25F+Cq0XxlpS+tbs1EqlqvRY3YgC19T5+PC6+AStjkFjyQ=="
    echo "Commit: azure_storage"
    echo "${azure_storage_1}${azure_storage_2}" >azure_storage.compromised.secret.txt
}


function npm_granular () {
    npm_g1="npm_0QWV3DXVrcBZR"
    npm_g2="srwh1ovdBWl2kjOtH0GzmRc"
    echo "Commit: npm_granular"
    echo "${npm_g1}${npm_g2}" >npm_granular.compromised.secret.txt
}


function npm_classic () {
    npm_c1="npm_Fxg6NNBNSxFDTfAQ"
    npm_c2="pWABbI87Bl6laH1Mk1dH"
    echo "Commit: npm_classic"
    echo "${npm_c1}${npm_c2}" >npm_classic.compromised.secret.txt
}

function datadog_api_key () {
    datadog_c1=ee82368550
    datadog_c2=f3cdda69f99882a4812902
    datadog_c3=f3cbee69f99881deadbeef
    datadog_c4=f3cbee69980xdeadbeef
    datadog_c5=ee8aaaaaaaa
    datadog_c6=aaaaaaaaaaaaaaaaaaaa
    echo "Commit: datadog_api_key"
    echo "DATADOG_API_KEY=${datadog_c1}${datadog_c2}" >datadog_api_key.compromised.secret.txt
    echo "${datadog_c1}${datadog_c2}" >datadog_api_key.compromised.secret-no-prefix.txt
    echo "DATADOG_API_KEY=${datadog_c1}${datadog_c3}" >datadog_api_key.compromised.secret-beef.txt
    echo "DATADOG_API_KEY=${datadog_c1}${datadog_c4}" >datadog_api_key.compromised.secret-beef-non-hex.txt
    echo "DATADOG_API_KEY=${datadog_c1}${datadog_c6}" >datadog_api_key.compromised.secret-straight-a.txt
}



case ${keyname} in 
 datadog_api_key)
     datadog_api_key
     ;;
 github_pat)
    github_pat
    ;;
 github_pat_base64)
    github_pat_base64
    ;;
 google_api_key)
    google_api_key 
    ;;
 azure_storage)
    azure_storage
    ;;
 npm_granular)
    npm_granular
    ;;
 npm_classic)
    npm_classic
    ;;
 all)
    github_pat
    github_pat_base64
    gh_app_installation
    google_api_key
    azure_storage
    npm_granular
    npm_classic
    aws_access_key_id
    aws_secret_access_key
    aws_secret_access_key_id_combo
    datadog_api_key
    firebase1
    entra_1
    entra_2
    ;;
 *)
   echo 
   echo "Please pass a name of token to compromise: [ azure_storage, github, google_api_key, npm_granular, gh_app_installation, aws_access_key_id, aws_secret_access_key, aws_secret_access_key_id_combo, datadog_api_key, firebase entra_1, entra_2, github_pat_base64 ]"
   echo 
   ;;
esac


git add *.txt
git commit -m "Adding compromised keys keys."
echo
echo press enter to push commit with secret:
echo
read x
git push
