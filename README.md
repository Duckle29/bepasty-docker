# bepasty-docker

Docker automated build repository for the [bepasty server](https://github.com/bepasty/bepasty-server)

## Usage

When running this image, make sure to specify all the environement varibles used for the config. Look up the config values on http://bepasty-server.readthedocs.org/en/latest/quickstart.html#configuring-bepasty

The ones currently implemented in this image:  
`STORAGE_FILESYSTEM_DIRECTORY`  
`SITENAME`  
`UPLOAD_LOCKED`  
`MAX_ALLOWED_FILE_SIZE`  
`MAX_BODY_SIZE`  
`STORAGE`  
`SECRET_KEY`  
`SESSION_COOKIE_SECURE`  
`PERMANENT_SESSION`  
`PERMANENT_SESSION_LIFETIME`  
`DEFAULT_PERMISSIONS`  
`PERMISSIONS`  

If new settings aren't availabe in the image you can use `SETTINGS_EXTRA` to insert whatever you want at the end of the config


For example:
```
docker run -d --restart=unless-stopped --name bepasty -p 5000:5000 -v /opt/bepasty:/srv/bepasty \
    -e "STORAGE_FILESYSTEM_DIRECTORY='/srv/bepasty/storage'" \
    -e "SITENAME='paste.example.com'" \
    -e "UPLOAD_LOCKED=False" \
    -e "MAX_ALLOWED_FILE_SIZE=5 * 1000 * 1000 * 1000" \
    -e "MAX_BODY_SIZE=1 * 1024 * 1024" \
    -e "STORAGE='filesystem'" \
    -e "SECRET_KEY='SUPER_SECRET_SUPER_RANDOM_SUPER_LONG_KEY'" \
    -e "SESSION_COOKIE_SECURE=True" \
    -e "PERMANENT_SESSION=False" \
    -e "PERMANENT_SESSION_LIFETIME=31 * 24 * 3600" \
    -e "DEFAULT_PERMISSIONS=''" \
    -e "PERMISSIONS={'secret_admin_pass' : 'admin,list,create,read,delete'}" \
    duckle/bepasty
```