#!/bin/python3

import sys

file = sys.argv[1]

with open(file) as f:
    count = 0
    for line in f:
        if line=='\n':
            count = 0
        else:
            print("%06d" % count + " " + line)
            count += len(line.split())
