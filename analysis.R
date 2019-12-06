library(data.table)
library(ggplot2)
library(ggthemes)
library(readr)
library(dplyr)
library(stringr)
library(doBy)

######
## NBA Salary Cap Data Frame
## 36 ROWS, 2 Variables
######
salary_cap_df <- read.csv("datasets/salary/cap.csv", stringsAsFactors=FALSE)

# Salary Cap Year Factor를 Ordered Factor로 변환
salary_cap_df$year <- factor(salary_cap_df$year)
salary_cap_df$year <- ordered(salary_cap_df$year)

# 84년도부터 89까지 데이터 지우기
salary_cap_df <- salary_cap_df[which(salary_cap_df$year > "1989-90"),]

# Dollor sign string to Number
salary_cap_df$salary_cap <- parse_number(salary_cap_df$salary_cap)

######
## NBA Team Salary Data Frame
## 30 ROWS, 31 Variables
######
team_salary_df <- read.csv("datasets/salary/team.csv", stringsAsFactors=FALSE)

# Salary Year Factor를 Ordered Factor로 변환
team_salary_df$year <- factor(team_salary_df$year)
team_salary_df$year <- ordered(team_salary_df$year)
team_salary_df

######
## NBA Team Standings Data Frame
## 876 ROWS, 83 Variables
######
team_standings_df <- read.csv("datasets/team/standings.csv", stringsAsFactors=FALSE)

######
## 1. 년도별 팀 샐러리에 따른 팀 순위 변화와 샐리러 캡 곡선
## - 년도별 순위 1등 팀의 샐러리 변화
## - 년도별 순위 꼴등 팀의 샐러리 변화
######

####
## 전처리 과정 시작
####
# 년도별 팀 샐러리 Plotting을 위한 데이터 처리
# - YEAR, TEAM, SALARY
team_salary_df_for_plot <- data.frame(stringsAsFactors=FALSE)
for (i in colnames(team_salary_df[,-1])){
  team_salary <- data.frame(year=team_salary_df[,1], team=rep(i, 30), salary=team_salary_df[[i]], stringsAsFactors=FALSE)
  team_salary_df_for_plot <- rbind(team_salary_df_for_plot, team_salary)
}

# factorize team variables
team_salary_df_for_plot$team <- factor(team_salary_df_for_plot$team)

# Conversion Dollor to Number
team_salary_df_for_plot$salary <- parse_number(team_salary_df_for_plot$salary)

# SALARY CAP MIN 10000000, MAX 150000000 스케일 조정
salary_cap_df_for_plot <- salary_cap_df
salary_cap_df_for_plot$salary_cap <- salary_cap_df_for_plot$salary_cap / 10000000
team_salary_df_for_plot$salary <- team_salary_df_for_plot$salary / 10000000
####
## 전처리 과정 종료
####

# ****** 30개 팀의 30년 동안의 샐러리 변동 추이 데이터 시각화
ggplot(data=team_salary_df_for_plot, aes(x=year, y=salary)) +
  geom_line(data=team_salary_df_for_plot, aes(x=year, y=salary, colour=team, group=1)) +
  geom_line(data=salary_cap_df_for_plot, aes(x=year, y=salary_cap, group=1), colour="red", size=1) +
  coord_cartesian(ylim=c(0, 15)) +
  xlab('SEASONS') +
  ylab('SALARY') +
  ggtitle('30 YEARS TEAM SALARIES AND SALARY CAP LINE')

# 30시즌 간 해당 시즌 성적 최상위 팀들의 샐러리 변동 추이
# 30시즌 간 해당 시즌 성적 최하위 팀들의 샐러리 변동 추이 분석

####
## 전처리 과정 시작
####

# 년도 별 최상위 팀 승률, 경기당 득점순으로 선택
highest_team_standings_df_for_plot <- team_standings_df %>%
  group_by(SeasonID) %>%
  arrange(SeasonID, desc(WinPCT)) %>%
  top_n(n=1, wt=WinPCT) %>%
  select(WinPCT, SeasonID, TeamName, PointsPG)

highest_team_standings_df_for_plot <- highest_team_standings_df_for_plot %>%
  group_by(SeasonID) %>%
  arrange(SeasonID, desc(PointsPG)) %>%
  top_n(n=1, wt=PointsPG)

# 년도 별 최하위 팀 승률, 경기당 득점순으로 선택
lowest_team_standings_df_for_plot <- team_standings_df %>%
  group_by(SeasonID) %>%
  arrange(SeasonID, WinPCT) %>%
  top_n(n=-1, wt=WinPCT) %>%
  select(WinPCT, SeasonID, TeamName, PointsPG)

lowest_team_standings_df_for_plot <- lowest_team_standings_df_for_plot %>%
  group_by(SeasonID) %>%
  arrange(SeasonID, PointsPG) %>%
  top_n(n=-1, wt=PointsPG)

