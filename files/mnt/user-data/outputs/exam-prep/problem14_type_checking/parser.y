/*
 * PROBLÈME 14 : VÉRIFICATION DE TYPES
 * TYPE D'ANALYSE : SÉMANTIQUE
 * NOTION : Type checking - vérification de compatibilité des types
 */
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
extern int yylex();
void yyerror(const char *s);

typedef struct { char name[32]; char type[16]; } Symbol;
Symbol symtab[100];
int sym_count = 0;

int lookup(const char* n) {
    for (int i = 0; i < sym_count; i++)
        if (strcmp(symtab[i].name, n) == 0) return i;
    return -1;
}

void add_sym(const char* n, const char* t) {
    strcpy(symtab[sym_count].name, n);
    strcpy(symtab[sym_count].type, t);
    sym_count++;
}

char* check_op(char* t1, char* t2) {
    if (strcmp(t1, t2) == 0) return t1;
    printf("ERREUR TYPE: incompatibilité %s et %s\n", t1, t2);
    return "error";
}
%}

%union { char* str; int num; double fnum; }
%token <str> ID
%token <num> NUM
%token <fnum> FNUM
%token INT FLOAT PLUS ASSIGN SEMI
%type <str> type expr

%%
program: stmts ;
stmts: stmt | stmts stmt ;

stmt: type ID SEMI { add_sym($2, $1); printf("Déclaration: %s %s\n", $1, $2); }
    | ID ASSIGN expr SEMI {
        int idx = lookup($1);
        if (idx < 0) printf("ERREUR: '%s' non déclarée\n", $1);
        else {
            char* var_type = symtab[idx].type;
            if (strcmp(var_type, $3) != 0)
                printf("ERREUR TYPE: affectation %s = %s\n", var_type, $3);
            else
                printf("OK: %s = %s\n", $1, $3);
        }
    }
    ;

type: INT { $$ = "int"; } | FLOAT { $$ = "float"; } ;

expr: NUM { $$ = "int"; }
    | FNUM { $$ = "float"; }
    | ID {
        int idx = lookup($1);
        $$ = (idx >= 0) ? symtab[idx].type : "error";
    }
    | expr PLUS expr { $$ = check_op($1, $3); }
    ;
%%

void yyerror(const char *s) { fprintf(stderr, "Erreur: %s\n", s); }
int main() {
    printf("=== VÉRIFICATION DE TYPES ===\n");
    return yyparse();
}
