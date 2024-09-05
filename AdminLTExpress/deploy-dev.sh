APP_DIR=/data/CMS-CR/AdminLTExpress
TARGET_HOST=cr-dev

rsync -avz ./routes root@$TARGET_HOST:$APP_DIR
rsync -avz ./database root@$TARGET_HOST:$APP_DIR
rsync -avz ./views root@$TARGET_HOST:$APP_DIR
rsync -avz ./app.js root@$TARGET_HOST:$APP_DIR
rsync -avz ./package.json root@$TARGET_HOST:$APP_DIR
