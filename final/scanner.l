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
"="					{ yylval.string = strdup(yytext); return(ASSIGN); }
"+"					{ yylval.string = strdup(yytext); return(ADD); }
"-"					{ yylval.string = strdup(yytext); return(SUB); }
"*"					{ yylval.string = strdup(yytext); return(MUL); }
"/"					{ yylval.string = strdup(yytext); return(DIV); }
"=="				{ yylval.string = strdup(yytext); return(EQUAL); }
"!="				{ yylval.string = strdup(yytext); return(NOTEQUAL); }
">"					{ yylval.string = strdup(yytext); return(GREATER); }
"<"					{ yylval.string = strdup(yytext); return(SMALLER); }
">="				{ yylval.string = strdup(yytext); return(GREATEROREQUAL); }
"<="				{ yylval.string = strdup(yytext); return(SMALLEROREQUAL); }
";"					{ return(COMMANDEND); }
"("					{ return(LEFTPAREN); }
")"					{ return(RIGHTPAREN); }
[a-zA-Z][a-zA-Z0-9]*									{ yylval.string = strdup(yytext); return(ID); }
[1-9][0-9]*|\.[0-9]*|[1-9][0-9]\.|[1-9][0-9]*\.[0-9]*	{ yylval.string = strdup(yytext); return(NUMBER); }
\"(\\.|[^\\"\n])*\"										{ yylval.string = strdup(yytext); return(STRING); }
[ \t\n]				;
%%
