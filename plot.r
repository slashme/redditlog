log=read.table("log", colClasses=c("NULL", "NULL", "character", "integer"))
log$V3 = as.POSIXlt(log$V3, format = "%H:%M:%S")
plot(log, type="l", main="Idiots upvoting Excel graphs", ylab="Score", xlab="Time")
