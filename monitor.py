import requests, json

#The attributes of the post to collect:
infolist=('subreddit', 'id', 'score', 'title', 'num_comments', 'created_utc', 'ups', 'downs')

#Request parameters:
payload = {'limit': '100'}

#Grab the data:
r = requests.get(r'http://www.reddit.com/r/dataisbeautiful/.json', params=payload)

for i in r.json()['data']['children']:
    if(i['kind']=='t3'):
        for j in infolist:
            print(j, i['data'][j])
