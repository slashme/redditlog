library("RSQLite")
con = dbConnect(drv="SQLite", dbname="redditdata.db")
res = dbGetQuery(con, 'SELECT a.timestamp, a.score, a.num_comments, c.created, c.id, c.subreddit FROM scores a LEFT JOIN posts c ON a.postid=c.id')
res$age = (res$timestamp - res$created)/60/60/24
plot(res$score ~ res$age, main="Trajectories", ylab="Score (net upvotes)", xlab="Age [days]")
#dbClearResult(dbListResults(con)[[1]])
#Create empty plot:
plot(1, type="n",
     main="Trajectories", ylab="Score (net upvotes)", xlab="Age [days]",
     xlim=range(res$age), ylim=range(res$score)
     )
for (i in unique(res[res$subreddit == "AskReddit", ]$id)) { lines(res[res$id == i, ]$age, res[res$id == i, ]$score, col="green")}
for (i in unique(res[res$subreddit == "dataisbeautiful", ]$id)) { lines(res[res$id == i, ]$age, res[res$id == i, ]$score, col="red")}
legend('topleft', c("AskReddit", "dataisbeautiful"), lty=1, col=c("green", "red"))
