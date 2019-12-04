import os
import pandas as pd
import requests
from bs4 import BeautifulSoup
from time import sleep
"""
CSV Filename for export
"""
dirname = os.path.dirname(__file__)
csv_filename = os.path.join(dirname, '../../datasets/salary/player.csv')
"""
Environment Variables for Crawling
"""
threshold_in_seconds = 1
years = range(1990, 2019)
"""
Player Salaries Data Frame
"""
df = pd.DataFrame()
"""
1990-1991 시즌 부터 2019-2020 시즌까지 player Salaries 정보 크롤링
"""
for year in years:
    req = requests.get(
        "https://hoopshype.com/salaries/players/{0}-{1}/".format(
            year, year + 1))
    html = req.text
    soup = BeautifulSoup(html, 'html.parser')
    """
    Ranking Table > tbody > tr > td[1].a[class="name"] := Player 이름
    Ranking Table > tbody > tr > td[2] := Player Salary 값
    """
    salaries_table_item_list = soup.select(
        '.hh-salaries-ranking-table > tbody > tr')

    data = {}
    for item in salaries_table_item_list:
        data[item.find(class_='name').get_text().strip()] = item.find_all(
            "td")[2].get_text().strip()

    year_df = pd.DataFrame(data, index=["{0}-{1}".format(year, year + 1)])
    df = pd.concat([df, year_df], sort=True, axis=0)
    print(df)

    sleep(threshold_in_seconds)  # 크롤링 Threshold Sleep
"""
2019-20 시즌은 URL 엔드포인트가 달라 따로 크롤링처리를 한다.
"""
req = requests.get("https://hoopshype.com/salaries/players/")
html = req.text
soup = BeautifulSoup(html, 'html.parser')
"""
Ranking Table > tbody > tr > td[1].a[class="name"] := Player 이름
Ranking Table > tbody > tr > td[2] := Player Salary 값
"""
salaries_table_item_list = soup.select(
    '.hh-salaries-ranking-table > tbody > tr')

data = {}
for item in salaries_table_item_list:
    data[item.find(class_='name').get_text().strip()] = item.find_all(
        "td")[2].get_text().strip()

year_df = pd.DataFrame(data, index=["{0}-{1}".format(2019, 2020)])
df = pd.concat([df, year_df], sort=True, axis=0)
print(df)

df.to_csv(csv_filename, mode='w')
