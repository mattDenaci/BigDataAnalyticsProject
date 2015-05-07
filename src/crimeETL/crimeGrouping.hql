CREATE TABLE cleanedCrimeData(
  date String, 
  type String, 
  latitude DOUBLE, 
  longitude DOUBLE) 
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n'
LOCATION 's3://hdptstbkt-0/input/cleaned_crime_data';

CREATE EXTERNAL TABLE dailyCrimeCounts(
  date int, 
  count int)
row format delimited fields terminated by ','  
stored as textfile
location 's3://hdptstbkt-0/daily_crime_counts';


INSERT OVERWRITE TABLE dailyCrimeCounts
  select date, count(date)
  from cleanedCrimeData 
  group by date;

CREATE EXTERNAL TABLE violentCrimeCounts(
  date int, 
  count int)
row format delimited fields terminated by ','  
stored as textfile
location 's3://hdptstbkt-0/violent_crime_counts';

INSERT OVERWRITE TABLE violentCrimeCounts
  select date, count(date)
  from cleanedCrimeData 
  where ltrim(type) = "Sex Offense" or ltrim(type) = "Kidnapping" or ltrim(type) = "Crim Sexual Assault" 
    or ltrim(type) = "Arson" or ltrim(type) = "Assault" or ltrim(type) = "battery"
  group by date;

CREATE EXTERNAL TABLE violentCrimeCounts(
  date int, 
  count int)
row format delimited fields terminated by ','  
stored as textfile
location 's3://hdptstbkt-0/violent_crime_counts';

CREATE EXTERNAL TABLE propertyCrimeCounts(
  date int
  count int)
  from cleanedCrimeData
  where ltrim(type) = "Burglary" or ltrim(type) = "Arson" or ltrim(type) = "Assault" 
    or ltrim(type) = "Motor Vehicle Theft" or ltrim(type) = "Larceny"
  group by date;



