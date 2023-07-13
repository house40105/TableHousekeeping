#!/bin/bash

# 創建logs目錄
mkdir -p /home/logs/TableHousekeeping/

# 創建程式目錄
mkdir -p /home/TableHousekeeping/

# 複製到指定目錄
cp /tmp/TableHousekeeping/TableHousekeeping-main /home/TableHousekeeping/
chmod 754 /home/TableHousekeeping/TableHousekeeping.pl

# 自動設定到Crontab (判斷是否crontab已有)
if crontab -l | grep -q 'TableHousekeeping'; then
    echo "Crontab entry already exists. Skipping..."
else
    # 添加Crontab任務，這裡的範例是每天凌晨1點執行腳本
    echo "0 1 * * * /home/TableHousekeeping/TableHousekeeping.pl" | crontab -
fi
