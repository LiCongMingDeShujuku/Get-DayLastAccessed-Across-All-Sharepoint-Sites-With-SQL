![CLEVER DATA GIT REPO](https://raw.githubusercontent.com/LiCongMingDeShujuku/git-resources/master/0-clever-data-github.png "李聪明的数据库")

# 使用SQL在所有Sharepoint站点上获取DayLastAccessed
#### Get DayLastAccessed Across All Sharepoint Sites With SQL
**发布-日期: 2018年05月11日 (评论)**

![#](images/##############?raw=true "#")

## Contents

- [中文](#中文)
- [English](#English)
- [SQL Logic](#Logic)
- [Build Info](#Build-Info)
- [Author](#Author)
- [License](#License) 


## 中文
如果你想管理繁忙的Sharepoint环境的增长，这应该会有所帮助。
有了这个，你可以在[Webs]表下找到每个Sharepoint Content数据库的[DaysLastAccessed]。

## English
Find yourself trying to manage the growth of a busy Sharepoint environment? This should help.
With this you can find the [DaysLastAccessed] under the [Webs] table for every Sharepoint Content database.


---
## Logic
```SQL
-- find the number of days last accessed across ALL content sites
--查找上次访问所有内容网站的天数
use [master];
set nocount on
 
if object_id('tempdb..#last_access_all') is not null
drop table  #last_access_all
create table    #last_access_all 
(
    [database]  varchar(255)
,   [title]     varchar(1000)
,   [site_url]  varchar(max)
,   [created_on]    datetime
,   [last_accessed] datetime
,   [days_ago]  int
)
 
declare @last_access_all    varchar(max)
set @last_access_all    = ''
select  @last_access_all    = @last_access_all + 
'use [' + [name] + '];' + char(10) + 
'select
    ''database''        = db_name()
,   ''title''       = [title]
,   ''site_url''        = [fullurl]
,   ''created_on''      = left([timecreated], 19)
,   ''last_accessed''   = left(dateadd(d, [daylastaccessed] + 65536, convert(datetime, ''1/1/1899'', 101)), 19)
,   ''days_ago''        = datediff(day, dateadd(d, [daylastaccessed] + 65536, convert(datetime, ''1/1/1899'', 101)), getdate())
from [webs] where ([daylastaccessed] <> 0) and [fullurl] like N''sites/%'' order by   [daylastaccessed] asc
'
from    sys.databases where [name] like '%content%' order by [name] asc
 
insert into #last_access_all exec (@last_access_all)
 
select * from #last_access_all
go


```

Alternatively you can check one database at a time with this..

```SQL
use [my_content_database]
set nocount on
 
-- find number of days since content site was last used
--查找自上次使用内容网站以来的天数
select
    'database'      = db_name()
,   'title'         = [title]
,   'site_url'      = [fullurl]
,   'created_on'    = left([timecreated], 19)
,   'last_accessed' = left(dateadd(d, [daylastaccessed] + 65536, convert(datetime, '1/1/1899', 101)), 19)
,   'days_ago'      = datediff(day, dateadd(d, [daylastaccessed] + 65536, convert(datetime, '1/1/1899', 101)), getdate())
from [webs] where ([daylastaccessed] <> 0) and [fullurl] like N'sites/%' order by [daylastaccessed] asc
go

```

希望可以帮到你。(Hope you find it helpful.)


[![WorksEveryTime](https://forthebadge.com/images/badges/60-percent-of-the-time-works-every-time.svg)](https://shitday.de/)

## Build-Info

| Build Quality | Build History |
|--|--|
|<table><tr><td>[![Build-Status](https://ci.appveyor.com/api/projects/status/pjxh5g91jpbh7t84?svg?style=flat-square)](#)</td></tr><tr><td>[![Coverage](https://coveralls.io/repos/github/tygerbytes/ResourceFitness/badge.svg?style=flat-square)](#)</td></tr><tr><td>[![Nuget](https://img.shields.io/nuget/v/TW.Resfit.Core.svg?style=flat-square)](#)</td></tr></table>|<table><tr><td>[![Build history](https://buildstats.info/appveyor/chart/tygerbytes/resourcefitness)](#)</td></tr></table>|

## Author

- **李聪明的数据库 Lee's Clever Data**
- **Mike的数据库宝典 Mikes Database Collection**
- **李聪明的数据库** "Lee Songming"

[![Gist](https://img.shields.io/badge/Gist-李聪明的数据库-<COLOR>.svg)](https://gist.github.com/congmingshuju)
[![Twitter](https://img.shields.io/badge/Twitter-mike的数据库宝典-<COLOR>.svg)](https://twitter.com/mikesdatawork?lang=en)
[![Wordpress](https://img.shields.io/badge/Wordpress-mike的数据库宝典-<COLOR>.svg)](https://mikesdatawork.wordpress.com/)

---
## License
[![LicenseCCSA](https://img.shields.io/badge/License-CreativeCommonsSA-<COLOR>.svg)](https://creativecommons.org/share-your-work/licensing-types-examples/)

![Lee Songming](https://raw.githubusercontent.com/LiCongMingDeShujuku/git-resources/master/1-clever-data-github.png "李聪明的数据库")

