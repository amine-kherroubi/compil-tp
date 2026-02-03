/*
 * PROBLÈME 13 : TABLE DES SYMBOLES
 * TYPE D'ANALYSE : SÉMANTIQUE
 * NOTION : Gestion des identificateurs et leurs types
 */
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
extern int yylex();
void yyerror(const char *s);

#define MAX_SYMBOLS 100

typedef struct {
    char name[32];
    char type[16];
    int defined;
} Symbol;

Symbol symtab[MAX_SYMBOLS];
int sym_count = 0;

int lookup(const char* name) {
    for (int i = 0; i < sym_count; i++)
        if (strcmp(symtab[i].name, name) == 0) return i;
    return -1;
}

void add_symbol(const char* name, const char* type) {
    int idx = lookup(name);
    if (idx >= 0) {
        printf("ERREUR: Variable '%s' déjà déclarée\n", name);
        return;
    }
    strcpy(symtab[sym_count].name, name);
    strcpy(symtab[sym_count].type, type);
    symtab[sym_count].defined = 1;
    printf("Symbole ajouté: %s (%s)\n", name, type);
    sym_count++;
}

void print_symtab() {
    printf("\n=== TABLE DES SYMBOLES ===\n");
    for (int i = 0; i < sym_count; i++)
        printf("%s: %s\n", symtab[i].name, symtab[i].type);
}
%}

%union { char* str; int num; }
%token <str> ID
%token <num> NUM
%token INT FLOAT ASSIGN SEMI

%%
program: stmts { print_symtab(); }
       ;

stmts: stmt | stmts stmt ;

stmt: INT ID SEMI     { add_symbol($2, "int"); }
    | FLOAT ID SEMI   { add_symbol($2, "float"); }
    | ID ASSIGN NUM SEMI {
        int idx = lookup($1);
        if (idx < 0) printf("ERREUR: '%s' non déclarée\n", $1);
        else printf("Affectation: %s = %d\n", $1, $3);
    }
    ;
%%

void yyerror(const char *s) { fprintf(stderr, "Erreur: %s\n", s); }
int main() {
    printf("=== TABLE DES SYMBOLES ===\n");
    return yyparse();
}
