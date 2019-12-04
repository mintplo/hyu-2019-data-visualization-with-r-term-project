import os
import pandas as pd
from nba_api.stats.endpoints import commonallplayers
from nba_api.stats.library.parameters import LeagueID
"""
CSV Filename for export
"""
dirname = os.path.dirname(__file__)
"""
Environment Variables for Crawling
"""
threshold_in_seconds_player = 10
threshold_in_seconds_year = 60
years = range(1990, 2020)

players_df = pd.DataFrame()
for year in years:
    season = "{}-{}".format(year, str(year + 1)[2:])
    players = commonallplayers.CommonAllPlayers(
        league_id=LeagueID.nba, season=season).get_normalized_dict()

    print(season)
    print(len(players["CommonAllPlayers"]))
    for player in players["CommonAllPlayers"]:
        temp_player = player
        temp_player['is_crawl_completed'] = False

        if 'PERSON_ID' in players_df.columns and players_df.PERSON_ID[
                players_df['PERSON_ID'] == player["PERSON_ID"]].count() > 0:
            continue

        player_df = pd.DataFrame(temp_player, index=[0])
        players_df = pd.concat([players_df, player_df], axis=0)
        print(players_df)

    players_df = players_df.drop_duplicates(['PERSON_ID'], keep='first')

csv_filename = os.path.join(dirname, '../../datasets/player/all_players.csv')
players_df.to_csv(csv_filename, mode='w')
