import requests, json

infolist=('subreddit', 'id', 'score', 'title', 'num_comments', 'created_utc', 'ups', 'downs')

r = requests.get(r'http://www.reddit.com/r/dataisbeautiful/.json')

for i in r.json()['data']['children']:
    for j in infolist:
        print(j, i['data'][j])
