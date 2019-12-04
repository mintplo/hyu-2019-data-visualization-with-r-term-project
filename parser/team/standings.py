import os
import pandas as pd
from nba_api.stats.endpoints import leaguestandings
from nba_api.stats.library.parameters import LeagueID, SeasonType
from time import sleep
"""
CSV Filename for export
"""
dirname = os.path.dirname(__file__)
csv_filename = os.path.join(dirname, '../../datasets/team/standings.csv')
"""
Environment Variables for Crawling
"""
threshold_in_seconds = 3
years = range(1990, 2020)
"""
Team Standings Data Frame
"""
df = pd.DataFrame()
"""
1990-1991 시즌 부터 2019-2020 시즌까지 Team Standings 정보 크롤링
"""
for year in years:
    season = "{}-{}".format(year, str(year + 1)[2:])

    year_df = leaguestandings.LeagueStandings(
        league_id=LeagueID.nba, season=season,
        season_type=SeasonType.regular).get_data_frames()

    df = pd.concat([df, year_df[0]], axis=0)
    print(df)

    sleep(threshold_in_seconds)

df.to_csv(csv_filename, mode='w')
