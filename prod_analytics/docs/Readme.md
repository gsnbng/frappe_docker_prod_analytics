Product Analytics Installation process:

Creating Docker Image:

Export the apps.josn file:
export APPS_JSON_BASE64=$(base64 -w 0 /path/to/apps.json)

Use the following command to decode and save the output into a JSON file named apps-test-output.json:
echo -n ${APPS_JSON_BASE64} | base64 -d > apps-test-output.json

Open the apps-test-output.json file to review the JSON output and ensure that the content is correct.



Clone frappe_docker and switch directory
git clone https://github.com/gsnbng/frappe_docker_prod_analytics.git

cd frappe_docker_prod_analytics/prod_analytics

docker build --no-cache --build-arg=FRAPPE_PATH=https://github.com/frappe/frappe --build-arg=FRAPPE_BRANCH=version-15 --build-arg=APPS_JSON_BASE64=$APPS_JSON_BASE64 --tag=ghcr.io/user/repo/prod_anal:x.x.x --file=Containerfile .

NOTE: Replace x.x.x in tag to appropriate control no.

export CUSTOM_IMAGE='ghcr.io/user/repo/prod_anal'

export CUSTOM_TAG='x.x.x'
NOTE: Replace x.x.x in tag to appropriate control no.


docker compose -f pwd.yml up -d

----------------------------------------------------------------------------------
Updating the existing production site:

1. Take backup of the site :
     docker exec -it frappe_docker-backend-1 bash
     bench backup
   
2. Copy the backup file into host system
3. Stop and remove the prod_analytics containers
      Change directory to prod_analytics in the host syste,
      docker compose down

4. Identify the Docker volumes used by Prod_analytics.
      docker volume list
5. Remove unnecessary volumes, ensuring that sites, MariaDB, and Traefik are not deleted.
      docker rm volume {volume_name}
6. Recreate the containers with docker-compose.
      docker compose -f pwd.yml up -d
7. Check the logs to ensure there are no asset-related issues.

8. Restore the database (for fresh install only if all volumes have been removed):
       bench --site prod_analytics1 restore ./sites/{SITE_NAME}/private/files/XYZ-database.sql.gz --with-private-files ./sites/{SITE_NAME}/private/files/XYZ-private-files.tar

      NOTE: Only private files are restored since the public files are mapped to the directory in host system
      
  
      
    


