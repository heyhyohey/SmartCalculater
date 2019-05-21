%{
#include <stdio.h>
#include <stdlib.h>
enum tnumber {TEOF, TIDEN, TNUM, TASSIGN, TADD, TSEMI, TDOT, TBEGIN, TEDN, TIF, TTHEN, TPRINT, TENDIF, TELSE, TCOMMANDEND, ERROR};
%}
letter	[a-zA-Z_]
digit	[0-9]
%%
"if"									return(TIF);
"then"									return(TTHEN);
"else"									return(TELSE);
"endif"									return(TENDIF);
"print"									return(TPRINT);
";"										return(TCOMMANDEND);
[a-zA-Z]([1-9]|[1-9][0-9]|[a-zA-Z])*	return(TASSIGN);
[ \t\n]									;
%%
void main()
{
	enum tnumber tn;
	while((tn=yylex()) != TEOF) {
		switch(tn) {
			case TASSIGN:
				printf("%s (id, identifier)\n", yytext);
				break;
			case TIF:
				printf("%s (keyword if)\n", yytext);
				break;
			case TTHEN:
				printf("%s (keyword then)\n", yytext);
				break;
			case TELSE:
				printf("%s (keyword else)\n", yytext);
				break;
			case TENDIF:
				printf("%s (keyword endif)\n", yytext);
				break;
			case TPRINT:
				printf("%s (keyword print)\n", yytext);
				break;
			case TCOMMANDEND:
				printf("%s (command end)\n", yytext);
				break;
		}
	}
}

int yywrap()
{
	return 1;
}
