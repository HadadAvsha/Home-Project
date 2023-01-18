#!/bin/bash

count=0

######### POST TESTINGS
while [[ $count -lt 5 ]]; do
    curl -is --fail -X POST -H "Content-Type: application/x-www-form-urlencoded" -d "name=testing&email=test@test.com&grade=100" app:5000/submit
    ((count++))
done
echo

if [[ $(curl -is --fail -G app:5000 | grep -c 'testing') == 5 ]]; then
    echo "############## POST testing passed ####################"
else
    echo "############## POST testing FAILED ####################"
    exit 1
fi

echo
count=0

while [[ $count -lt 5 ]]; do
    curl -is --fail -X DELETE -H "Content-Type: application/x-www-form-urlencoded"  app:5000/delete/testing
    ((count++))
done

if [[ $(curl -is --fail -G app:5000 | grep -c 'testing') == 0 ]]; then
    echo "############## DELETE testing passed ####################"
else
    echo "############## DELETE testing FAILED ####################"
    exit 1
fi

echo

###  IMPLEMENT PUT TESTS
# count=0
# while [[ $count -lt 5 ]]; do
#     curl -is --fail -X DELETE -H "Content-Type: application/x-www-form-urlencoded"  app:5000/delete/testing
#     ((count++))
# done

# if [[ $(curl -is --fail -G app:5000 | grep -c 'testing') == 0 ]]; then
#     echo "############## DELETE testing passed ####################"
#     echo "$GetResult"
# else
#     echo "############## DELETE testing FAILED ####################"
# fi