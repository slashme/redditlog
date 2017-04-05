library("RSQLite") #SQLite database driver

#Open the database and pull all the posts:
con = dbConnect(drv="SQLite", dbname="redditdata.db")
res = dbGetQuery(con, 'SELECT a.timestamp, a.score, a.num_comments, c.created, c.id, c.subreddit FROM scores a LEFT JOIN posts c ON a.postid=c.id')

#Create a column with the age in days of the post at the time of sampling:
res$age = (res$timestamp - res$created)/60/60/24

#Create empty plot:
plot(1, type="n",
     main="Trajectories", ylab="Score (net upvotes)", xlab="Age [days]",
     xlim=c(0,6), ylim=range(res$score)
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
    lines(res[res$id == i, ]$age, res[res$id == i, ]$score, col=as.character(plotlist[r]))
  }
}
#Create a legend with the names and colors:
legend('topleft', names(plotlist), lty=1, col=as.character(plotlist))
