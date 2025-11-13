# WIKI
Instructions to setup an internal wiki


## A new install
- Clone the entire repo.
- Edit variables in conf/primary.env
- Dont commit and push any changes.

Run `
docker compose -f docker-compose.yaml -p wiki up -d
`

- Load environment variables
`
source ./conf/primary.env
`

- Run the installer, making sure you substitue the --pass below with whatever the password is in your conf/primary.env file
```

docker exec -it wiki_app php /var/www/html/maintenance/install.php \
  --dbname=${MYSQL_DATABASE} \
  --dbserver=${WIKI_DB_SERVICE_NAME} \
  --dbuser=${MYSQL_USER} \
  --dbpass=${MYSQL_PASSWORD} \
  --server="https://${APACHE_HOSTNAME}" \
  --scriptpath="/${WIKI_PATH}" \
  --pass=somecomplexadminpassword \
  "${WIKI_NAME}" \
  "AdminUser"

```

- Shutdown 
```
docker compose -f docker-compose.yaml -p wiki down
```

- edit `docker-compose.yaml` and uncomment the line 
`#- ./conf/wiki/LocalSettings.php:/var/www/html/LocalSettings.php`

- Start the containers
```
docker compose -f docker-compose.yaml -p wiki up -d
```

Open a browser and navigate to `https://<your host>`

Open the wiki link page and login with the username "AdminUser" and the password from WIKI_ADMIN_USER_PASSWORD which is in the conf/primary.env file

Try uploading an image and file to the wiki. If you get permission issues you may need something like:
```
sudo chmod -R 777 data/media_wiki/images/
sudo chmod -R 777 data/media_wiki/uploads/
```

## Backup
It should simply be a case of backing up the entire folder.
