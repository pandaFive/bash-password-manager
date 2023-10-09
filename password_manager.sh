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
    # サービス名を取得する
    while true ; do
        read -p "サービス名を入力してください:" service_name
        if [ "$service_name" != "" ] ; then
            break
        fi
    done

    local target=`grep "$service_name" ./save_location`
    target=$(echo "$target" | awk -F':' -v service_name="$service_name" '$1 == service_name')
    echo "てすと""$target"
    local hitNumber=$(echo "$target" | grep -c "$service_name")

    # hitした登録情報の数によって処理を分ける。2つ以上hitした場合はユーザー名でさらに条件を絞る。
    if [ "$hitNumber" -eq 0 ] ; then
        echo "そのサービス名は登録されていません"
    # 1つ以上の登録があった場合
    else
        # 2つ以上の登録があった場合さらに条件を絞る
        if [ "$hitNumber" -gt 1 ] ; then
            # hitした登録のユーザー名を取得する
            local acounts=$(echo "$target" | awk -F':' '{print $2}')
            local acount_name
            local target_line

            echo "そのサービス名は複数登録されています。下記の中からユーザー名を入力してください。"
            while true ; do
                echo "$acounts"
                read -p "：" acount_name
                target_line=$(echo "$target" | awk -F':' -v acount_name="$acount_name" '$2 == acount_name')

                if [ "$target_line" != "" ] ; then
                    target="$target_line"
                    break
                else
                    echo "入力が間違っています。下記の中からユーザー名を入力してください。"
                fi
            done
        fi
        echo "サービス名："${target%%:*}
        echo "ユーザー名："$(echo "$target" | awk -F':' '{print $2}')
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