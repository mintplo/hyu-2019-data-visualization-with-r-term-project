import os
import pandas as pd
"""
All Players CSV Filename for import
"""
dirname = os.path.dirname(__file__)
csv_filename = os.path.join(dirname, './player/all_players.csv')
players_df = pd.read_csv(csv_filename)
"""
All Players Data Pre Processing
"""
players_df = players_df.drop(['Unnamed: 0', 'is_crawl_completed'], axis=1)
"""
All Players CSV Filename for export
"""
csv_filename = os.path.join(dirname, './player/all_players.csv')
players_df.to_csv(csv_filename, mode='w')
"""
All Players Stat CSV Filename for import
"""
dirname = os.path.dirname(__file__)
csv_filename = os.path.join(dirname, './player/stat.csv')
players_df = pd.read_csv(csv_filename)
"""
All Players Stat Data Pre Processing
"""
players_df = players_df.drop(
    ['Unnamed: 0', 'Unnamed: 0.1', 'is_crawl_completed'], axis=1)
"""
All Players Stat CSV Filename for export
"""
csv_filename = os.path.join(dirname, './player/stat.csv')
players_df.to_csv(csv_filename, mode='w')
"""
Standings CSV Filename for import
"""
dirname = os.path.dirname(__file__)
csv_filename = os.path.join(dirname, './team/standings.csv')
team_df = pd.read_csv(csv_filename)
"""
Standings Data Pre Processing
"""
team_df = team_df.drop(["Unnamed: 0"], axis=1)
print(team_df)
"""
Standings CSV Filename for export
"""
csv_filename = os.path.join(dirname, './team/standings.csv')
team_df.to_csv(csv_filename, mode='w')
"""
Team Stats CSV Filename for import
"""
dirname = os.path.dirname(__file__)
csv_filename = os.path.join(dirname, './team/stats.csv')
team_df = pd.read_csv(csv_filename)
"""
Team Stats Data Pre Processing
"""
team_df = team_df.drop(["Unnamed: 0"], axis=1)
print(team_df)
"""
Team Stats CSV Filename for export
"""
csv_filename = os.path.join(dirname, './team/stats.csv')
team_df.to_csv(csv_filename, mode='w')
