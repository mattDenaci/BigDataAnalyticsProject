//Weather 10 Moving Average

create external table weatherTemp(date string, temperature decimal(25,20)) row format delimited fields terminated by ',' location '/user/cloudera/WeatherInput';

create external table weatherDateFormat(date string, temperature decimal(25,20)) row format delimited fields terminated by ',' stored as TEXTFILE location '/user/cloudera/WeatherOutput';

insert into table weatherDateFormat select to_date(from_unixtime(unix_timestamp(date,'yyyyMMdd'))), temperature from weatherTemp;

create external table weatherTenMAVG(date date, tempTenMAVG decimal (25,20)) row format delimited fields terminated by ',' stored as TEXTFILE location '/user/cloudera/WeatherTenMAVG';

insert into table weatherTenMAVG select t2.date, sum(t1.temperature)/10 as tempTenMAVG from (select date from weatherDateFormat) as t2, (select date, temperature from weatherDateFormat) as t1 where datediff(t2.date, t1.date) between 0 and 9 group by t2.date;