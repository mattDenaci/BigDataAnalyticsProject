create external table crimeTemp(id bigint, caseNumber string, date string, block string, iucr string, primaryType string, description string,
locationDescription string, arrest boolean, domestic boolean, beat string, district string, ward string, communityArea string, FBICode string,
XCoord int, YCoord int, year int, updated string, latitude double, longitude double, location string)
row format delimited fields terminated by ','
location '/user/cloudera/chicagoCrime';

--create semif​inal table with certain fields of interest
create external table crimeFinal(date timestamp, primaryType string, description string, latitude double, longitude double) stored as TEXTFILE;

--load data pertaining to fields of interest into semif​inal table.
--Cast date into timestamp datatype using built in Hive date functions.
insert into table crimeFinal select
from_unixtime(unix_timestamp(date, 'MM/dd/yyyy hh:mm:ss aa')), primaryType, description, latitude, longitude
from crimeTemp;