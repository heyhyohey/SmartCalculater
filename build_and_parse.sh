#!/bin/bash
bison -d $2 &&
flex $1 &&
gcc -o parser lex.yy.c parser.tab.c &&
./parser $3
