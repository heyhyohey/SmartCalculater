%{
	#include <stdio.h>
	extern FILE *yyin;
	
	extern int yylex();
	extern void yyerror(char const* msg);
%}

%union
{
	char *string;
}
%token IF THEN ELSE ENDIF PRINT ASSIGN ADD SUB MUL DIV
%token EQUAL NOTEQUAL GREATER SMALLER GREATEROREQUAL SMALLEROREQUAL COMMANDEND LEFTPAREN RIGHTPAREN
%token <string> ID
%token <string> NUMBER
%token <string> STRING

%left MUL DIV
%left ADD SUB
%right ASSIGN

%start program
%%
program:
	| NUMBER { printf("#include <stdio.h>\n\nint main()\n{\n\t%s\n\treturn 0;\n}\n", $1); }
	;
%%

int yywrap()
{
	return 1;
}

void yyerror(char const* msg)
{
	fprintf(stderr, "%s\n", msg);
}

int main(int argc, char *argv[])
{
	if(argc > 1)
		yyin = fopen(argv[1], "r");
	yyparse();
	fclose(yyin);

	return 0;
}
