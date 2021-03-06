import sqlite3

#Database connection:
conn = sqlite3.connect('redditdata.db')

c = conn.cursor()

#Create a really basic table to hold the list of posts:
c.execute('''CREATE TABLE posts (subreddit text, id text UNIQUE, title text, created real)''')
conn.commit()
#Create a table of data points per post: rank is the position of the post in the subreddit
c.execute('''CREATE TABLE scores (timestamp float, score INTEGER, num_comments INTEGER, ups INTEGER, downs INTEGER, postid TEXT, gilded INTEGER, rank INTEGER, FOREIGN KEY(postid) REFERENCES posts(id))''')
conn.commit()
conn.close()
