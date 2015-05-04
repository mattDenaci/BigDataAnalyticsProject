-- first we'll add the python script, that we'll use to create graphs 
-- of the via matplotlib when we are all finished
add file graphMaker.py

-- second we'll load the data we'd like to analyize
-- numberOfRows will is a variable defined at the command line
CREATE TABLE violentCrimeCounts(
  date String, 
  type String, 
  latitude DOUBLE, 
  longitude DOUBLE) 
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n'
location 's3://hdptstbkt-0/violent_crime_counts';

CREATE EXTERNAL TABLE results(
  crimeType string,
  r double,
  rSquared double,
  linearCorrelationCoEfficient double,
  linearIntercept double,
  quadraticCorrelationCoefficient double,
  quadraticCorrelationIntercept double
)
row format delimited fields terminated by ','  
stored as textfile
location 's3://hdptstbkt-0/violent_crime_results_intermediate';

-- calulculate the regressions
INSERT TABLE resultsIntermediate
  "Violent Crimes", 
  select 
 	corr(tempreture, numberOfCrimes), 
  	pow(corr(tempreture, numberOfCrimes), 2), 
  	(sum(numberOfCrimes)*sum(power(tempreture,2)) - sum(tempreture)*sum(tempreture*numberOfCrimes))/numberOfRows
  	numberOfRows*sum(tempreture*numberOfCrimes) - (sum(tempreture)*sum(numberOfCrimes))/((numberOfRows*sum(tempreture))-sum(tempreture))
  	(sum(sqrt(numberOfCrimes))*sum(power(tempreture,2)) - sum(tempreture)*sum(tempreture*sqrt(numberOfCrimes))/numberOfRows
  	numberOfRows*sum(tempreture*sqrt(numberOfCrimes)) - (sum(tempreture)*sum(sqrt(numberOfCrimes))/((numberOfRows*sum(tempreture))-sum(tempreture))
  from violentCrimeCounts;

CREATE EXTERNAL TABLE resultsIntermediate(
  crimeType string,
  r double,
  rSquared double,
  linearCorrelationCoEfficient double,
  linearIntercept double,
  quadraticCorrelationCoefficient double,
  quadraticCorrelationIntercept double
  pValueLinear double,
  pValueQuadratic double
)
row format delimited fields terminated by ','  
stored as textfile
location 's3://hdptstbkt-0/violent_crime_results_final';



