
---

# Product Analytics Installation Guide

## Creating Docker Image

### Step 1: Export the `apps.json` File
1. Export the `apps.json` file as a base64-encoded string:
   ```bash
   export APPS_JSON_BASE64=$(base64 -w 0 /path/to/apps.json)
   ```
2. Decode the base64 string and save the output to a JSON file named `apps-test-output.json`:
   ```bash
   echo -n ${APPS_JSON_BASE64} | base64 -d > apps-test-output.json
   ```
3. Open the `apps-test-output.json` file to review and ensure the JSON content is correct.

---

### Step 2: Clone the Repository
1. Clone the `frappe_docker_prod_analytics` repository:
   ```bash
   git clone https://github.com/gsnbng/frappe_docker_prod_analytics.git
   ```
2. Navigate to the `prod_analytics` directory:
   ```bash
   cd frappe_docker_prod_analytics/prod_analytics
   ```

---

### Step 3: Build the Docker Image
Use the following command to build the Docker image:
```bash
docker build --no-cache --build-arg=FRAPPE_PATH=https://github.com/frappe/frappe \
--build-arg=FRAPPE_BRANCH=version-15 \
--build-arg=APPS_JSON_BASE64=$APPS_JSON_BASE64 \
--tag=ghcr.io/user/repo/prod_anal:x.x.x
```
**Note:** Replace `x.x.x` in the tag with the appropriate version.

---

### Step 4: Set Environment Variables
Set the `CUSTOM_IMAGE` and `CUSTOM_TAG` environment variables:
```bash
export CUSTOM_IMAGE='ghcr.io/user/repo/prod_anal'
export CUSTOM_TAG='x.x.x'
```
**Note:** Replace `x.x.x` with the appropriate version.

---

### Step 5: Start the Containers
Run the following command to start the containers:
```bash
docker compose -f pwd.yml up -d
```

---

## Updating an Existing Production Site

### Step 1: Backup the Site
1. Take a backup of the site:
   ```bash
   docker exec -it frappe_docker-backend-1 bash
   bench backup
   ```
2. Copy the backup file to the host system.

---

### Step 2: Stop and Remove Containers
1. Stop and remove the `prod_analytics` containers:
   ```bash
   docker compose down
   ```
   Make sure you are in the `prod_analytics` directory on the host system.

---

### Step 3: Remove Unnecessary Volumes
1. Identify Docker volumes used by `prod_analytics`:
   ```bash
   docker volume list
   ```
2. Remove unnecessary volumes, ensuring **`sites`**, **MariaDB**, and **Traefik** volumes are not deleted:
   ```bash
   docker rm volume {volume_name}
   ```

---

### Step 4: Recreate the Containers
Recreate the containers using `docker-compose`:
```bash
docker compose -f pwd.yml up -d
```

---

### Step 5: Verify Logs
Check the logs to ensure there are no asset-related issues:
```bash
docker logs {container_name}
```

---

### Step 6: Restore the Database (For Fresh Install Only)
If all volumes have been removed, restore the database:
```bash
bench --site prod_analytics1 restore ./sites/{SITE_NAME}/private/files/XYZ-database.sql.gz \
--with-private-files ./sites/{SITE_NAME}/private/files/XYZ-private-files.tar
```
**Note:** Only private files are restored since public files are mapped to a directory on the host system.

---

This guide provides detailed instructions for creating a Docker image and updating an existing production site for Product Analytics. Ensure you follow the steps carefully to avoid inconsistencies.

--- 

Let me know if you’d like further refinements or additional details!
    


