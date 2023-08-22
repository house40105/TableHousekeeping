#!/bin/bash

# 創建logs目錄
mkdir -p /home/logs/TableHousekeeping

# 創建程式目錄
mkdir -p /home/TableHousekeeping

# 複製到指定目錄
cp /tmp/TableHousekeeping/TableHousekeeping /home/TableHousekeeping/
chmod 754 /home/TableHousekeeping/TableHousekeeping.pl


LIST=`crontab -l`
MEMO="### The Script is tableHousekeeping and syslog trogger"
SOURCE="/usr/bin/perl /home/TableHousekeeping/TableHousekeeping.pl > /dev/null"

# 自動設定到Crontab (判斷是否crontab已有)
if echo "$LIST" | grep -q "$SOURCE"; then
    echo "Crontab entry already exists. Skipping..."
else
    # 添加Crontab任務，這裡的範例是每天凌晨1點執行腳本
    crontab -l | { cat; echo "$MEMO"; } | crontab -
    crontab -l | { cat; echo "0 1 * * * $SOURCE"; } | crontab -
fi

   echo "## Crontab list ..."
   echo "======================================================="
   crontab -l
   echo "======================================================="
