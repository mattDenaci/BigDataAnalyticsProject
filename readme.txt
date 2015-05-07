The code is organized in the following way in the directory src:
	1) all processing of crime data is in crimeETL
	2) all processing of traffic files are in trafficETL
	3) all processing of weather files is in weather ETL 
		i) NCDC(for average temp) calculates the average temp
		ii) NCDC(general purpose) filters the weather dataset
	4) all code to calcaulte correlations and regressions is in the analysis folder. This folder also includes an R script tempToCrimeGraphs.R
		which we used to generate pdg graphs of tempreture vs various types of crimes

The results directory contains .csv files produced by the analysis as well as a pdf of graphs produced by R.

Please email if you have questions. When I ran these scripts I hadn't though about provided evidence that indeed everything ran.  A lot of the hive 
scripts have been run on an amazon EMR instance. You can also access nearly all of the data through it easily via S3. WE can also provide access 
to an S3 account which has copious amounts of logging info.