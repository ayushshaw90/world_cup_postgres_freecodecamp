#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo start
filename='games.csv'
cat games.csv | while IFS="," read year round winner opponent winner_goals opponenet_goals
do
if [[ $winner != "winner" ]]
then
  team_id=$($PSQL "SELECT team_id from teams where name = '$winner';")
  if [[ -z $team_id ]]
  then
    echo $($PSQL "INSERT INTO teams(name) VALUES('$winner');")
  fi
  # echo $team_id
  opp_id=$($PSQL "SELECT team_id from teams where name='$opponent';")
  if [[ -z $opp_id ]]
  then
    echo $($PSQL "INSERT INTO teams(name) VALUES('$opponent');")
  fi
fi
# echo "$year"
# echo "$round"
# echo "$winner"
# echo "$opponent"
done

cat games.csv | while IFS="," read year round winner opponent winner_goals opponent_goals
do
if [[ $winner != "winner" ]]
then
  winner_id=$($PSQL "SELECT team_id from teams WHERE name='$winner';")
  opponent_id=$($PSQL "SELECT team_id from teams WHERE name='$opponent';")
  $($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($year, '$round', $winner_id, $opponent_id, $winner_goals, $opponent_goals);")
  # echo $PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($year, '$round', $winner_id, $opponent_id, $winner_goals, $opponent_goals);"
  
fi
done

# echo $($PSQL "select * from teams;")
