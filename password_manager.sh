#!/bin/bash

set -eu -o pipefail

echo パスワードマネージャーへようこそ！

while true ; do
    read -p "サービス名を入力してください:" service_name
    if [ "$service_name" != "" ] ; then
        break
    fi
done
read -p "ユーザー名を入力してください:" user_name
read -p "パスワードを入力してください:" password

echo "Thank you!"
echo $service_name":"$user_name":"$password >> ./save_location
