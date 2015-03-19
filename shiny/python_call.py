import urllib2
import requests
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np



artists = ['Taylor%20Swift','Katy%20Perry','Bruno%20Mars','Adam%20Smith']
songs = {}
for num, artist in enumerate(artists):  
    artist = artist.lower()
    
    url = "http://api.musicgraph.com/api/v2/track/search?api_key=a33c8e9aefa2478f2d6d1dc585f067ec&artist_name="+str(artist)+"&limit=100"
    print url
    
    try:
        r = requests.get(url).json()['data']
        if num == 0:
            Initial = pd.DataFrame(r)
        else:
            Initial = Data.append(pd.DataFrame(r))
            
    except:
        print "Failed to get "+artist

Match_List = Initial.sort(columns=['artist_name','popularity'],ascending=[True,False]).groupby('artist_name').head(1)

for num, track in enumerate(Match_List['id'].values):
    slow = "http://api.musicgraph.com/api/v2/playlist?api_key=a33c8e9aefa2478f2d6d1dc585f067ec&track_ids="+track+"&popularity=10&tempo=slow&limit=3"
    moderate = "http://api.musicgraph.com/api/v2/playlist?api_key=a33c8e9aefa2478f2d6d1dc585f067ec&track_ids="+track+"&popularity=10&tempo=moderate&limit=3"
    fast = "http://api.musicgraph.com/api/v2/playlist?api_key=a33c8e9aefa2478f2d6d1dc585f067ec&track_ids="+track+"&popularity=10&tempo=fast&limit=3"
    
    for playlist in ['slow','moderate','fast']:
        if num == 0:
            songs = pd.DataFrame(requests.get(str(eval(playlist))).json()['data'])
            songs['Playlist'] = playlist
#             slow_song = pd.DataFrame(requests.get(slow).json()['data'])
#             moderate_song = pd.DataFrame(requests.get(moderate).json()['data'])
#             fast_song = pd.DataFrame(requests.get(fast).json()['data'])
        else:
            _temp = pd.DataFrame(requests.get(str(eval(playlist))).json()['data'])
            _temp['Playlist'] = playlist
            songs = songs.append(_temp)
        
playlists = songs[['Playlist','artist_name' ,'title' , 'primary_tempo','popularity','id']].drop_duplicates().sort(columns=['Playlist','popularity','primary_tempo']).reset_index(drop=True)
playlists = playlists[     (~pd.isnull(playlists['primary_tempo'])) & (~pd.isnull(playlists['primary_tempo'])) ]

playlists['artist_name'] = playlists['artist_name'].str.replace(u'\xe9','e')

drop_rows = []
for artist in playlists['artist_name'].values:
    if artist in [x.replace('%20', ' ') for x in artists]:
        drop_rows.append(False)
    else:
        drop_rows.append(True)
        
Output = playlists[drop_rows]

Output.to_csv('Example.txt',sep='\t')

Output.sort(columns=['Playlist','primary_tempo'],ascending=[False,True])['primary_tempo'].astype(float).reset_index(drop=True).plot();