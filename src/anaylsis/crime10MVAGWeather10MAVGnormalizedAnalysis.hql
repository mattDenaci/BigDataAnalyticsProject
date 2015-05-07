CREATE TABLE yearTempCrimes1(year double, avgTemp double, violentCrime double, propertyCrime double, miscCrime double, allCrime double);
  

INSERT INTO TABLE yearTempCrimes 
  SELECT substr(date, 0, 4), 
   averageTemp, 
   violentCrime, 
   propertyCrime, 
   miscCrime, 
   allCrime 
 FROM weather10DayMAVGAndCrimeCounts10DayMAVG; 

CREATE TABLE yearTempCrimesNormalized2(year double, avgTemp double, violentCrime double, propertyCrime double, miscCrime double, allCrime double)
row format delimited fields terminated by ','  
stored as textfile
location 's3://hdptstbkt-0/results/normalizedData';

INSERT INTO TABLE yearTempCrimesNormalized
select 
  yearTempCrimes.year, 
  yearTempCrimes.avgTemp,
  yearTempCrimes.violentCrime/yearAverage.avgViolentcrime, 
  yearTempCrimes.propertyCrime/yearAverage.avgPropertyCrime, 
  yearTempCrimes.miscCrime/yearAverage.avgMiscCrime, 
  yearTempCrimes.allCrime/yearAverage.avgAllCrime
from
  (select 
   year, 
   avg(violentCrime) as avgViolentcrime, 
   avg(propertyCrime) as avgPropertyCrime, 
   avg(misccrime) as avgMiscCrime, 
   avg(allCrime) as avgAllCrime
  from yearTempCrimes 
  group by year) 
  yearAverage, yearTempCrimes
where yearAverage.year = yearTempCrimes.year;

CREATE EXTERNAL TABLE normalizedResults(
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
location 's3://hdptstbkt-0/results/normalizedResults';

-- calulculate the regressions and correlation coefficients
-- first for all crimes
INSERT INTO TABLE normalizedResults
  SELECT 
    "all crimes",
    corr(avgTemp, allCrime), 
    pow(corr(avgTemp, allCrime), 2), 
    corr(avgTemp, sqrt(allCrime)), 
    pow(corr(avgTemp, sqrt(allCrime)), 2), 
    ((sum(allCrime)*sum(power(avgTemp,2))) - (sum(avgTemp)*sum(avgTemp*allCrime)))/(5198*sum(power(avgTemp, 2)) - power(sum(avgTemp),2)),
    (5198*sum(avgTemp*allCrime) - (sum(avgTemp)*sum(allCrime)))/(5198*sum(power(avgTemp, 2)) - power(sum(avgTemp),2)),
    ((sum(sqrt(allCrime))*sum(power(avgTemp,2))) - (sum(avgTemp)*sum(avgTemp*sqrt(allCrime))))/(5198*sum(power(avgTemp, 2)) - power(sum(avgTemp),2)),
    (5198*sum(avgTemp*sqrt(allCrime)) - (sum(avgTemp)*sum(sqrt(allCrime))))/(5198*sum(power(avgTemp, 2)) - power(sum(avgTemp),2))
  FROM yearTempCrimesNormalized;

-- now for only violent crimes
INSERT INTO TABLE normalizedResults
  SELECT 
    "violent crimes",
    corr(avgTemp, violentCrime), 
    pow(corr(avgTemp, violentCrime), 2), 
    corr(avgTemp, sqrt(violentCrime)), 
    pow(corr(avgTemp, sqrt(violentCrime)), 2), 
    ((sum(violentCrime)*sum(power(avgTemp,2))) - (sum(avgTemp)*sum(avgTemp*violentCrime)))/(5198*sum(power(avgTemp, 2)) - power(sum(avgTemp),2)),
    (5198*sum(avgTemp*violentCrime) - (sum(avgTemp)*sum(violentCrime)))/(5198*sum(power(avgTemp, 2)) - power(sum(avgTemp),2)),
    ((sum(sqrt(violentCrime))*sum(power(avgTemp,2))) - (sum(avgTemp)*sum(avgTemp*sqrt(violentCrime))))/(5198*sum(power(avgTemp, 2)) - power(sum(avgTemp),2)),
    (5198*sum(avgTemp*sqrt(violentCrime)) - (sum(avgTemp)*sum(sqrt(violentCrime))))/(5198*sum(power(avgTemp, 2)) - power(sum(avgTemp),2))
  FROM yearTempCrimesNormalized;

-- now for property crimes
INSERT INTO TABLE normalizedResults
  SELECT 
    "property crimes",
    corr(avgTemp, propertyCrime), 
    pow(corr(avgTemp, propertyCrime), 2), 
    corr(avgTemp, sqrt(propertyCrime)), 
    pow(corr(avgTemp, sqrt(propertyCrime)), 2), 
    ((sum(propertyCrime)*sum(power(avgTemp,2))) - (sum(avgTemp)*sum(avgTemp*propertyCrime)))/(5198*sum(power(avgTemp, 2)) - power(sum(avgTemp),2)),
    (5198*sum(avgTemp*propertyCrime) - (sum(avgTemp)*sum(propertyCrime)))/(5198*sum(power(avgTemp, 2)) - power(sum(avgTemp),2)),
    ((sum(sqrt(propertyCrime))*sum(power(avgTemp,2))) - (sum(avgTemp)*sum(avgTemp*sqrt(propertyCrime))))/(5198*sum(power(avgTemp, 2)) - power(sum(avgTemp),2)),
    (5198*sum(avgTemp*sqrt(propertyCrime)) - (sum(avgTemp)*sum(sqrt(propertyCrime))))/(5198*sum(power(avgTemp, 2)) - power(sum(avgTemp),2))
  FROM yearTempCrimesNormalized;

--finally for misc crimes
INSERT INTO TABLE normalizedResults
  SELECT 
    "misc crimes",
    corr(avgTemp, miscCrime), 
    pow(corr(avgTemp, miscCrime), 2), 
    corr(avgTemp, sqrt(miscCrime)), 
    pow(corr(avgTemp, sqrt(miscCrime)), 2), 
    ((sum(miscCrime)*sum(power(avgTemp,2))) - (sum(avgTemp)*sum(avgTemp*miscCrime)))/(5198*sum(power(avgTemp, 2)) - power(sum(avgTemp),2)),
    (5198*sum(avgTemp*miscCrime) - (sum(avgTemp)*sum(miscCrime)))/(5198*sum(power(avgTemp, 2)) - power(sum(avgTemp),2)),
    ((sum(sqrt(miscCrime))*sum(power(avgTemp,2))) - (sum(avgTemp)*sum(avgTemp*sqrt(miscCrime))))/(5198*sum(power(avgTemp, 2)) - power(sum(avgTemp),2)),
    (5198*sum(avgTemp*sqrt(miscCrime)) - (sum(avgTemp)*sum(sqrt(miscCrime))))/(5198*sum(power(avgTemp, 2)) - power(sum(avgTemp),2))
  FROM yearTempCrimesNormalized;

--Now we'll calculate the tScores

CREATE EXTERNAL TABLE normalzedResultsFinal(
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
location 's3://hdptstbkt-0/results/normalizedResultsFinal';

INSERT INTO TABLE normalzedResultsFinal
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
  FROM normalizedResults;