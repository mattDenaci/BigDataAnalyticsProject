CREATE EXTERNAL TABLE trafficDailyAverage(
  date string,
  averageTraffic int
) 
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n'
location 's3://hdptstbkt-0/input/traffic_daily_average';

CREATE EXTERNAL TABLE trafficWeatherAndCrimeCorrelations(
  trafficTempCorr double,
  trafficAllCrimeCorr double,
  trafficViolentCrimeCorr double,
  trafficPropertyCrimeCorr double,
  trafficMisCrimeCorr double
)ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n'
location 's3://hdptstbkt-0/results/traffic_correlations';

INSERT INTO TABLE trafficWeatherAndCrimeCorrelations
  SELECT
   corr(t3.averageTraffic,t1.averageTemp),
   corr(t3.averageTraffic, t2.allCrime),
   corr(t3.averageTraffic,t2.violentCrime),
   corr(t3.averageTraffic,t2.propertyCrime),
   corr(t3.averageTraffic, t2.miscCrime)
  FROM weather10dayMAVG t1, crimeCounts20DayMAVG t2, trafficDailyAverage t3
  WHERE t1.date = t3.date and t2.date = t3.date;