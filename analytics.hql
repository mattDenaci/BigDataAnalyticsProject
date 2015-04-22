//Calculating results
//Tables of power and effect size stats (include cohen's D mean difference, mean, median, standard_error, sample_size,post hoc power, adp value, t test, power t test, mann whitney test, power of mann whitney )
//We can create a whole bunch of tables of this format with two rows, were we examine if there is a significant difference number of crimes/(average number of crimes) for property and violent crimes. So for instance, we could have a table of 2 rows:
//groupings in that data.
//Property Crimes ­ Hot Days
//Violent Crimes ­ Hot Days
//And another table of two rows:
//Property Crimes ­ Cold Days //Violent Crimes ­ Cold Days
//Each of the stats would be calculated using the vector of values of difference number of crimes/(average number of crimes). We could treat one //of these groups as something like a control group. This allows us to examine if there is a significant difference on the effect //whether has on different types of crimes at different times. The table we will have are as follows:
[add list of tables]
//We'll also do the fisher exact test for some pairs: Property Crimes, Violent Crimes, Cold Days, Warm Days. See explanation of the test here: http://en.wikipedia.org/wiki/Fisher's_exact_test
//We do a regression for every table for temp and crime.