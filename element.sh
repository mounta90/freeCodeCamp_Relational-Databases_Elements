#!/bin/bash

MAIN() {
  if [[ -z $1 ]]
  then
    # if no element is passed in:
    EXIT "Please provide an element as an argument."
  else
    # else (element is passed in):
    ELEMENT_DATA=$1

    PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

    # check if what is passed in is an element:

    if [[ $ELEMENT_DATA =~ ^[0-9]+$ ]]
    then
      # if data is a number, test for the atomic number:
      ELEMENT=$($PSQL "SELECT * FROM elements WHERE atomic_number = $ELEMENT_DATA;")

      if [[ -z $ELEMENT ]]
      then
        echo "I could not find that element in the database."
      else
        ATOMIC_NUMBER=$(echo $ELEMENT | sed -E 's.([0-9]+)\|([a-z]+)\|([a-z]+).\1.gi')
        SYMBOL=$(echo $ELEMENT | sed -E 's.([0-9]+)\|([a-z]+)\|([a-z]+).\2.gi')
        NAME=$(echo $ELEMENT | sed -E 's.([0-9]+)\|([a-z]+)\|([a-z]+).\3.gi')
        TYPE=$($PSQL "SELECT type FROM properties FULL JOIN elements USING(atomic_number) FULL JOIN types USING(type_id) WHERE atomic_number=$ATOMIC_NUMBER;")
        ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties FULL JOIN elements USING(atomic_number) FULL JOIN types USING(type_id) WHERE atomic_number=$ATOMIC_NUMBER;")
        MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties FULL JOIN elements USING(atomic_number) FULL JOIN types USING(type_id) WHERE atomic_number=$ATOMIC_NUMBER;")
        BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties FULL JOIN elements USING(atomic_number) FULL JOIN types USING(type_id) WHERE atomic_number=$ATOMIC_NUMBER;")

        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
      fi

    else
      # else (data is not a number), test for both the symbol and the name:
      ELEMENT=$($PSQL "SELECT * FROM elements WHERE symbol = '$ELEMENT_DATA' OR name = '$ELEMENT_DATA';")

      if [[ -z $ELEMENT ]]
      then
        echo "I could not find that element in the database."
      else
        ATOMIC_NUMBER=$(echo $ELEMENT | sed -E 's.([0-9]+)\|([a-z]+)\|([a-z]+).\1.gi')
        SYMBOL=$(echo $ELEMENT | sed -E 's.([0-9]+)\|([a-z]+)\|([a-z]+).\2.gi')
        NAME=$(echo $ELEMENT | sed -E 's.([0-9]+)\|([a-z]+)\|([a-z]+).\3.gi')
        TYPE=$($PSQL "SELECT type FROM properties FULL JOIN elements USING(atomic_number) FULL JOIN types USING(type_id) WHERE atomic_number=$ATOMIC_NUMBER;")
        ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties FULL JOIN elements USING(atomic_number) FULL JOIN types USING(type_id) WHERE atomic_number=$ATOMIC_NUMBER;")
        MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties FULL JOIN elements USING(atomic_number) FULL JOIN types USING(type_id) WHERE atomic_number=$ATOMIC_NUMBER;")
        BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties FULL JOIN elements USING(atomic_number) FULL JOIN types USING(type_id) WHERE atomic_number=$ATOMIC_NUMBER;")

        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
      fi

    fi

  fi
}

EXIT() {
  echo "$1"
}

MAIN $1
