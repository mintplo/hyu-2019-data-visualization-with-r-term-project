import os
import pandas as pd
from nba_api.stats.endpoints import playercareerstats
from time import sleep
"""
Environment Variables for Crawling
"""
threshold_in_seconds_player = 10
"""
CSV Filename for import
"""
dirname = os.path.dirname(__file__)
csv_filename = os.path.join(dirname, '../../datasets/player/all_players.csv')
players_df = pd.read_csv(csv_filename)
"""
CSV Filename for export
"""
csv_filename = os.path.join(dirname, '../../datasets/player/stat.csv')
"""
All Players Stat 정보 크롤링
"""
for (index, player) in players_df.iterrows():
    print(index)
    print(player["PERSON_ID"])

    player_stat_df = pd.DataFrame(
        playercareerstats.PlayerCareerStats(player_id=player["PERSON_ID"]).
        get_normalized_dict()['SeasonTotalsRegularSeason'])

    if player_stat_df.empty:
        continue

    player_info_df = player.to_frame().T
    player_info_df = player_info_df.drop(['TEAM_ID', 'TEAM_ABBREVIATION'],
                                         axis=1)

    # Merge Player info and Player Stat
    player_df = pd.merge(player_stat_df,
                         player_info_df,
                         how='outer',
                         left_on='PLAYER_ID',
                         right_on='PERSON_ID')
    print(player_df)

    # Addition to CSV
    player_df.to_csv(csv_filename, mode='a', header=False)

    # Sleep for No ban
    if index % 500 == 0:
        sleep(threshold_in_seconds_player)
