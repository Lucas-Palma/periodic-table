#! /bin/bash

# PSQL query
PSQL="psql --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"

# Check if there is an argument
if [[ -z $1 ]]
then
  echo -e "Please provide an element as an argument."
  exit
else
  
  # Check if the argument is a number
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    ELEMENT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE atomic_number = '$1' ")
  # If it's a string
  else
    ELEMENT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE symbol = '$1' OR name = '$1'")
  fi
fi

# Check if the element is in the database
if [[ -z $ELEMENT ]]
then
  echo -e "I could not find that element in the database."
fi

# Print element info
if [[ -n $ELEMENT ]]
then
  echo $ELEMENT | while IFS=" |" read atomic_number name symbol type atomic_mass melting_point boiling_point
  do
    echo -e "The element with atomic number $atomic_number is $name ($symbol). It's a $type, with a mass of $atomic_mass amu. $name has a melting point of $melting_point celsius and a boiling point of $boiling_point celsius."
  done
fi

