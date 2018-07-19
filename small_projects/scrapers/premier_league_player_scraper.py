import re
import time
import requests
import numpy as np
import pandas as pd
from bs4 import BeautifulSoup as bs
from collections import OrderedDict


#PLAYER_OVERVIEW = 'http://www.premierleague.com/players/9943/Almen-Abdi/overview'
#PLAYER_STATS = 'http://www.premierleague.com/players/9943/Almen-Abdi/stats'

def player_info(soup):
	"""
	Detail: Collects a player's Country, Age, Debut_Date, DOB, Height, Weight, Name
	Args: Beautiful soup object of player overview page
	Returns: A general player info dictionary
	"""
	general_info_labels = ['Club', 'Position', 'Country', 'Age', 'Debut_Date', 'DOB', 'Height', 'Weight', 'Name']
	general_info = [a.text.replace('\n','') for a in soup.findAll('div', {'class': 'info'}) if len(a.text)>0]
	general_info.append(soup_overview.find('div', {'class': 'name'}).text)

	return dict(zip(general_info_labels, general_info))

def player_stats(soup):
	"""
	Detail: Collects a player's stats
	Args: Beautiful soup object of player stats page
	Returns: A stats dictionary
	"""
	split_re = re.compile('\s{2,}')
	stat_dict = {}
	stat_dict.update(dict([split_re.split(a.text.replace('\n', '').strip()) 
                         for a in soup.findAll('div', {'class': 'normalStat'})]))
	stat_dict.update(dict(zip(['Appearances', 'Mins_Played'], 
    [int(soup.find('span', {'data-stat': 'appearances'}).text.replace('\n', '').strip()),
     int(soup.find('span', {'data-stat': 'mins_played'}).text.replace('\n', '').replace(',', '').strip())])))

	return stat_dict

if __name__=='__main__':

	with open('pl_plyr_links.txt', 'r') as f:
		player_info_urls = [url.replace('\n','') for url in f.readlines()]
	player_stats_urls = [url.replace('overview', 'stats') for url in player_info_urls]

	full_data = []
	no_data = []

	for i, player in enumerate(zip(player_info_urls, player_stats_urls)):
		print('player {} started'.format(i))
		soup_overview = bs(requests.get(player[0]).text, "html.parser")
		soup_stats = bs(requests.get(player[1]).text, "html.parser")
		player_dict = OrderedDict()
		try:
			player_dict.update(player_info(soup_overview))
			player_dict.update(player_stats(soup_stats))
		except:
			print('Unable to get info for {}'.format(player))
			no_data.append(player)
		full_data.append(player_dict)
		print('player {} finished'.format(i))
		time.sleep(2)
	
	full_data_df = pd.DataFrame(full_data)
	full_data_df.to_csv('pl_player_stats.csv')
	with open('no_data.txt', 'w') as f:
		for i in no_data:
			f.write(i[0])
			f.write('\n')