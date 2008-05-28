#!/bin/bash

i=30
x=10
p=120

while true;
do
i=` echo "$i+1" | bc `
x=` echo "$x+1" | bc `
p=` echo "$p+1" | bc `

awesome_update.sh $i $p $x

if [ "$x" -gt 10 ]
then
x=0
fi


if [ "$i" -gt 30 ]
then
i=0
fi

if [ "$p" -gt 120 ]
then
p=0
fi

sleep 1
done

