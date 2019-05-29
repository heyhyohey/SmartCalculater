%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "y.tab.h"

// Simbol table entry structure
typedef struct entry {
	char symbol[512];
	int index;
	struct entry* np;
}ENTRY;

int serch(char*);
void insert(char*);
ENTRY* make_entry(char*);

ENTRY* head = NULL;
int global_index = 0;

// Search a token in the simbol table
int search(char* symbol) {
	ENTRY* current_entry = NULL;

	if(head == NULL) {
		// not matched
		return 0;
		printf("asdfasdfasdfasdf");
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

// Make a table entry
ENTRY* make_entry(char* symbol) {
	ENTRY* new_entry = malloc(sizeof(ENTRY));
	strcpy(new_entry->symbol, symbol);
	new_entry->index = ++global_index;
	new_entry->np = NULL;

	return new_entry;
}

enum tnumber {TEOF, TIF, TTHEN, TELSE, TENDIF, TPRINT,
	TASSIGN, TADD, TSUB, TMUL, TDIV, TEQUAL, TNOTEQUAL, TGREATER, TSMALLER, TGREATEROREQUAL, TSMALLEROREQUAL, TCOMMANDEND,
	TLEFTPAREN, TRIGHTPAREN, TID, TINTEGER, TSTRING, TERROR
	};
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
	int isExist = 0;
	enum tnumber tn;
	FILE* fp = NULL;

	if(argc > 1) {
		fp = fopen(argv[1], "r");
		if(fp)
			yyin = fp;
		else
			exit(1);
	}

	printf("--Token Stream\n\n");

	while((tn=yylex()) != TEOF) {
		isExist = 0;
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
				isExist = search(yytext);
				if(isExist)
					printf("%s (id, %d)\n", yytext, isExist);
				else {
					insert(yytext);
					printf("%s (id, %d)\n", yytext, global_index);
				}	
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
	ENTRY* current_entry = head;
	ENTRY* next_entry = NULL;

	printf("\n\n--id table\n\n");

	if(head == NULL)
		printf("(empty)\n");
	else {
		while(current_entry != NULL) {
			printf("(%s, %d)\n", current_entry->symbol, current_entry->index);
			current_entry = current_entry->np;
		}
	}

	current_entry = head;

	while(current_entry != NULL) {
		next_entry = current_entry->np;
		free(current_entry);
		current_entry = next_entry;
	}
	return 1;
}
