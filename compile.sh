#!/bin/bash

set -e

bison -d puckparser.y
flex puckparser.l
g++ puckparser.tab.c lex.yy.c -o puckparser.ex