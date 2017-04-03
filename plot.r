#Read in the log:
log=read.table("log", colClasses=c("NULL", "NULL", "character", "integer"))
#I did the timestamps in a bit of a stupid way, so change the text timestamp into a real time:
log$V3 = as.POSIXlt(log$V3, format = "%H:%M:%S")
#Set up the plot device:
png(file = "plot.png", width=1024, height = 1024, units="px", pointsize=30)
#Plot a snarky graph:
plot(log, type="l", main="Idiots upvoting Excel graphs", ylab="Score", xlab="Time")
#Close the device:
dev.off()
