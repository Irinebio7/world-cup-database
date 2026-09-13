#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE TABLE games, teams")
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT GOALS_WINNER GOALS_OPPONENT
do
  if [[ $YEAR != year && $ROUND != round && $WINNER != winner && OPPONENT != opponent && $GOALS_WINNER != winner_goals && $GOALS_OPPONENT != opponent_goals ]]
  then
    TEAM_ID_W=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    TEAM_ID_O=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    if [[ -z $TEAM_ID_W ]]
    then
      INSERT_TEAM_RESULT_W=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ $INSERT_TEAM_RESULT_W == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $WINNER
      fi

    fi
    if [[ -z $TEAM_ID_O ]]
    then
      INSERT_TEAM_RESULT_O=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      if [[ $INSERT_TEAM_RESULT_O == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $OPPONENT
      fi
    fi
    TEAM_ID_W=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    TEAM_ID_O=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    echo $($PSQL "INSERT INTO games(winner_id, opponent_id, year, round, winner_goals, opponent_goals) VALUES($TEAM_ID_W, $TEAM_ID_O, $YEAR, '$ROUND', $GOALS_WINNER, $GOALS_OPPONENT)")
  fi
done