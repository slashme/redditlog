#Read in the log:
log=read.table("log", colClasses=c(rep("character", 3), "integer"))
#I did the timestamps in a bit of a stupid way, so change the text timestamp into a real time:
log$V3 = as.POSIXlt(paste(log$V1, log$V2, log$V3), format = "%b %d %H:%M:%S", tz="CET")
#Set up the plot device:
png(file = "plot.png", width=1024, height = 1024, units="px", pointsize=30)
#Plot a snarky graph:
plot(log$V3, log$V4, type="l", main="Kink in the karma of a DataIsBeautiful post", ylab="Score (net upvotes)", xlab="Time", ylim=c(0,max(log$V4)))
#Close the device:
dev.off()
