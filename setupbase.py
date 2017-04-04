import sqlite3

#Database connection:
conn = sqlite3.connect('redditdata.db')

c = conn.cursor()

#Create a really basic table to hold the list of posts:
c.execute('''CREATE TABLE posts (subreddit text, id text UNIQUE, title text, created real)''')
conn.commit()
#Create a table of data points per post:
c.execute('''CREATE TABLE scores (timestamp DATETIME DEFAULT CURRENT_TIMESTAMP, score INTEGER, num_comments INTEGER, ups INTEGER, downs INTEGER, postid TEXT, gilded INTEGER, FOREIGN KEY(postid) REFERENCES posts(id))''')
conn.commit()
conn.close()
