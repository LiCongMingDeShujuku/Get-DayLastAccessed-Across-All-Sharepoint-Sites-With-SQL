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
