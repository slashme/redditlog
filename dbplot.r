library("RSQLite") #SQLite database driver
#library("scatterplot3d") #3D scatterplots
library("rgl") #Drawing 3D stuff
library("rglwidget") #Drawing 3D stuff

#Open the database and pull all the posts:
con = dbConnect(drv="SQLite", dbname="redditdata.db")
#Make a selection of rows to plot: two rows per subreddit per minimum rank. Select two rows by grouping by even/odd number of comments. To get more rows, mod by a bigger number:
plotthese = dbGetQuery(con, 'SELECT subreddit, postid, minrank FROM (select postid, num_comments, min(rank) AS minrank FROM scores GROUP BY postid) LEFT JOIN posts ON postid = id GROUP BY minrank,subreddit,num_comments % 4')
#plotthese = dbGetQuery(con, 'SELECT subreddit, postid, minrank FROM (select postid, num_comments, min(rank) AS minrank FROM scores GROUP BY postid) LEFT JOIN posts ON postid = id ') #Nerfed version - does basically nothing
#Get all the individually logged post scores:
res = dbGetQuery(con, 'SELECT a.timestamp, a.score, a.num_comments, a.rank, c.created, c.id, c.subreddit FROM scores a LEFT JOIN posts c ON a.postid=c.id')

#Keep only selected rows:
resplot = res[res$id %in% plotthese$postid,]

#Create a column with the age in days of the post at the time of sampling:
resplot$age = (resplot$timestamp - resplot$created)/60/60/24

#Which subreddits to plot in which colours:
plotlist = list(
The_Donald      ="pink"
,gonewild        ="red"
,AskReddit       ="blue"
,IAmA            ="black"
,dataisbeautiful ="green"
)

############2D plot############
##Age value where we cut off the X-axis:
#cutoff=3.0
#
##Set up graphics device:
#png(file = "plot.png", width=1024, height = 1024, units="px", pointsize=30)
#
##Create empty plot:
#plot(1, type="n",
#     main="Reddit post karma trajectories", ylab="Score (net upvotes)", xlab="Age [days]",
#     #xlim=c(0,cutoff), ylim=range(res$score),
#     xlim=c(0,cutoff), ylim=c(0,30000),
#     xaxs="i", yaxs="i"
#     )
#
##Iterate over the listed subreddits, plotting the data for each:
#for (r in names(plotlist)) {
#  for (i in unique(res[res$subreddit == r, ]$id)) {
#    resi=res[res$id == i, ]
#    if (min(resi$age) < cutoff) {
#      lines(resi$age, resi$score, col=as.character(plotlist[r]))
#    }
#  }
#}
##Create a legend with the names and colors:
#legend('topright', names(plotlist), lty=1, col=as.character(plotlist))
#dev.off()

############3D plot############
#Set up graphics device:
#png(file = "3dplot.png", width=1024, height = 1024, units="px", pointsize=20)

#Set up matrix to hold the coordinates of the corners of the plot:
corners = matrix(rep(0,8), nrow = 2, ncol = 4, byrow = TRUE,
  dimnames = list(c("min", "max"),
                  c("Age [days]", "Score (net karma)", "Position in top 100 posts", "Comments")))
#And a list to hold the actual parameters (there must be a better way…)
parnames = c("age", "score", "rank", "num_comments")

#Corners of the plot: Do this for each selected subreddit, because we don't know what was selected
for (r in names(plotlist)) {
    resi=resplot[resplot$subreddit == r, ]
    corners[1,1]=min(corners[1,1], resi$age)
    corners[2,1]=max(corners[2,1], resi$age)
    corners[1,2]=min(corners[1,2], resi$score)
    corners[2,2]=max(corners[2,2], resi$score)
    corners[1,3]=min(corners[1,3], resi$rank)
    corners[2,3]=max(corners[2,3], resi$rank)
    corners[1,4]=min(corners[1,4], resi$num_comments)
    corners[2,4]=max(corners[2,4], resi$num_comments)
}

#Grab only 3 axes (edit the next two lines to choose axes - note the comma!):
corners = corners[,-4]
parnames = parnames[-4]

#Create an empty 3D plot: FIXME: Can I plot invisible dots? Is there a better way?
plotids = plot3d(corners, col="white")

#Iterate over the listed subreddits, plotting the data for each:
for (r in names(plotlist)) {
  for (i in unique(resplot[resplot$subreddit == r, ]$id)) {
    resi=resplot[resplot$id == i, ]
    lines3d(resi[,parnames[1]], resi[,parnames[2]], resi[,parnames[3]], col=as.character(plotlist[r]))
  }
}
#Generate a standalone RGL widget as a website.
#This needs to be run manually - doesn't work from Rscript or "source" within R:
rglwidget(elementId = "plot3drgl")
