%{
	#include <stdio.h>
	#include <string.h>
	#include <stdlib.h>
	#define BUF_SIZE 9192
	#define TABLE_SIZE 256
	#define SYMBOL_SIZE 128

	extern FILE *yyin;
	extern int yylex();
	extern void yyerror(char const* msg);
	
	typedef struct symbol {
		char symbol[SYMBOL_SIZE];
	}SYMBOL;

	SYMBOL symbol_table[TABLE_SIZE];

	int global_index = 0;
	int symbol_number = 0;
	char buf[BUF_SIZE];

	void insert(char* symbol) {
		strcpy(symbol_table[global_index].symbol, symbol);
		global_index++;
	}

	int search(char* symbol) {
		int i = 0;
		for (i=0; i<global_index; i++) {
			if (!strcmp(symbol, symbol_table[i].symbol))
				return 1;
		}
		return 0;
	}

%}


%union
{
	char *string;
}
%token IF THEN ELSE ENDIF PRINT <string> ASSIGN <string> ADD <string> SUB <string> MUL <string> DIV
%token <string> EQUAL <string> NOTEQUAL <string> GREATER <string> SMALLER
%token <string> GREATEROREQUAL <string> SMALLEROREQUAL <string> COMMANDEND <string> LEFTPAREN <string> RIGHTPAREN
%token <string> ID
%token <string> NUMBER
%token <string> STRING

%type <string> program
%type <string> commands
%type <string> command
%type <string> statement
%type <string> if_statement
%type <string> else_statement
%type <string> print_statement
%type <string> endif_statement
%type <string> assign_statement
%type <string> condition_statement
%type <string> variable
%type <string> operator
%type <string> comparison
%type <string> condition
%type <string> multiple_print_statement
%type <string> id

%left MUL DIV
%left ADD SUB
%right ASSIGN

%start program
%%
program: commands {
		int i = 0;
		for (i=0; i<global_index; i++) {
			printf("double %s;\n", symbol_table[i].symbol);
		}
		printf("%s", $1);
	}
	;
commands: command { $$ = $1; }
	| command commands { $$ = strcat($1, $2); }
	;
command: statement{ sprintf($$, "%s", $1); }
	;
statement: if_statement COMMANDEND { $$ = $1; }
	| assign_statement COMMANDEND { sprintf($$, "%s;\n", $1); }
	| print_statement COMMANDEND { sprintf($$, "%s;", $1); }
	;
print_statement: PRINT id { sprintf($$, "printf(\"%%lf\\n\", %s)", $2); }
	| PRINT STRING { 
		strcpy(buf, $2);
		buf[strlen($2)-1] = '\0';
		sprintf($$, "printf(%s\\n\")", buf);
	}
	;
if_statement: condition_statement else_statement endif_statement { sprintf($$, "%s%s\n", $1, $2); }
	;
else_statement: ELSE print_statement { sprintf($$, "else {\n%s}", $2); }
	|ELSE multiple_print_statement { sprintf($$, "else {\n%s}", $2); }
	;
endif_statement: ENDIF {}
	;
multiple_print_statement: print_statement COMMANDEND { sprintf($$, "%s;\n", $1); }
	| print_statement COMMANDEND multiple_print_statement { sprintf(buf, "%s;\n", $1); $$ = strcat(buf, $3); }
	;
condition_statement: IF LEFTPAREN condition RIGHTPAREN THEN command { sprintf($$, "if(%s) {\n%s\n}\n", $3, $6); }
	;
condition: id comparison NUMBER { sprintf($$, "%s%s%s", $1, $2, $3); }
	;
comparison: EQUAL	{ $$ = $1; }
	| NOTEQUAL
	| GREATER
	| SMALLER
	| GREATEROREQUAL
	| SMALLEROREQUAL
	;
assign_statement: id ASSIGN variable operator variable { sprintf($$, "%s=%s%s%s", $1, $3, $4, $5); }
	;
variable: id { $$ = $1; }
	| NUMBER
	;
operator: ADD { $$ = $1; }
	| SUB
	| MUL
	| DIV
	;
id: ID { 
		if(!search($1))
			insert($1);
		$$ = $1; 
	}
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
	printf("#include <stdio.h>\n\nint main()\n{\n");

	// Read a file
	if(argc > 1)
		yyin = fopen(argv[1], "r");

	// Parse
	yyparse();

	// Print the footer
	printf("return 0;\n}\n");

	return 0;
}

