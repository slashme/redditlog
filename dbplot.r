library("RSQLite")
con = dbConnect(drv="SQLite", dbname="redditdata.db")
res = dbGetQuery(con, 'SELECT a.timestamp, a.score, a.num_comments, c.created, c.id FROM scores a LEFT JOIN posts c ON a.postid=c.id')
res$age = (res$timestamp - res$created)/60/60/24
plot(res$score ~ res$age, main="Trajectories", ylab="Score (net upvotes)", xlab="Age [days]")
#dbClearResult(dbListResults(con)[[1]])

