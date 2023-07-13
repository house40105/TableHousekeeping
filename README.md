# TableHousekeeping  

### Table Housekeeping for LRF
---
#### 0. Project

從 [https://github.com/house40105/TableHousekeeping](https://github.com/house40105/TableHousekeeping) 取得程式碼, 上傳要安裝的主機 `/tmp`

```
# 以下步驟, 預設路徑為
/tmp/TableHousekeeping/
```

#### 1. TableHousekeeping (Version 2.1 or Version 3.0)
Version 2.1 for LRF  
Version 3.0 通用性高 (可自行增減想進行清理的table name)  

* Install

```bash
unzip TableHousekeeping-main.zip
cd TableHousekeeping-main/
sh install.sh

```
* work: /home/TableHousekeeping/
* logs: /home/logs/TableHousekeeping/
* 預設是每天凌晨1點執行腳本
  * #trigger     : cronjob
  * #schedule    : 0 1 * * * (01:00/day)
 

>注意事項  
>* 上版前記得確認`TableHousekeeping.ini`的 log_dir路徑是否正確 (路徑: /home/logs/TableHousekeeping/)
>* 以及 `TableHousekeeping.pl`的 configfile路徑 (路徑: /home/TableHousekeeping/TableHousekeeping.ini)
>* 依自行的需求來設定或增減`TableHousekeeping.ini`裡的sections  
>  標準section設定範例:
>  ```
>  #Version 2.1
>  
>  [NMOSS4VoWiFi_3G]              # section name
>  TableName=NMOSS4VoWiFi_3G_BK   # Table前輟字串
>  Keep_Type=DAY                  # 保留型態  (DAY = 依天數 , COUNT = 依數量 )  
>  Keep_Value=1                   # 至少保留參數  (正整數型態,如果不是 將自動設定為預設值 )  
>  ```
>```
>  #Version 3.0
>  
>  [NMOSS4VoWiFi_4G_BK]         # Table前輟字串
>  Keep_Type=DAY                # 保留型態  (DAY = 依天數 , COUNT = 依數量 )  
>  Keep_Value=10                # 至少保留參數  (正整數型態,如果不是 將自動設定為預設值 )  
>```
