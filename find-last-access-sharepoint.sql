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
