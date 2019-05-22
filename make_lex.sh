#!/bin/bash

flex $1
gcc -o smart_calculator lex.yy.c
