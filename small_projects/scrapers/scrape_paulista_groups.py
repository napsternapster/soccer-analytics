import requests
import pandas as pd
from bs4 import BeautifulSoup as bs
from collections import OrderedDict as odict

from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

RES = requests.get('http://int.soccerway.com/national/brazil/paulista-a1/2016/regular-season/r33596/')
SOUP = bs(RES.text)

def tbl_to_df(soup):
    data = []
    tables = [t for t in soup.findAll('table', {'data-round_id': 33596})[:-1]]
    cols = tables[0].find('tr', {'class': 'sub-head'}).text.split('\n')[1:-3]
    cols.remove('\xa0')
    
    for index, table in enumerate(tables):
        teams = table.find('tbody').findAll('tr')
        team_data = [[x.text for x in team.findAll('td')[:-2] if x.text not in '\n\n'] for team in teams]
        group_data = [odict(zip(cols,x)) for x in team_data]        
        data.extend(group_data)
        
    df = pd.DataFrame(data)
    df.D = df.D.apply(lambda x: int(x[1:]) if x[0] == '+' else -1*int(x[1:]))
    df = df.rename(columns = {"#":'POS'})
    groups = ['A', "B", "C", "D"]*5
    groups.sort()
    df['Group'] = groups
    return df
	
if __name__ == "__main__":
    paulista_table = tbl_to_df(SOUP)
    paulista_table.to_csv('paulista_table_2016_test.csv')