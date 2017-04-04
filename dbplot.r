library("RSQLite")
con = dbConnect(drv="SQLite", dbname="redditdata.db")
res = dbGetQuery(con, 'SELECT a.timestamp, a.score, c.created, c.id FROM scores a LEFT JOIN posts c ON a.postid=c.id')
res$age = res$timestamp - res$created
#dbClearResult(dbListResults(con)[[1]])

