import numpy as np
import pandas as pd
from bs4 import BeautifulSoup as bs
import requests as req
import numpy as np
import pandas as pd
import time

def get_1718_table(url):
    df = pd.read_html(url)[3]
    df = df.iloc[1:len(df), 2:len(df.columns)]
    df.columns = ['team', 'matches', 'w', 'd', 'l', 'g_fa', 'gd', 'pts']
    return(df)

def get_scores(link, comp, gw):

    # Get games: competitors and results    
    url = link.format(comp, gw)
    # The second table has the results and I only keep the teams and the score from that table.
    data = pd.read_html(url)[1].iloc[:, [2, 4, 5]]
    data['competition'] = comp
    data['game_week'] = gw
    
    return data

# Get 16/17 tables & construct groups

pl = get_1718_table("http://usa.worldfootball.net/schedule/eng-premier-league-2016-2017-spieltag/38/")
champ = get_1718_table("http://usa.worldfootball.net/schedule/eng-championship-2016-2017-spieltag/46/")
l1 = get_1718_table("http://usa.worldfootball.net/schedule/eng-league-one-2016-2017-spieltag/46/")
l2 = get_1718_table("http://usa.worldfootball.net/schedule/eng-league-two-2016-2017-spieltag/46/")

pl['competition'] = 'eng-premier-league'
champ['competition'] = 'eng-championship'
l1['competition'] = 'eng-league-one'
l2['competition'] = 'eng-league-two'

df_tables = pd.concat([pl, champ, l1, l2], axis = 0)

# Get 17/18 results

# General url format with placeholders for competition and gameweek
competitions = ['eng-premier-league', 'eng-championship', 'eng-league-one', 'eng-league-two']
url = "http://usa.worldfootball.net/schedule/{}-2017-2018-spieltag/{}/"
game_weeks = [game_work for game_work in range(1, 47)]
data_all = []

for competition in competitions:
    for game_week in game_weeks:
        if competition=='eng-premier-league' and game_week==39:
            break
        else:
            data_all.append(get_scores(url, competition, game_week))        
    time.sleep(5)
    
df_final = pd.concat(data_all, axis = 0)
df_final.columns = ['team_1', 'team_2', 'score', 'competition', 'game_week']
df_final.score = df_final.score.map(lambda x: x.split('(')[0].strip().replace(':', '-'))
df_final['team_1_score'] = df_final.score.map(lambda x: x.split('-')[0])
df_final['team_2_score'] = df_final.score.map(lambda x: x.split('-')[1])

# Export

df_tables.to_csv("pl_to_l2_1617_tables.csv", index = False)
df_final.to_csv("pl_to_l2_1718_results.csv", index = False)
