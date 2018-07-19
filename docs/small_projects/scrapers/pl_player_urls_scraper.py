import re
import requests
import numpy as np
import pandas as pd
from bs4 import BeautifulSoup as bs
from collections import OrderedDict
from selenium import webdriver
import time

link = 'http://www.premierleague.com/players'
driver = webdriver.PhantomJS()
driver.get(link)
pause = 3

lastHeight = driver.execute_script("return document.body.scrollHeight")
while True:
    driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")
    time.sleep(pause)
    newHeight = driver.execute_script("return document.body.scrollHeight")
    if newHeight == lastHeight:
        break
    lastHeight = newHeight

players = driver.find_element_by_css_selector('tbody.dataContainer.indexSection')
url_links = [a.get_attribute('href') for a in players.find_elements_by_css_selector('a')]
print(len(url_links))

with open('pl_plyr_links.txt', 'w') as f:
	for url in url_links:
		f.write(url)
		f.write('\n')

driver.close()