# 데이터 프레임 간 팀 이름 맞추기
mapped_team_names <- c(
  "Hawks", "Celtics", "Nets",
  "Hornets", "Bulls", "Cavaliers",
  "Mavericks", "Nuggets", "Pistons",
  "Warriors", "Rockets", "Pacers",
  "Clippers", "Lakers", "Grizzlies",
  "Heat", "Bucks", "Timberwolves", "Pelicans",
  "Knicks", "Thunder", "Magic", "76ers", "Suns", "Trail Blazers", "Kings",
  "Spurs", "Raptors", "Jazz", "Wizards"
)
team_names <- unique(team_salary_df_for_plot$team)
team_names <- as.character(team_names)
team_names_map_df <- data.frame(find=team_names, replace=mapped_team_names)

formatted_team_salary_df_for_plot <- team_salary_df_for_plot
converted_team_names <- as.character(team_names_map_df[match(formatted_team_salary_df_for_plot$team, team_names_map_df$find), "replace"])
formatted_team_salary_df_for_plot$team <- converted_team_names
formatted_team_salary_df_for_plot$team <- factor(formatted_team_salary_df_for_plot$team)

# Convert SeasonID to year 전처리 + Team Name
lowest_team_standings_df_for_plot$year <- as.character(lowest_team_standings_df_for_plot$SeasonID)
lowest_team_standings_df_for_plot$year <- substr(lowest_team_standings_df_for_plot$year, 2, 5)
lowest_team_standings_df_for_plot$year <- as.numeric(lowest_team_standings_df_for_plot$year)
lowest_team_standings_df_for_plot$year2 <- lowest_team_standings_df_for_plot$year + 1
lowest_team_standings_df_for_plot$year2 <- as.character(lowest_team_standings_df_for_plot$year2)
lowest_team_standings_df_for_plot$year <- paste(as.character(lowest_team_standings_df_for_plot$year), "-", substr(lowest_team_standings_df_for_plot$year2, 3, 4), sep='')

highest_team_standings_df_for_plot$year <- as.character(highest_team_standings_df_for_plot$SeasonID)
highest_team_standings_df_for_plot$year <- substr(highest_team_standings_df_for_plot$year, 2, 5)
highest_team_standings_df_for_plot$year <- as.numeric(highest_team_standings_df_for_plot$year)
highest_team_standings_df_for_plot$year2 <- highest_team_standings_df_for_plot$year + 1
highest_team_standings_df_for_plot$year2 <- as.character(highest_team_standings_df_for_plot$year2)
highest_team_standings_df_for_plot$year <- paste(as.character(highest_team_standings_df_for_plot$year), "-", substr(highest_team_standings_df_for_plot$year2, 3, 4), sep='')

lowest_team_standings_df_for_plot$year <- factor(lowest_team_standings_df_for_plot$year)
lowest_team_standings_df_for_plot$year <- ordered(lowest_team_standings_df_for_plot$year)

highest_team_standings_df_for_plot$year <- factor(highest_team_standings_df_for_plot$year)
highest_team_standings_df_for_plot$year <- ordered(highest_team_standings_df_for_plot$year)

lowest_team_standings_df_for_plot[22, "TeamName"] <- "Hornets"
highest_team_standings_df_for_plot[4, "TeamName"] <- "Thunder"

# TEAM SALARY DF + STANDINGS DF MERGE
lowest_team_standings_df_for_plot$team <- lowest_team_standings_df_for_plot$TeamName
lowest_team_standings_df_for_plot <- merge(lowest_team_standings_df_for_plot, formatted_team_salary_df_for_plot, by = c('year', 'team'))

highest_team_standings_df_for_plot$team <- highest_team_standings_df_for_plot$TeamName
highest_team_standings_df_for_plot <- merge(highest_team_standings_df_for_plot, formatted_team_salary_df_for_plot, by = c('year', 'team'))

####
## 전처리 과정 종료
####

ggplot() +
  geom_line(data=lowest_team_standings_df_for_plot, aes(x=year, y=salary, group=1), colour="green") +
  geom_line(data=highest_team_standings_df_for_plot, aes(x=year, y=salary, group=1), colour="blue") +
  geom_line(data=salary_cap_df_for_plot, aes(x=year, y=salary_cap, group=1), colour="red", size=1) +
  coord_cartesian(ylim=c(0, 15)) +
  xlab('SEASONS') +
  ylab('SALARY') +
  ggtitle('30 YEARS HIGHEST AND LOWEST SALARY CAP LINE')


######
## 팀 샐러리와 팀 순위 상관 분석
######

###
## 전처리 과정 시작
###
cor_team_standings_df <- team_standings_df
cor_team_standings_df$team <- cor_team_standings_df$TeamName

cor_team_standings_df$year <- as.character(cor_team_standings_df$SeasonID)
cor_team_standings_df$year <- substr(cor_team_standings_df$year, 2, 5)
cor_team_standings_df$year <- as.numeric(cor_team_standings_df$year)
cor_team_standings_df$year2 <- cor_team_standings_df$year + 1
cor_team_standings_df$year2 <- as.character(cor_team_standings_df$year2)
cor_team_standings_df$year <- paste(as.character(cor_team_standings_df$year), "-", substr(cor_team_standings_df$year2, 3, 4), sep='')

