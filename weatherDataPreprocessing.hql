//Weather data:
//Look at correlation in temps, humidity, precipitation at various weather stations in chicago, //and average to see if we can use a single station. If correlation is low or average daily //temperature difference is high, we need to use all stations. We'll also take average //temperature in chicago from all stations for each day and hour on the assumption that //people may move throughout the city throughout the day, and their mood may be affected by //temperatures in other areas of the city.
//
//if high correlation and average difference in temp between stations < 5 degrees:
// // // // // // //
select temp, precipitation, day, time, from some single site
select average(temperature), average(precipitation) group by date else:
for site in all weather station in chicago:
select temp, precipitation, day, time, l​atitude, longitude​from some site
select average(temperature), average(precipitation) group by date
// for all groups temp, data prec above, we can add a field of string, with the following 5 //categories
// very hot days (top 5% of days)
// hot days (top 20% of days)
// select average days (26% to 75% of days)
// select cold days (76% to 100% of days)
// (unfortunately this division into cold warm at hot is somewhat ad hoc)
