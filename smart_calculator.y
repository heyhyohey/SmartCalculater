%{
	#include <stdio.h>
	#include <stdlib.h>
%}
%token TIF TTHEN TELSE TENDIF TPRINT
%token TASSIGN TADD TSUB TMUL TDIV TEQUAL TNOTEQUAL TGREATER TSMALLER TGREATEROREQUAL TSMALLEROREQUAL TCOMMANDEND
%token TLEFTPAREN TRIGHTPAREN
%token TID TINTEGER TSTRING
%start program
%%
start
	: program { printf("#include <stdio.h>\n\nint main()\n\{\n%d\nreturn 0;\n}\n", $$); }
	;
program
	: statements { printf("%d", $1); }
	;
statements
	: statement TCOMMANDEND { printf("%d%d", $1, $2); } 
	| statements statement TCOMMANDEND { printf("%d%d%d", $1, $2, $3); } 
	;
statement
	: if_statement
	| calculate_statement
	| print_statement
	;
print_statement
	: TPRINT TID { printf("%df(%d\\n", $1, $2); }	
	| TPRINT TSTRING { printf("%df(%d\\n)", $1, $2); }
	;
calculate_statement
	: TID TEQUAL variable operator variable
	;
variable
	: TID
	| TINTEGER { printf("%d", $1); }
	;
operator
	: TADD
	| TSUB
	| TMUL
	| TDIV
	;
if_statement
	: if_condition else_statement TENDIF
	;
if_condition
	: TIF TLEFTPAREN TID comparison TINTEGER TRIGHTPAREN TTHEN statement TID
	;
comparison
	: TEQUAL { printf("%d", $1); }
	| TNOTEQUAL { printf("%d", $1); }
	| TGREATER { printf("%d", $1); }
	| TSMALLER { printf("%d", $1); }
	| TGREATEROREQUAL { printf("%d", $1); }
	| TSMALLEROREQUAL { printf("%d", $1); }
	;
else_statement
	: TELSE statements
	;
/*
result: expr { printf("RESULT IS %f",$1);}
;
expr:
	expr '+' expr { $$=$1+$3;}
	| expr '-' expr { $$=$1-$3;}
	| expr '*' expr { $$=$1*$3;}
	| expr '/' expr { if($3==0)
						yyerror("CANNOT DIVIDE BY ZERO");
					else
						$$=$1/$3;
					}
	| '-'expr { $$=-$2;}
	| '(' expr ')' { $$=$2;}
	| NUMBER {$$=$1;}
	;
*/
%%

int main()
{
	yyparse();
	return 0;
}

void yyerror() {

}
