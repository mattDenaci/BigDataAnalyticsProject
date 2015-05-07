-- first we'll add the python script, that we'll use to create graphs 
-- of the via matplotlib when we are all finished
add file graphMaker.py

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

CREATE EXTERNAL TABLE results(
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
location 's3://hdptstbkt-0/results/violent_crime_results_intermediate';

-- calulculate the regressions and correlation coefficients
-- first for all crimes
INSERT INTO TABLE results
  SELECT 
    "all crimes",
    corr(averageTemp, allCrime), 
    pow(corr(averageTemp, allCrime), 2), 
    corr(averageTemp, sqrt(allCrime)), 
    pow(corr(averageTemp, sqrt(allCrime)), 2), 
    ((sum(allCrime)*sum(power(averageTemp,2))) - (sum(averageTemp)*sum(averageTemp*allCrime)))/(5198*sum(power(averageTemp, 2)) - power(sum(averageTemp),2)),
    (5198*sum(averageTemp*allCrime) - (sum(averageTemp)*sum(allCrime)))/(5198*sum(power(averageTemp, 2)) - power(sum(averageTemp),2)),
    ((sum(sqrt(allCrime))*sum(power(averageTemp,2))) - (sum(averageTemp)*sum(averageTemp*sqrt(allCrime))))/(5198*sum(power(averageTemp, 2)) - power(sum(averageTemp),2)),
    (5198*sum(averageTemp*sqrt(allCrime)) - (sum(averageTemp)*sum(sqrt(allCrime))))/(5198*sum(power(averageTemp, 2)) - power(sum(averageTemp),2))
  FROM crimeWeatherAndCounts10DayMAVG;

-- now for only violent crimes
INSERT INTO TABLE results
  SELECT 
    "violent crimes",
    corr(averageTemp, violentCrime), 
    pow(corr(averageTemp, violentCrime), 2), 
    corr(averageTemp, sqrt(violentCrime)), 
    pow(corr(averageTemp, sqrt(violentCrime)), 2), 
    ((sum(violentCrime)*sum(power(averageTemp,2))) - (sum(averageTemp)*sum(averageTemp*violentCrime)))/(5198*sum(power(averageTemp, 2)) - power(sum(averageTemp),2)),
    (5198*sum(averageTemp*violentCrime) - (sum(averageTemp)*sum(violentCrime)))/(5198*sum(power(averageTemp, 2)) - power(sum(averageTemp),2)),
    ((sum(sqrt(violentCrime))*sum(power(averageTemp,2))) - (sum(averageTemp)*sum(averageTemp*sqrt(violentCrime))))/(5198*sum(power(averageTemp, 2)) - power(sum(averageTemp),2)),
    (5198*sum(averageTemp*sqrt(violentCrime)) - (sum(averageTemp)*sum(sqrt(violentCrime))))/(5198*sum(power(averageTemp, 2)) - power(sum(averageTemp),2))
  FROM crimeWeatherAndCounts10DayMAVG;

-- now for property crimes
INSERT INTO TABLE results
  SELECT 
    "property crimes",
    corr(averageTemp, propertyCrime), 
    pow(corr(averageTemp, propertyCrime), 2), 
    corr(averageTemp, sqrt(propertyCrime)), 
    pow(corr(averageTemp, sqrt(propertyCrime)), 2), 
    ((sum(propertyCrime)*sum(power(averageTemp,2))) - (sum(averageTemp)*sum(averageTemp*propertyCrime)))/(5198*sum(power(averageTemp, 2)) - power(sum(averageTemp),2)),
    (5198*sum(averageTemp*propertyCrime) - (sum(averageTemp)*sum(propertyCrime)))/(5198*sum(power(averageTemp, 2)) - power(sum(averageTemp),2)),
    ((sum(sqrt(propertyCrime))*sum(power(averageTemp,2))) - (sum(averageTemp)*sum(averageTemp*sqrt(propertyCrime))))/(5198*sum(power(averageTemp, 2)) - power(sum(averageTemp),2)),
    (5198*sum(averageTemp*sqrt(propertyCrime)) - (sum(averageTemp)*sum(sqrt(propertyCrime))))/(5198*sum(power(averageTemp, 2)) - power(sum(averageTemp),2))
  FROM crimeWeatherAndCounts10DayMAVG;

--finally for misc crimes
INSERT INTO TABLE results
  SELECT 
    "misc crimes",
    corr(averageTemp, miscCrime), 
    pow(corr(averageTemp, miscCrime), 2), 
    corr(averageTemp, sqrt(miscCrime)), 
    pow(corr(averageTemp, sqrt(miscCrime)), 2), 
    ((sum(miscCrime)*sum(power(averageTemp,2))) - (sum(averageTemp)*sum(averageTemp*miscCrime)))/(5198*sum(power(averageTemp, 2)) - power(sum(averageTemp),2)),
    (5198*sum(averageTemp*miscCrime) - (sum(averageTemp)*sum(miscCrime)))/(5198*sum(power(averageTemp, 2)) - power(sum(averageTemp),2)),
    ((sum(sqrt(miscCrime))*sum(power(averageTemp,2))) - (sum(averageTemp)*sum(averageTemp*sqrt(miscCrime))))/(5198*sum(power(averageTemp, 2)) - power(sum(averageTemp),2)),
    (5198*sum(averageTemp*sqrt(miscCrime)) - (sum(averageTemp)*sum(sqrt(miscCrime))))/(5198*sum(power(averageTemp, 2)) - power(sum(averageTemp),2))
  FROM crimeWeatherAndCounts10DayMAVG;

--Now we'll calculate the tScores

CREATE EXTERNAL TABLE resultsFinalCorrected(
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
location 's3://hdptstbkt-0/results/weather_and_crime10DayAVGFinal_corrected';

INSERT INTO TABLE resultsFinalCorrected
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
   (linearr*sqrt(5198-2))/sqrt(1-linearrSquared),
   (quadraticr*sqrt(5198-2))/sqrt(1-quadraticrSquared)
  FROM results;



