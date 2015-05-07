--first, we'll make the format of the date in weather the same as in the crime table so we 
--can join on them
CREATE TABLE dailyWeatherAverage(
  date string,
  averageTemp double
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n'
location 's3://hdptstbkt-0/input/weather_daily_average/';

--create semif​inal table with certain fields of interest
CREATE EXTERNAL TABLE dailyWeatherAverageCorrectDateFormat2(
  date string, 
  averageTemp double
  ) 
stored as TEXTFILE
location 's3://hdptstbkt-0/intput/weather_daily_average_correct_date_format2/';

INSERT INTO TABLE dailyWeatherAverageCorrectDateFormat2
  SELECT 
   to_date(from_unixtime(unix_timestamp(date, 'yyyyMMdd'))), 
   averageTemp
  FROM dailyWeatherAverage;


-- second we'll load the data we'd like to analyize
-- numberOfRows will is a variable defined at the command line
CREATE TABLE crimeCounts20DayMAVG(
  date string, 
  violentCrime double, 
  propertyCrime double, 
  miscCrime double,
  allCrime double
) 
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n'
location 's3://hdptstbkt-0/input/crime_daily_average/crime10MAVG/';

CREATE EXTERNAL TABLE crimeWeatherAndCounts10DayMAVG(
  date string,
  averageTemp double, 
  violentCrime double, 
  propertyCrime double, 
  miscCrime double,
  allCrime double
) 
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n'
location 's3://hdptstbkt-0/input/crime_and_weather_avg/crime10MVAVGandWeather';

INSERT INTO TABLE crimeWeatherAndCounts10DayMAVG
  SELECT
   t1.date, 
   t1.averageTemp,
   t2.violentCrime, 
   t2.propertyCrime, 
   t2.miscCrime, 
   t2.allCrime
  FROM dailyweatheraveragecorrectdateformat2 t1, crimeCounts20DayMAVG t2
  WHERE t1.date = t2.date;

--now we'll load the rolling average days and do the same
CREATE TABLE weather10dayMAVG(
  date string,
  averageTemp double
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n'
location 's3://hdptstbkt-0/input/weather_10MAVG';

CREATE EXTERNAL TABLE weather10DayMAVGAndCrimeCounts10DayMAVG(
  date string,
  averageTemp double, 
  violentCrime double, 
  propertyCrime double, 
  miscCrime double,
  allCrime double
) 
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n'
location 's3://hdptstbkt-0/input/crime_and_weather_avg/crime10MVAVGandWeather10MAVG';

INSERT INTO TABLE weather10DayMAVGAndCrimeCounts10DayMAVG
  SELECT
   t1.date, 
   t1.averageTemp,
   t2.violentCrime, 
   t2.propertyCrime, 
   t2.miscCrime, 
   t2.allCrime
  FROM weather10dayMAVG t1, crimeCounts20DayMAVG t2
  WHERE t1.date = t2.date;
