weatherCrimeData <- read.table("~/documents/analyticsProject/data/crime10DayMVGAnd10DayMAVG.csv", , header=F,sep=",")
names(weatherCrimeData) <- c("date", "temp", "violentCrime", "propertyCrime", "miscCrime", "allCrime")
attach(weatherCrimeData)
pdf("tempreToCrimes.pdf",width=7,height=5)
plot(temp, allCrime)
plot(temp, violentCrime)
plot(temp, propertyCrime)
plot(temp, miscCrime)

dev.off()

pdf("dateToCrime", width=9, height=5)
plot(date, allCrime)

dev.off()