#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi
echo $($PSQL "TRUNCATE teams,games;")
# Do not change code above this line. Use the PSQL variable above to query your database.
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WG OG
do
  if [[ $YEAR != year ]]
  then
    WTEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")
    if [[ -z $WTEAM_ID ]]
    then
      #insert team
      INSERT_WTEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER');")
      if [[ INSERT_WTEAM_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted $WINNER 
      fi
      WTEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")
    fi
    OTEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")
    if [[ -z $OTEAM_ID ]]
    then
      #Insert team
      INSERT_OTEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT');")
      if [[ $INSERT_OTEAM_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted $OPPONENT
      fi
      OTEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")
    fi
    INSERT_GAMES_RESULT=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES('$YEAR','$ROUND','$WTEAM_ID','$OTEAM_ID','$WG','$OG');")
  fi
done
