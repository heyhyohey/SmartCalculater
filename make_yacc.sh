#!/bin/bash

flex $1 &&
bison -d $2
gcc -o parser lex.yy.c smart_calculator.tab.c
