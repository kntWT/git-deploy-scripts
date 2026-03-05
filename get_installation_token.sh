#!/bin/bash

set -eo pipefail

SCRIPT_DIR="$(cd "$(dirname "$(realpath "${BASH_SOURCE[0]}")")" && pwd)"

# 環境変数
PREFIX=""
if [[ -n "${GITHUB_APP_NAME:-}" ]]; then
  PREFIX="${GITHUB_APP_NAME}_"
fi

installation_id=$(cat "${SCRIPT_DIR}/${PREFIX}install_id.txt")
client_id=$(cat "${SCRIPT_DIR}/${PREFIX}app_id.txt")
pem="$(cat "${SCRIPT_DIR}/${PREFIX}private_key.pem")"

now=$(date +%s)
iat=$((now - 60)) # JWTの作成時刻は60秒前
exp=$((now + 600)) # 有効期限10分

base64url_encode() {
    openssl base64 | tr -d '=' | tr '/+' '_-' | tr -d '\n'
}

create_header() {
    local header_json='{
        "typ": "JWT",
        "alg": "RS256"
    }'

    echo -n "$header_json" | base64url_encode
}

create_payload() {
    local payload_json="{
        \"iat\": ${iat},
        \"exp\": ${exp},
        \"iss\": \"${client_id}\"
    }"

    echo -n "$payload_json" | base64url_encode
}

sign_payload_with_key() {
    local header_payload="$1"
    echo -n "$header_payload" | openssl dgst -sha256 -sign <(echo -n "$pem") | base64url_encode
}

get_github_token() {
    local jwt="$1"
    response=$(curl --request POST \
        --url "https://api.github.com/app/installations/${installation_id}/access_tokens" \
        --header "Accept: application/vnd.github+json" \
        --header "Authorization: Bearer ${jwt}" \
        --header "X-GitHub-Api-Version: 2022-11-28" \
        --silent)

    echo "${response}"
}

header=$(create_header)
payload=$(create_payload)
signature=$(sign_payload_with_key "${header}.${payload}")
jwt="${header}.${payload}.${signature}"

response=$(get_github_token "${jwt}")
token=$(echo "${response}" | grep -o '"token"[[:space:]]*:[[:space:]]*"[^"]*"' | head -n 1 | cut -d'"' -f4)

echo $token
