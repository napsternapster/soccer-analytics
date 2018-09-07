# Need to attach year and game week in final results
# Do from 2006 onwards - first year of 38 game season
# So far have workflow for one game week in one season
# 12 years of data, 38 games weeks, 10 games per week: 4560

from bs4 import BeautifulSoup as bs
import requests as req
import numpy as np
import pandas as pd
import time

def get_data(link, yr, gw):

    # Get games: competitors and results
    
    url = link.format(yr, gw)

    dfs = pd.read_html(url)
    # The second table has the results and I only keep the teams and the score from that table.
    data = dfs[1].iloc[:, [2, 4, 5]]

    soup = bs(req.get(url).content, "lxml")

    # Get links to game details

    a_tags = soup.find_all('a')

    match_report_links = []
    for tag in a_tags:
        try:
            if 'Match details' in tag['title']:
                match_report_links.append('http://usa.worldfootball.net/{}'.format(tag['href']))
        except:
            pass

    # Get manager names from game details
    manager_info = []

    for link in match_report_links:
        soup2 = bs(req.get(link).content, "lxml")
        th_links = soup2.find_all('th')
        manager_info.append([y.text for y in filter(lambda x: 'Manager' in x.text, th_links)])

    # Compile full data
    data_full = pd.concat([data, pd.DataFrame(manager_info, columns = ['manager_1', 'manager_2'])], axis = 1)
    data_full['season'] = yr
    data_full['game_week'] = gw

    data_full.columns = ['team_1', 'team_2', 'score', 'manager_1', 'manager_2', 'season', 'game_week']
    
    return data_full
    
# General url format with placeholders for season and gameweek
#url = "http://usa.worldfootball.net/schedule/bra-serie-a-{}-spieltag/{}/" #Brazil
url = "http://usa.worldfootball.net/schedule/eng-premier-league-{}-spieltag/{}/" #England

#[year for year in range(2006, 2018)] #Brazil
years = [str(year)+'-'+str(year+1) for year in range(1995, 2018)] #England
game_weeks = [game_work for game_work in range(1, 39)]

data_all = []

for year in years:
    for game_week in game_weeks:
        data_all.append(get_data(url, year, game_week))        
    time.sleep(5)
    
df_final = pd.concat(data_all, axis = 0)

# Brazil scraping specific: Had to remove this Chapecoense game which was after the air disaster
#df_final2 = df_final2[df_final2.score != 'dnp']

df_final2 = df_final[~df_final.manager_1.isna() | ~df_final.manager_2.isna()]

# The scores include fulltime and halftime results. This formated the scores from 2:2 (1:1) to 2-2, for example.
df_final2.score = df_final2.score.map(lambda x: x.split('(')[0].strip().replace(':', '-'))

df_final2['team_1_score'] = df_final2.score.map(lambda x: x.split('-')[0])
df_final2['team_2_score'] = df_final2.score.map(lambda x: x.split('-')[1])
df_final2['manager_1'] = df_final2.manager_1.map(lambda x: x.split(':')[1].strip())
df_final2['manager_2'] = df_final2.manager_2.map(lambda x: x.split(':')[1].strip())

# I had to specify the encoding because of the accents
df_final.to_csv('eng_results_raw.csv', index = False, encoding='utf-8')
df_final2.to_csv('eng_results_refined.csv', index=False, encoding='utf-8')
