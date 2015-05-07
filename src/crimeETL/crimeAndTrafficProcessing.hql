--Filter crime data into (date, primaryType, longitude, latitude)

create external table crimeTemp(id bigint, caseNumber string, date string, block string, iucr string, primaryType string, description string, locationDescription string, arrest boolean, domestic boolean, beat string, district string, ward string, communityArea string, FBICode string, XCoord int, YCoord int, year int, updated string, latitude double, longitude double, location string) row format delimited fields terminated by ',' location '/user/cloudera/CrimeInput';

create external table crimeFiltered(date string, primaryType string, latitude double, longitude double) row format delimited fields terminated by ',' stored as TEXTFILE location '/user/cloudera/crimeOutput';

insert into table crimeFiltered select to_date(from_unixtime(unix_timestamp(date,'MM/dd/yyyy'))), primaryType, latitude, longitude from crimeTemp;

--Daily Count of Crime Types by Type (Violent, Property, Misc)

create external table crimeCounted(date string, violentCount bigint, propertyCount bigint, miscCount bigint, totalCount bigint) row format delimited fields terminated by ',' stored as TEXTFILE location '/user/cloudera/CrimeCount'


insert into table crimeCounted select date, sum(if(primaryType == "ASSAULT" OR primaryType == "BATTERY" OR primaryType == "CRIM SEXUAL ASSAULT" OR primaryType == "DOMESTIC VIOLENCE" OR primaryType == "HOMICIDE", 1, 0)), sum(if(primaryType == "ARSON" OR primaryType == "BURGLARY" OR primaryType == "CRIMINAL DAMAGE" OR primaryType == "MOTOR VEHICLE THEFT" OR primaryType == "ROBBERY" OR primaryType == "THEFT", 1, 0)), sum(if(primaryType =="CONCEALED CARRY LICENSE VIOLATION" OR primaryType == "CRIMINAL TRESPASS" OR primaryType == "DECEPTIVE PRACTICE" OR primaryType == "GAMBLING" OR primaryType == "HUMAN TRAFFICKING" OR primaryType == "INTERFERENCE WITH PUBLIC OFFICER" OR primaryType == "INTIMIDATION" OR primaryType == "KIDNAPPING" OR primaryType == "LIQUOR LAW VIOLATION" OR primaryType == "NARCOTICS" OR primaryType == "NON - CRIMINAL" OR primaryType == "NON-CRIMINAL" OR primaryType == "NON-CRIMINAL (SUBJECT SPECIFIED)" OR primaryType == "OBSCENITY" OR primaryType == "OFFENSE INVOLVING CHILDREN" OR primaryType == "OTHER NARCOTIC VIOLATION" OR primaryType == "OTHER OFFENSE" OR primaryType == "PROSTITUTION" OR primaryType == "PUBLIC INDECENCY" OR primaryType == "PUBLIC PEACE VIOLATION" OR primaryType == "RITUALISM" OR primaryType == "SEX OFFENSE" OR primaryType == "STALKING" OR primaryType == "WEAPONS VIOLATION", 1, 0)), count(*) from crimeTimeFiltered GROUP BY date;


--Crime 10 Moving Average

create external table crimecounttemp(date date, violentCount bigint, propertyCount bigint, miscCount bigint, totalCount bigint) row format delimited fields terminated by ',' location '/user/cloudera/CrimeCount';

create external table crimeTenMAVG(date date, violentTenMAVG bigint, propertyTenMAVG bigint, miscTenMAVG bigint, totalTenMAVG bigint) row format delimited fields terminated by ',' stored as TEXTFILE location '/user/cloudera/CrimeTenMAVG';

insert into table crimeTenMAVG select t2.date, round(sum(t1.violentCount)/10) as violentTenMAVG, round(sum(t1.propertyCount)/10) as propertyTenMAVG, round(sum(t1.miscCount)/10) as miscTenMAVG, round(sum(t1.totalCount)/10) as miscTenMAVG from (select date from crimecounttemp) as t2, (select date, violentCount, propertyCount, miscCount, totalCount from crimecounttemp) as t1 where datediff(t2.date, t1.date) between 0 and 9 group by t2.date;

--Crime 20 Moving Average

create external table crimeTwentyMAVG(date date, violentTenMAVG bigint, propertyTenMAVG bigint, miscTenMAVG bigint, totalTenMAVG bigint) row format delimited fields terminated by ',' stored as TEXTFILE location '/user/cloudera/CrimeTwentyMAVG';

insert into table crimeTwentyMAVG select t2.date, round(sum(t1.violentCount)/20) as violentTenMAVG, round(sum(t1.propertyCount)/20) as propertyTenMAVG, round(sum(t1.miscCount)/20) as miscTenMAVG, round(sum(t1.totalCount)/20) as miscTenMAVG from (select date from crimecounttemp) as t2, (select date, violentCount, propertyCount, miscCount, totalCount from crimecounttemp) as t1 where datediff(t2.date, t1.date) between 0 and 19 group by t2.date;



--Traffic Volume Daily Average

create external table trafficTemp(date string, volume bigint, id string, longitude string, latitude string) row format delimited fields terminated by ',' location '/user/cloudera/TrafficInput';

create external table trafficDailyAverage(date string, averageVolume bigint) row format delimited fields terminated by ',' stored as TEXTFILE location '/user/cloudera/TrafficDailyAverage';

insert into table trafficDailyAverage select date, avg(volume) from trafficTemp group by date;
