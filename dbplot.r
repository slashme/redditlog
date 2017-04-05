library("RSQLite") #SQLite database driver

#Open the database and pull all the posts:
con = dbConnect(drv="SQLite", dbname="redditdata.db")
res = dbGetQuery(con, 'SELECT a.timestamp, a.score, a.num_comments, c.created, c.id, c.subreddit FROM scores a LEFT JOIN posts c ON a.postid=c.id')

#Create a column with the age in days of the post at the time of sampling:
res$age = (res$timestamp - res$created)/60/60/24

#Age value where we cut off the X-axis:
cutoff=3.0

#Set up graphics device:
png(file = "plot.png", width=1024, height = 1024, units="px", pointsize=30)

#Create empty plot:
plot(1, type="n",
     main="Reddit post karma trajectories", ylab="Score (net upvotes)", xlab="Age [days]",
     #xlim=c(0,cutoff), ylim=range(res$score),
     xlim=c(0,cutoff), ylim=c(0,30000),
     xaxs="i", yaxs="i"
     )

#Which subreddits to plot in which colours:
plotlist = list(
The_Donald      ="red",
AskReddit       ="blue",
dataisbeautiful ="green"
)

#Iterate over the listed subreddits, plotting the data for each:
for (r in names(plotlist)) {
  for (i in unique(res[res$subreddit == r, ]$id)) {
    resi=res[res$id == i, ]
    if (min(resi$age) < cutoff) {
      lines(resi$age, resi$score, col=as.character(plotlist[r]))
    } else {
    }
  }
}
#Create a legend with the names and colors:
legend('topright', names(plotlist), lty=1, col=as.character(plotlist))
dev.off()
