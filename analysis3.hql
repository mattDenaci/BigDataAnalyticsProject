-- first we'll add the python script, that we'll use to create graphs 
-- of the via matplotlib when we are all finished
add file graphMaker.py

CREATE EXTERNAL TABLE weather10DayMAVGAndCrimeCounts10DayMAVGAbove60Degrees(
  date string,
  averageTemp double, 
  violentCrime double, 
  propertyCrime double, 
  miscCrime double,
  allCrime double
) 
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n'
location 's3://hdptstbkt-0/input/crime_and_weather_avg/10MoveAVGAbove60Degrees';

INSERT INTO TABLE weather10DayMAVGAndCrimeCounts10DayMAVGAbove60Degrees
  SELECT * 
  FROM weather10DayMAVGAndCrimeCounts10DayMAVG
  WHERE averageTemp > 15.5;

CREATE EXTERNAL TABLE resultsWeather10dayMVGAbove60Degrees(
  crimeGroup string,
  linearr double,
  linearrSquared double,
  quadraticr double,
  quadraticrSquared double, 
  linearCorrelationCoEfficient double,
  linearIntercept double,
  quadraticCorrelationCoefficient double,
  quadraticCorrelationIntercept double
)
row format delimited fields terminated by ','  
stored as textfile
location 's3://hdptstbkt-0/results/10MoveAVGAbove60DegreesResults';

set numberOfRows = select count(*) from resultsWeather10dayMVGAbove60Degrees;

-- calulculate the regressions and correlation coefficients
-- first for all crimes
INSERT INTO TABLE resultsWeather10dayMVGAbove60Degrees
  SELECT 
    "all crimes",
    corr(averageTemp, allCrime), 
    pow(corr(averageTemp, allCrime), 2), 
    corr(averageTemp, sqrt(allCrime)), 
    pow(corr(averageTemp, sqrt(allCrime)), 2), 
    ((sum(allCrime)*sum(power(averageTemp,2))) - (sum(averageTemp)*sum(averageTemp*allCrime)))/(1835*sum(power(averageTemp, 2)) - power(sum(averageTemp),2)),
    (1835*sum(averageTemp*allCrime) - (sum(averageTemp)*sum(allCrime)))/(1835*sum(power(averageTemp, 2)) - power(sum(averageTemp),2)),
    ((sum(sqrt(allCrime))*sum(power(averageTemp,2))) - (sum(averageTemp)*sum(averageTemp*sqrt(allCrime))))/(1835*sum(power(averageTemp, 2)) - power(sum(averageTemp),2)),
    (1835*sum(averageTemp*sqrt(allCrime)) - (sum(averageTemp)*sum(sqrt(allCrime))))/(1835*sum(power(averageTemp, 2)) - power(sum(averageTemp),2))
  FROM weather10DayMAVGAndCrimeCounts10DayMAVGAbove60Degrees;

-- now for only violent crimes
INSERT INTO TABLE resultsWeather10dayMVGAbove60Degrees
  SELECT 
    "violent crimes",
    corr(averageTemp, violentCrime), 
    pow(corr(averageTemp, violentCrime), 2), 
    corr(averageTemp, sqrt(violentCrime)), 
    pow(corr(averageTemp, sqrt(violentCrime)), 2), 
    ((sum(violentCrime)*sum(power(averageTemp,2))) - (sum(averageTemp)*sum(averageTemp*violentCrime)))/(1835*sum(power(averageTemp, 2)) - power(sum(averageTemp),2)),
    (1835*sum(averageTemp*violentCrime) - (sum(averageTemp)*sum(violentCrime)))/(1835*sum(power(averageTemp, 2)) - power(sum(averageTemp),2)),
    ((sum(sqrt(violentCrime))*sum(power(averageTemp,2))) - (sum(averageTemp)*sum(averageTemp*sqrt(violentCrime))))/(1835*sum(power(averageTemp, 2)) - power(sum(averageTemp),2)),
    (1835*sum(averageTemp*sqrt(violentCrime)) - (sum(averageTemp)*sum(sqrt(violentCrime))))/(1835*sum(power(averageTemp, 2)) - power(sum(averageTemp),2))
  FROM weather10DayMAVGAndCrimeCounts10DayMAVGAbove60Degrees;

