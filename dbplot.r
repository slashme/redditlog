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
for (i in unique(res[res$subreddit == "The_Donald", ]$id)) { lines(res[res$id == i, ]$age, res[res$id == i, ]$score, col="red")}
for (i in unique(res[res$subreddit == "AskReddit", ]$id)) { lines(res[res$id == i, ]$age, res[res$id == i, ]$score, col="blue")}
for (i in unique(res[res$subreddit == "dataisbeautiful", ]$id)) { lines(res[res$id == i, ]$age, res[res$id == i, ]$score, col="green")}
legend('topleft', c("AskReddit", "dataisbeautiful", "The_Donald"), lty=1, col=c("blue", "green", "red"))
