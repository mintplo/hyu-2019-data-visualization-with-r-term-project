import os
import pandas as pd
from nba_api.stats.static import players
"""
Player Salaries CSV File import
"""
dirname = os.path.dirname(__file__)
csv_filename = os.path.join(dirname, './salary/player.csv')
player_salaries_df = pd.read_csv(csv_filename)
"""
Player Stat CSV File Import
"""
dirname = os.path.dirname(__file__)
csv_filename = os.path.join(dirname, './player/stat.csv')
player_stat_df = pd.read_csv(csv_filename)

processed_player_salaries_df = pd.DataFrame()
for i in player_salaries_df:
    player = players.find_players_by_full_name(i)
    if not player:
        continue

    df = pd.DataFrame(
        {
            'PLAYER_ID': player[0]['id'],
            'SEASON_ID': player_salaries_df['year'],
            'SALARY': player_salaries_df[i]
        },
        columns=['PLAYER_ID', 'SEASON_ID', 'SALARY'])

    processed_player_salaries_df = pd.concat(
        [processed_player_salaries_df, df], axis=0)
    print(processed_player_salaries_df)
"""
Completed Stat CSV File import
"""
dirname = os.path.dirname(__file__)
csv_filename = os.path.join(dirname, './player/completed_stat.csv')

completed_stat_players_df = pd.merge(player_stat_df,
                                     processed_player_salaries_df,
                                     how='outer',
                                     on=['PLAYER_ID', 'SEASON_ID'])
completed_stat_players_df = completed_stat_players_df.drop(['Unnamed: 0'],
                                                           axis=1)
completed_stat_players_df.to_csv(csv_filename, mode='a')
