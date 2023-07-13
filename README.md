# TableHousekeeping  

### Table Housekeeping for LRF
---
#### 0. Project

Get the code from[https://github.com/house40105/TableHousekeeping](https://github.com/house40105/TableHousekeeping) and upload it to the target host in `/tmp` directory for installation.

```
# The following steps, with the default path set to
/tmp/TableHousekeeping/
```

#### 1. TableHousekeeping (Version 2.1 or Version 3.0)
Version 2.1 for LRF.  
version 3.0 has a feature of high versatility, enabling users to customize the table names they wish to include or exclude for the cleaning process.

* Install

```bash
unzip TableHousekeeping-main.zip
cd TableHousekeeping-main/
sh install.sh

```
* work: /home/TableHousekeeping/
* logs: /home/logs/TableHousekeeping/
* Default configuration of executing the script at 1 AM daily.
  * #trigger     : cronjob
  * #schedule    : 0 1 * * * (01:00/day)
 

>Matters needing attention:  
>* Please verify the specified log directory path in the `TableHousekeeping.ini` configuration file before deploying the new version (path: /home/logs/TableHousekeeping/).
>* Also, verify the specified config file path for `TableHousekeeping.pl` script before proceeding (path: /home/TableHousekeeping/TableHousekeeping.ini).
>* Modifying or adding sections in the `TableHousekeeping.ini` configuration file according to individual needs.  
>  Example of standard section configuration:
>  ```
>  #Version 2.1
>  
>  [NMOSS4VoWiFi_3G]              # Section name
>  TableName=NMOSS4VoWiFi_3G_BK   # Table prefix string
>  Keep_Type=DAY                  # Retention type (DAY = based on days, COUNT = based on quantity)  
>  Keep_Value=1                   # At least retention (positive integer type, automatically set to the default value if not specified)  
>  ```
>```
>  #Version 3.0
>  
>  [NMOSS4VoWiFi_4G_BK]         # Table prefix string
>  Keep_Type=DAY                # Retention type (DAY = based on days, COUNT = based on quantity)  
>  Keep_Value=10                # At least retention (positive integer type, automatically set to the default value if not specified)  
>```
