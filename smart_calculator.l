%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Simbol table entry structure
typedef struct entry {
	char* symbol;
	int index;
	struct entry* np;
}ENTRY;

// Simbol table structure
typedef struct symbol_table {
	ENTRY* head;
}SYMBOL_TABLE;

// Search a token in the simbol table
int search(char* token) {
	int result = 0;
	ENTRY* ne = NULL;

	if(st->head == NULL)
		// not matched
		return 0;
	else
		ne = head;
		while(ne != NULL) {
			if(strcmp(ne->symbol, token) == 0)
				// matched
				return 1;
			ne = ne->np;
	// not matched
	return 0;
}

// Insert a token in the simbol table
void insert(char* token) {
	
}

// Make a table entry
ENTRY* make_entry(char* symbol, int 

enum tnumber {TEOF, TIF, TTHEN, TELSE, TENDIF, TPRINT,
	TASSIGN, TADD, TSUB, TMUL, TDIV, TEQUAL, TNOTEQUAL, TGREATER, TSMALLER, TGREATEROREQUAL, TSMALLEROREQUAL, TCOMMANDEND,
	TLEFTPAREN, TRIGHTPAREN, TID, TINTEGER, TSTRING, TERROR
	};

SYMBOL_TABLE st;

%}
%%
"if"				return(TIF);
"then"				return(TTHEN);
"else"				return(TELSE);
"endif"				return(TENDIF);
"print"				return(TPRINT);
"="					return(TASSIGN);
"+"					return(TADD);
"-"					return(TSUB);
"*"					return(TMUL);
"/"					return(TDIV);
"=="				return(TEQUAL);
"!="				return(TNOTEQUAL);
">"					return(TGREATER);
"<"					return(TSMALLER);
">="				return(TGREATEROREQUAL);
"<="				return(TSMALLEROREQUAL);
";"					return(TCOMMANDEND);
"("					return(TLEFTPAREN);
")"					return(TRIGHTPAREN);
[a-zA-Z][a-zA-Z0-9]*									return(TID);
[1-9][0-9]*|\.[0-9]*|[1-9][0-9]\.|[1-9][0-9]*\.[0-9]*	return(TINTEGER);
\"(\\.|[^\\"\n])*\"										return(TSTRING);
[ \t\n]				;
%%
void main(int argc, char *argv[])
{
	enum tnumber tn;
	FILE* fp = NULL;
	
	st.

	if(argc > 1) {
		fp = fopen(argv[1], "r");
		if(fp)
			yyin = fp;
		else
			exit(1);
	}
	while((tn=yylex()) != TEOF) {
		switch(tn) {
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
			case TASSIGN:
				printf("%s (assign)\n", yytext);
				break;
			case TADD:
				printf("%s (add)\n", yytext);
				break;
			case TSUB:
				printf("%s (subtract)\n", yytext);
				break;
			case TMUL:
				printf("%s (multiply)\n", yytext);
				break;
			case TDIV:
				printf("%s (divide)\n", yytext);
				break;
			case TEQUAL:
				printf("%s (equal)\n", yytext);
				break;
			case TNOTEQUAL:
				printf("%s (not equal)\n", yytext);
				break;
			case TGREATER:
				printf("%s (greater)\n", yytext);
				break;
			case TSMALLER:
				printf("%s (smaller)\n", yytext);
				break;
			case TGREATEROREQUAL:
				printf("%s (greater or equal)\n", yytext);
				break;
			case TSMALLEROREQUAL:
				printf("%s (smaller or equal)\n", yytext);
				break;
			case TCOMMANDEND:
				printf("%s (command end)\n", yytext);
				break;
			case TLEFTPAREN:
				printf("%s (left paren)\n", yytext);
				break;
			case TRIGHTPAREN:
				printf("%s (right paren)\n", yytext);
				break;
			case TID:
				printf("%s (id, index)\n", yytext);
				break;
			case TINTEGER:
				printf("%s (real number)\n", yytext);
				break;
			case TSTRING:
				printf("%s (string)\n", yytext);
				break;
		}
	}
}

int yywrap()
{
	return 1;
}
