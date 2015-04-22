create external table traffic (id int, trafficVolume int, date string, temperature int, quality tinyint, nines int)
          row format delimited fields terminated by ','
          location '/user/cloudera/hiveInput/traffic.txt';

