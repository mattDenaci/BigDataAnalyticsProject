//Traffic data
Big Data Analytics Project Code Drop 2
//select date, traffic volume, longitude, latitude //
//select sum(traffic volume) group by date
//
//We'll look at variance of traffic volume throughout different days, different parts of year, //different days of week since it may be that (i) there's little variation in traffic volume (var < //5%), in which case it's not going to be useful to us,or (ii) there's a lot of variation due to day //of week, in which case,we'll have to adjust for that.
//
//we can also group each day:
// busy days (top 25% of days)
// average days (26% to 75% of days)
// not busy days days (76% to 100% of days)
// (unfortunately this division into cold warm at hot is somewhat ad hoc)