#!/bin/bash

set -eu -o pipefail

# Add Passwordが選ばれたときに行う処理
function ask_passwd () {
    local servie_name
    while true ; do
        read -p "サービス名を入力してください：" service_name
        if [ "$service_name" != "" ] ; then
            break
        fi
    done
    read -p "ユーザー名を入力してください：" user_name
    read -p "パスワードを入力してください：" password

    echo "Thank you!"
    echo $service_name":"$user_name":"$password >> ./save_location
}

# Get Passwordが選ばれたときに行う処理
function provide_password () {
    local service_name
    while true ; do
        read -p "サービス名を入力してください:" service_name
        if [ "$service_name" != "" ] ; then
            break
        fi
    done
    local target=`grep "$service_name" ./save_location`
    if [ "$target" == "" ] ; then
        echo "そのサービス名は登録されていません"
    else
        echo "サービス名："${target%%:*}
        target=${target#*:}
        echo "ユーザー名："${target%%:*}
        echo "パスワード："${target##*:}
    fi
}

# このスクリプトの全体の流れを制御する
echo パスワードマネージャーへようこそ！

while true ; do
    echo "次の選択肢から入力してください(Add Password/Get Password/Exit)："
    while true ; do
        read choice
        if [ "$choice" == "Add Password" ] ; then
            ask_passwd
            break
        elif [ "$choice" == "Get Password" ] ; then
            provide_password
            break
        elif [ "$choice" == "Exit" ] ; then
            echo "Thank you!"
            exit 0
        else
            echo "入力が間違えています。Add Password/Get Password/Exit から入力してください。"
        fi
    done
done