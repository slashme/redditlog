import requests, json, time, sqlite3

#Database connection:
conn = sqlite3.connect('redditdata.db')
c = conn.cursor()

#Request parameters:
payload = {'limit': '100'}

#Main loop:
while(True):
    #Select which subreddits to grab from:
    for subred in ("dataisbeautiful", "askreddit", "thedonald"):
        #Grab the data:
	try:
		r = requests.get(r'http://www.reddit.com/r/'+subred+'/.json', params=payload)
	except: #Brutal catch-anything clause, because I don't know net errors.
		print("error, trying again")
		time.sleep(10)
		break
        print(r)
        print(subred)
        requesttime=time.time()
        #Skip parsing if there's an error response:
        if not ('error' in r.json()): 
            #Iterate over all the returned items:
            for i in r.json()['data']['children']:
                #Skip non-posts and text posts and stickied posts:
                if(i['kind']=='t3' and i['data']['stickied']==False):
                    #Insert the post into the DB, unless it already exists:
                    c.execute("INSERT OR IGNORE INTO posts(subreddit, id, title, created) VALUES(?,?,?,?)", (i['data']['subreddit'], i['data']['id'], i['data']['title'], i['data']['created_utc']))
                    #Log data into the scores table:
                    c.execute("INSERT INTO scores(timestamp, score, num_comments, ups, downs, postid, gilded) VALUES(?,?,?,?,?,?,?)", (requesttime, i['data']['score'], i['data']['num_comments'], i['data']['ups'], i['data']['downs'], i['data']['id'], i['data']['gilded']))
            conn.commit()
    #Delay before reloading:
    time.sleep(120)

conn.close()

