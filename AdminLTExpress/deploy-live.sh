APP_DIR=/data/nodejs/CMS-CR/AdminLTExpress

rsync -avz ./routes root@cr-app1:$APP_DIR
rsync -avz ./database root@cr-app1:$APP_DIR
rsync -avz ./views root@cr-app1:$APP_DIR
rsync -avz ./app.js root@cr-app1:$APP_DIR
rsync -avz ./package.json root@cr-app1:$APP_DIR

rsync -avz ./routes root@cr-app2:$APP_DIR
rsync -avz ./database root@cr-app2:$APP_DIR
rsync -avz ./views root@cr-app2:$APP_DIR
rsync -avz ./app.js root@cr-app2:$APP_DIR
rsync -avz ./package.json root@cr-app2:$APP_DIR
