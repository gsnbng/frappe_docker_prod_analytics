#!/bin/bash
nano apps.json
export APPS_JSON_BASE64=$(base64 -w 0 apps.json)
echo -n ${APPS_JSON_BASE64} | base64 -d > apps-test-output.json
nano apps-test-output.json
docker build --no-cache --build-arg=FRAPPE_PATH=https://github.com/frappe/frappe --build-arg=FRAPPE_BRANCH=version-15 --build-arg=APPS_JSON_BASE64=$APPS_JSON_BASE64 --tag=ghcr.io/user/repo/lims:0.0.2  --progress=plain --no-cache .
export CUSTOM_IMAGE='ghcr.io/user/repo/lims'
export CUSTOM_TAG='0.0.2'
export SITE_NAME2='lims1'
docker compose -f pwd.yml down
docker compose -f pwd.yml up -d
docker exec -it lims-backend-1 bash
