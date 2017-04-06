library("RSQLite") #SQLite database driver
library("scatterplot3d") #3D scatterplots

#Open the database and pull all the posts:
con = dbConnect(drv="SQLite", dbname="redditdata.db")
res = dbGetQuery(con, 'SELECT a.timestamp, a.score, a.num_comments, a.rank, c.created, c.id, c.subreddit FROM scores a LEFT JOIN posts c ON a.postid=c.id')

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
IAmA            ="black",
gonewild        ="pink",
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

############3D plot############
#Set up graphics device:
png(file = "3dplot.png", width=1024, height = 1024, units="px", pointsize=20)

#Corners of the plot:
mina=min(res$age)
maxa=max(res$age)
mins=min(res$score)
maxs=max(res$score)
minr=min(res$rank)
maxr=max(res$rank)
corners = matrix(c(mina,mins,minr, maxa,maxs,maxr), nrow = 2, ncol = 3, byrow = TRUE,
               dimnames = list(c("row1", "row2"),
                               c("Age [days]", "Score (net karma)", "Position in top 100 posts")))

#Create an empty 3D plot:
s3d = scatterplot3d(corners, color="white")

#Iterate over the listed subreddits, plotting the data for each:
for (r in names(plotlist)) {
  for (i in unique(res[res$subreddit == r, ]$id)) {
    resi=res[res$id == i, ]
    s3d$points3d(resi$age, resi$score, resi$rank, type="l", col=as.character(plotlist[r]))
  }
}

dev.off()

