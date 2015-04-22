//Joining of crime, weather, and transport data
//
//We then join each crime report with the appropriate weather info.
//If we use multiple sources of weather data, we'll join with the station location that has the smallest geometric
//distance from the crime (using the longitude and latitude fields of the weather and crime data)
//
//We can then join each crime listing with that average traffic volume for the day the crime took place, as well as
//the traffic volume for the street nearest to the crime scene (I think geometric is fine here, but maybe there's an argument
for manhattan as chicago is split into blocks. idk)

//Grouping crimes by type
//Select Date, Time, Primary, Type, FBICode, longitude, latitude, zip group by(type) //
//We'll also select types of crimes that are property crimes, and types of crimes that //are violent crimes
//

//Grouping crimes by type
//Select Date, Time, Primary, Type, FBICode, longitude, latitude, zip group by(type) //
//We'll also select types of crimes that are property crimes, and types of crimes that //are violent crimes
//
//Calculate Number of crimes per day
//
//for group in the group of crime data above:
// we'll calculate something like the crime rate by calculating the number of instance of crime
// per day (the change chicago population since 2000 is < 2% so we'll just ignore it), and number of crimes/(average number of crimes)
// so that we can compare rates of different kinds of crimes
//
