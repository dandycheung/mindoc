#!/bin/bash

set -x

app=mindoc
prefix=/srv/app
target="$prefix/$app"

mkdir -p "$target/conf"
if [ ! -d "$target/conf" ]; then
  echo Create app folder failed, please check your permissions.
  exit
fi

echo Beginning...
echo Step 1/2...

# dirs: lib, runtime, static, uploads

cp -r lib static views "$target"
cp conf/app.* "$target/conf"

if [ ! -d "$target/runtime" ]; then
  mkdir "$target/runtime"
fi

if [ ! -d "$target/uploads" ]; then
  mkdir "$target/uploads"
fi

echo Step 2/2...

# files: favicon.ico, mindoc, simsun.ttc, start.sh

cp favicon.ico mindoc simsun.ttc start.sh "$target"

echo Please edit your own conf/app.conf file and make sure the database is ready.
echo Finished. Enjoy!

