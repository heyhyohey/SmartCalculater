%{
	#include <stdio.h>
	#include <string.h>
	#include <stdlib.h>
	#define BUF_SIZE 65536

	extern FILE *yyin;
	extern int yylex();
	extern void yyerror(char const* msg);
	
	// Simbol table entry structure
	typedef struct entry {
		char symbol[512];
		int index;
		struct entry* np;
	}ENTRY;

	// Initialize the simbol table
	ENTRY* head = NULL;
	int global_index = 0;
	int symbol_number = 0;
	char b1[BUF_SIZE];
	char b2[BUF_SIZE];
	char b3[BUF_SIZE];
	char b4[BUF_SIZE];

	// Make a table entry
	ENTRY* make_entry(char* symbol) {
		ENTRY* new_entry = (ENTRY*)malloc(sizeof(ENTRY));
		strcpy(new_entry->symbol, symbol);
		new_entry->index = ++global_index;
		new_entry->np = NULL;

		return new_entry;
	}

	// Search a token in the simbol table
	int search(char* symbol) {
		ENTRY* current_entry = NULL;

		if(head == NULL) {
			// not matched
			return 0;
		}
		else {
			current_entry = head;
		while(current_entry != NULL) {
			if(strcmp(current_entry->symbol, symbol) == 0)
				// matched
				return current_entry->index;
			current_entry = current_entry->np;
			}
		}
		// not matched
		return 0;
	}

	// Insert a token in the simbol table
	void insert(char* symbol) {
		ENTRY* current_entry = NULL;
		
		if(head == NULL)
			head = make_entry(symbol);
		else {
			current_entry = head;
		while(current_entry->np != NULL) {
			current_entry= current_entry->np;
			}
			current_entry->np = make_entry(symbol);
		}
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
%type <string> assign_statement
%type <string> variable
%type <string> operator
/*
%type <string> if_statement
%type <string> assign_statement
%type <string> print_statement
%type <string> printable
%type <string> command
%type <string> condition
%type <string> comparison
*/
%left MUL DIV
%left ADD SUB
%right ASSIGN

%start program
%%
program: commands {
	printf("%s", $1);
}
	;
commands: command { $$ = $1; }
	| command commands { $$ = strcat($1, $2); }
	;
command: statement COMMANDEND { sprintf($$, "%s;\n", $1); }
	;
statement: if_statement { $$ = $1; }
	| assign_statement
	;
if_statement: NUMBER { $$ = $1; }
	;
assign_statement: ID ASSIGN variable operator variable {
			symbol_number = search($1);
			printf("%s %d\n", $1, symbol_number);
			
			if(symbol_number==0)
			 	insert($1);

			sprintf($$, "%s=%s%s%s", $1, $3, $4, $5);
		}
	;
variable: ID { $$ = $1; }
	| NUMBER
	;
operator: ADD { $$ = $1; }
	| SUB
	| MUL
	| DIV
	;
/*
program: commands {
			printf("%s", $1);
		}
	;
commands: command {
			$$ = $1;
		}
	| commands command {
			$$ = strcat($1, $2);
		}
	;
command: assign_statement { $$ = $1; }
	| if_statement { $$ = $1; }
	;
if_statement: IF LEFTPAREN condition RIGHTPAREN THEN print_statement COMMANDEND ELSE commands ENDIF COMMANDEND {
			sprintf($$, "if(%s) {\n\t\t%s\n\t}\n\telse {\n%s\n}\n", $3, $6, $9);
		}
	;
print_statement: PRINT printable COMMANDEND { sprintf($$, "printf(\"%%lf\\n\", %s);\n", $2);}
	;
printable: ID { $$ = $1; }
	| STRING
	;
condition: ID comparison NUMBER	{ sprintf($$, "%s%s%s", $1, $2, $3); }
	;
comparison: EQUAL	{ $$ = $1; }
	| NOTEQUAL
	| GREATER
	| SMALLER
	| GREATEROREQUAL
	| SMALLEROREQUAL
	;
assign_statement: ID ASSIGN variable operator variable COMMANDEND	{
			symbol_number = search($1);
			if(!symbol_number)
			{
			 	insert($1);
			}
			sprintf(b2, "\t%s%s%s%s%s;\n", $1, $2, $3, $4, $5);
			$$ = b1;
			strcat($$, b2);
		 }
	;
variable:	ID { 
			symbol_number = search($1);
			if(!symbol_number)
			{
			 	insert($1);
			}
			$$ = $1;
			}
	|	NUMBER { $$ = $1; }
	;
operator:	ADD	{ $$ = $1; }
	| SUB
	| MUL
	| DIV
	;
*/
%%

int yywrap()
{
	ENTRY* current_entry = head;
	ENTRY* next_entry = NULL;
	
	// Clear heap memory
	current_entry = head;

	while(current_entry != NULL) {
		next_entry = current_entry->np;
		free(current_entry);
		current_entry = next_entry;
	}
	return 1;
}

void yyerror(char const* msg)
{
	fprintf(stderr, "%s\n", msg);
}

int main(int argc, char *argv[])
{
	ENTRY* current_entry = NULL;
	current_entry = head;

	// 1. Print the declaration part
	printf("#include <stdio.h>\n\nint main()\n{\n");

	// 2. Read a file
	if(argc > 1)
		yyin = fopen(argv[1], "r");

	// 3. Parse
	yyparse();

	// 4. Free memory
	if(head != NULL)
	{
		while(current_entry != NULL) {
			printf("\tdouble %s;\n", current_entry->symbol);
			current_entry = current_entry->np;
		}
	}

	// 5. Print the footer
	printf("\n\treturn 0;\n}");

	// 6. Close a file
	if(head != NULL)
		fclose(yyin);

	return 0;
}

