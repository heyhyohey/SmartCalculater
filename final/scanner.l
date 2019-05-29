%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "parser.tab.h"

extern int yyparse();
%}

%%
"if"				{ return(IF); }
"then"				{ return(THEN); }
"else"				{ return(ELSE); }
"endif"				{ return(ENDIF); }
"print"				{ return(PRINT); }
"="					{ return(ASSIGN); }
"+"					{ return(ADD); }
"-"					{ return(SUB); }
"*"					{ return(MUL); }
"/"					{ return(DIV); }
"=="				{ return(EQUAL); }
"!="				{ return(NOTEQUAL); }
">"					{ return(GREATER); }
"<"					{ return(SMALLER); }
">="				{ return(GREATEROREQUAL); }
"<="				{ return(SMALLEROREQUAL); }
";"					{ return(COMMANDEND); }
"("					{ return(LEFTPAREN); }
")"					{ return(RIGHTPAREN); }
[a-zA-Z][a-zA-Z0-9]*									{ yylval.string = strdup(yytext); return(ID); }
[1-9][0-9]*|\.[0-9]*|[1-9][0-9]\.|[1-9][0-9]*\.[0-9]*	{ yylval.string = strdup(yytext); return(NUMBER); }
\"(\\.|[^\\"\n])*\"										{ yylval.string = strdup(yytext); return(STRING); }
[ \t\n]				;
%%