-- now for property crimes
INSERT INTO TABLE resultsWeather10dayMVGAbove60Degrees
  SELECT 
    "property crimes",
    corr(averageTemp, propertyCrime), 
    pow(corr(averageTemp, propertyCrime), 2), 
    corr(averageTemp, sqrt(propertyCrime)), 
    pow(corr(averageTemp, sqrt(propertyCrime)), 2), 
    ((sum(propertyCrime)*sum(power(averageTemp,2))) - (sum(averageTemp)*sum(averageTemp*propertyCrime)))/(1835*sum(power(averageTemp, 2)) - power(sum(averageTemp),2)),
    (1835*sum(averageTemp*propertyCrime) - (sum(averageTemp)*sum(propertyCrime)))/(1835*sum(power(averageTemp, 2)) - power(sum(averageTemp),2)),
    ((sum(sqrt(propertyCrime))*sum(power(averageTemp,2))) - (sum(averageTemp)*sum(averageTemp*sqrt(propertyCrime))))/(1835*sum(power(averageTemp, 2)) - power(sum(averageTemp),2)),
    (1835*sum(averageTemp*sqrt(propertyCrime)) - (sum(averageTemp)*sum(sqrt(propertyCrime))))/(1835*sum(power(averageTemp, 2)) - power(sum(averageTemp),2))
  FROM weather10DayMAVGAndCrimeCounts10DayMAVGAbove60Degrees;

--finally for misc crimes
INSERT INTO TABLE resultsWeather10dayMVGAbove60Degrees
  SELECT 
    "misc crimes",
    corr(averageTemp, miscCrime), 
    pow(corr(averageTemp, miscCrime), 2), 
    corr(averageTemp, sqrt(miscCrime)), 
    pow(corr(averageTemp, sqrt(miscCrime)), 2), 
    ((sum(miscCrime)*sum(power(averageTemp,2))) - (sum(averageTemp)*sum(averageTemp*miscCrime)))/(1835*sum(power(averageTemp, 2)) - power(sum(averageTemp),2)),
    (1835*sum(averageTemp*miscCrime) - (sum(averageTemp)*sum(miscCrime)))/(1835*sum(power(averageTemp, 2)) - power(sum(averageTemp),2)),
    ((sum(sqrt(miscCrime))*sum(power(averageTemp,2))) - (sum(averageTemp)*sum(averageTemp*sqrt(miscCrime))))/(1835*sum(power(averageTemp, 2)) - power(sum(averageTemp),2)),
    (1835*sum(averageTemp*sqrt(miscCrime)) - (sum(averageTemp)*sum(sqrt(miscCrime))))/(1835*sum(power(averageTemp, 2)) - power(sum(averageTemp),2))
  FROM weather10DayMAVGAndCrimeCounts10DayMAVGAbove60Degrees;

--Now we'll calculate the tScores

CREATE EXTERNAL TABLE 10MoveAVGAbove60DegreesResultsFinal(
  crimeGroup string,
  linearr double,
  linearrSquared double,
  quadraticr double,
  quadraticrSquared double,
  linearCorrelationCoEfficient double,
  linearIntercept double,
  quadraticCorrelationCoefficient double,
  quadraticCorrelationIntercept double,
  linearTScore double,
  quadraticTScore double
)
row format delimited fields terminated by ','  
stored as textfile
location 's3://hdptstbkt-0/results/10MoveAVGAbove60DegreesResultsFinal';

INSERT INTO TABLE 10MoveAVGAbove60DegreesResultsFinal
  SELECT 
   crimeGroup,
   linearr,
   linearrSquared,
   quadraticr,
   quadraticrSquared, 
   linearCorrelationCoEfficient,
   linearIntercept,
   quadraticCorrelationCoefficient,
   quadraticCorrelationIntercept,
   (linearr*sqrt(1835-2))/sqrt(1-linearrSquared),
   (quadraticr*sqrt(1835-2))/sqrt(1-quadraticrSquared)
  FROM resultsWeather10dayMVGAbove60Degrees;