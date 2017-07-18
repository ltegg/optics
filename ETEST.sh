#!/bin/bash

more STDOUT | grep ETEST | grep '[/.0-9]*' -o > ETEST.txt

python3 ~/sh/ETEST.py

eog ETEST.png &

exit 0
