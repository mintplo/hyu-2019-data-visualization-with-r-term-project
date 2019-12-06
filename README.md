## [HYU] 2019_2학기_R과자료시각화_TERM_PROJECT

## 개발환경설정 (based on MacOSX)
### 🔥 Requirements
- [Python 3.7](https://www.python.org/)
- [Pipenv](https://github.com/pypa/pipenv)
- [R Language](https://www.r-project.org/)
- [R Studio](https://www.rstudio.com/products/rstudio/download/)

#### 1. R Language 설치

Mac OSX의 패키지 매니저인 Homebrew를 이용해 설치한다.
```
$ brew install r (high sierra 버전부터 가능, 이전 버전은 아래의 URL 참조)
```
https://stackoverflow.com/questions/20457290/installing-r-with-homebrew

#### 2. R Studio 설치 

R Studio IDE *Standalone 설치 가능*

#### 3. Pipenv 설치

Mac OSX의 패키지 매니저인 Homebrew를 이용해 설치한다.
```
$ brew install pipenv
```

### 📦 Libraries
- [Python Pandas](https://pandas.pydata.org/)
- [NBA REST API(UnOfficial)](https://pypi.org/project/nba-api/)
- [Beautiful Soup](https://www.crummy.com/software/BeautifulSoup/)

## Specification

### Object

> 벤 프라이(Ben Fry)의 데이터 시각화 프로세스 7단계를 참고하여 데이터 획득, 데이터 전처리, 분석, 시각화 과정을 작성 

1. 정보 획득
2. 분해
3. 선별
4. 마이닝
5. 표현
6. 정제
7. 상호작용

NBA 팀, 선수, 급여 정보를 이용해 아래의 상관관계를 분석

- 년도별 팀 순위와 팀 샐러리의 연관성
- 년도별 선수 성적과 선수 샐러리의 연관성
- 년도별 선수 평균 성적과 선수 평균 샐러리 분포

### Data Analysis

1. Basketball Reference, NBA Official Sites, Hoopshype 사이트의 데이터를 획득 (크롤링, REST)

2. 분석을 위해 데이터를 전처리

3. EDA 실시

4. 데이터 마이닝

5. 시각화 표현

## 🔥 Running

#### 1. Pipenv를 이용해 의존성 패키지 설치 (Optional)

```
$ pipenv install
```

#### 2. 데이터 크롤링, 정제 작업 실시 (Optional)

```
$ python parser/path/python_file.py
```

#### 3. R 코드 실행

&nbsp;
--------

The source code of *mintplo* is primarily distributed under the terms
of the [GNU Affero General Public License v3.0] or any later version. See
[COPYRIGHT] for details.

[GNU Affero General Public License v3.0]: LICENSE
[COPYRIGHT]: COPYRIGHT
