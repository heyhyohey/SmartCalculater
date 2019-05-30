%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "smart_calculator.tab.h"

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
/*
enum tnumber {TEOF, TIF, TTHEN, TELSE, TENDIF, TPRINT,
	TASSIGN, TADD, TSUB, TMUL, TDIV, TEQUAL, TNOTEQUAL, TGREATER, TSMALLER, TGREATEROREQUAL, TSMALLEROREQUAL, TCOMMANDEND,
	TLEFTPAREN, TRIGHTPAREN, TID, TINTEGER, TSTRING, TERROR
	};
*/
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
