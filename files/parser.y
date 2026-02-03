/*
 * PROBLÈME 15 : ANALYSE SÉMANTIQUE COMPLÈTE
 * TYPE D'ANALYSE : SÉMANTIQUE
 * NOTION : Vérifications sémantiques globales (portée, types, initialisation)
 */
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
extern int yylex();
extern int line_num;
void yyerror(const char *s);

typedef struct { char name[32]; int scope; int initialized; } Var;
Var vars[100];
int var_count = 0;
int current_scope = 0;

void enter_scope() { current_scope++; }
void exit_scope() {
    for (int i = var_count - 1; i >= 0; i--) {
        if (vars[i].scope == current_scope) var_count--;
        else break;
    }
    current_scope--;
}

int find_var(const char* n) {
    for (int i = var_count - 1; i >= 0; i--)
        if (strcmp(vars[i].name, n) == 0) return i;
    return -1;
}

void declare_var(const char* n) {
    strcpy(vars[var_count].name, n);
    vars[var_count].scope = current_scope;
    vars[var_count].initialized = 0;
    var_count++;
}

void check_initialized(const char* n) {
    int idx = find_var(n);
    if (idx < 0) printf("ERREUR: '%s' non déclarée\n", n);
    else if (!vars[idx].initialized) 
        printf("AVERTISSEMENT: '%s' utilisée avant initialisation\n", n);
}
%}

%union { char* str; int num; }
%token <str> ID
%token <num> NUM
%token INT PLUS ASSIGN SEMI LBRACE RBRACE

%%
program: stmts ;
stmts: stmt | stmts stmt ;

stmt: INT ID SEMI { declare_var($2); printf("Déclaration: %s\n", $2); }
    | ID ASSIGN NUM SEMI {
        int idx = find_var($1);
        if (idx >= 0) { vars[idx].initialized = 1; printf("Init: %s\n", $1); }
        else printf("ERREUR: '%s' non déclarée\n", $1);
    }
    | ID PLUS ID SEMI {
        check_initialized($1);
        check_initialized($3);
    }
    | LBRACE { enter_scope(); } stmts RBRACE { exit_scope(); }
    ;
%%

void yyerror(const char *s) { fprintf(stderr, "Erreur ligne %d: %s\n", line_num, s); }
int main() {
    printf("=== ANALYSE SÉMANTIQUE COMPLÈTE ===\n");
    return yyparse();
}
