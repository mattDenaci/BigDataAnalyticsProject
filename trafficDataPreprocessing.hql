add jar ${HIVE_HOME}/lib/hive-contrib-0.9.0.jar; 
CREATE TEMPORARY FUNCTION row_sequence as 'org.apache.hadoop.hive.contrib.udf.UDFRowSequence';

CREATE TABLE trafficInput(
  ID INT, 
  Address STRING, 
  Street STRING, 
  date STRING, 
  volume INT, 
  volByDirection STRING, 
  latitude DOUBLE, 
  longitude DOUBLE, 
  location STRING) 
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n'
LOCATION 's3://hdptstbkt-0/input/daily_traffic_counts';

CREATE EXTERNAL TABLE tf2001(
  date string, 
  volume int, 
  id int,
  latitude double, 
  longitude double)
row format delimited fields terminated by ','  
stored as textfile
location 's3://hdptstbkt-0/output/';


INSERT OVERWRITE TABLE tf2001
  select to_date(from_unixtime(unix_timestamp(date, 'MM/dd/yy'))), volume, id, longitude, latitude 
  from traffic 
  order by volume;