cor_team_standings_df <- merge(cor_team_standings_df, formatted_team_salary_df_for_plot, by = c('year', 'team'))
###
## 전처리 과정 종료
###

plot(cor_team_standings_df$WinPCT~cor_team_standings_df$salary, main="Correlation TEAM Salary ~ Win Rate", xlab="Salary", ylab="Win Rates", cex=1, pch=1, col="red")
cor(cor_team_standings_df$WinPCT, cor_team_standings_df$salary, use='complete.obs', method='pearson')

######
## 2. 플레이어 샐러리에 따른 플레이어 성적(FG_PCT) 변화
######

######
## NBA Player Stat Salary Data Frame
## 85878 ROWS, 41 Variables
######
player_stat_df <- read.csv("datasets/player/completed_stat.csv", stringsAsFactors=FALSE)

player_stat_df$year <- player_stat_df$SEASON_ID

# Salary Year Factor를 Ordered Factor로 변환
player_stat_df$SEASON_ID <- factor(player_stat_df$year)
player_stat_df$year <- ordered(player_stat_df$year)

# Transform Dollor sign to Number
player_stat_df$SALARY <- parse_number(player_stat_df$SALARY)

# Remove NA on SALARY COLUMN + Sampling for Correlation
# PLAYER_AGE 별로 균등 샘플링
# 통계의 함정: 연봉이 낮은 선수는 게임 수가 적으며(표본), 슛 성공확률이 상대적으로 높을 수 있다. GAME 수 40경기 이상으로 FILTER
sampling_player_stat_df <- player_stat_df[!is.na(player_stat_df$SALARY),]
sampling_player_stat_df %>% filter(GP >= 40) -> sampling_player_stat_df
sampling_player_stat_df <- sampleBy(~PLAYER_AGE, frac=0.2, replace=FALSE, data=sampling_player_stat_df)

## 상관관계 시각화
plot(sampling_player_stat_df$FG_PCT~sampling_player_stat_df$SALARY, main="Correlation Salary ~ FG PCT", xlab="Salary", ylab="FG PCT", cex=1, pch=1, col="red")
cor(sampling_player_stat_df$FG_PCT, sampling_player_stat_df$SALARY, use='complete.obs', method='pearson')

### 년도별 LOWEST FG_PCT, HIGHEST FG_PCT (게임 수 40경기 이상 + SALARY 정보가 있는 선수 한정으로 FILTER)
lowest_player_stat_df <- player_stat_df %>%
  group_by(SEASON_ID) %>%
  arrange(SEASON_ID, desc(FG_PCT)) %>%
  filter(GP >= 40 & !is.na(SALARY)) %>%
  top_n(n=-1, wt=FG_PCT) %>%
  select(FG_PCT, SEASON_ID, PLAYER_ID, SALARY)

highest_player_stat_df <- player_stat_df %>%
  group_by(SEASON_ID) %>%
  arrange(SEASON_ID, desc(FG_PCT)) %>%
  filter(GP >= 40 & !is.na(SALARY)) %>%
  top_n(n=1, wt=FG_PCT) %>%
  select(FG_PCT, SEASON_ID, PLAYER_ID, SALARY)

### 년도별 평균 연봉
avg_player_stat <- player_stat_df %>%
  filter(GP >= 40 & !is.na(SALARY)) %>%
  group_by(SEASON_ID) %>%
  summarise(MEAN_SALARY=mean(SALARY, na.rm=TRUE))

ggplot() +
  geom_line(data=lowest_player_stat_df, aes(x=SEASON_ID, y=SALARY, group=1), colour="green") +
  geom_line(data=highest_player_stat_df, aes(x=SEASON_ID, y=SALARY, group=1), colour="blue") +
  geom_line(data=avg_player_stat, aes(x=SEASON_ID, y=MEAN_SALARY, group=1), colour="red", size=1) +
  xlab('SEASONS') +
  ylab('SALARY') +
  ggtitle('30 YEARS HIGHEST AND LOWEST PLAYER SALARY LINE')

######
## 3. 연도별 샐러리 평균과 평균 성적
######

###
## 전처리 과정 시작
###
avg_player_stat_per_season_df <- player_stat_df %>%
  filter(!is.na(SALARY)) %>%
  group_by(SEASON_ID) %>%
  summarise(MEAN_SALARY=mean(SALARY, na.rm=TRUE), MEAN_FG_PCT=mean(FG_PCT, na.rm=TRUE))
###
## 전처리 과정 종료
###

# 연도별 샐러리 평균 
ggplot(data=avg_player_stat_per_season_df, aes(x=SEASON_ID, y=MEAN_SALARY, fill=SEASON_ID)) +
  geom_bar(stat='identity') +
  guides(fill=FALSE) +
  theme_wsj()

# 연도별 평균 성적 막대 그래프
ggplot(data=avg_player_stat_per_season_df, aes(x=SEASON_ID, y=MEAN_FG_PCT, fill=SEASON_ID)) +
  geom_bar(stat='identity') +
  coord_cartesian(ylim=c(0.4, 0.5)) +
  guides(fill=FALSE) +
  theme_wsj()




