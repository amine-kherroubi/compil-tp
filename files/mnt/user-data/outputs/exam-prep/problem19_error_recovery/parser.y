/*
 * PROBLÈME 19 : RÉCUPÉRATION D'ERREURS
 * TYPE D'ANALYSE : SYNTAXIQUE
 * NOTION : Error recovery avec token 'error'
 */
%{
#include <stdio.h>
extern int yylex();
extern int line_num;
void yyerror(const char *s);
int error_count = 0;
%}

%token NUM PLUS MULT SEMI

%%
program: stmts { 
    if (error_count > 0)
        printf("\n%d erreur(s) détectée(s) mais récupération réussie\n", error_count);
    else
        printf("\nProgramme correct\n");
}
;

stmts: stmt | stmts stmt ;

/* Récupération au niveau statement */
stmt: expr SEMI { printf("Statement OK ligne %d\n", line_num); }
    | error SEMI {
        printf("ERREUR récupérée ligne %d - continue parsing\n", line_num);
        error_count++;
        yyerrok;
      }
    | error {
        printf("ERREUR grave ligne %d\n", line_num);
        error_count++;
        yyclearin;
      }
    ;

expr: expr PLUS term | term ;
term: term MULT factor | factor ;
factor: NUM ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Erreur syntaxique ligne %d: %s\n", line_num, s);
}

int main() {
    printf("=== RÉCUPÉRATION D'ERREURS ===\n");
    printf("Le parser tentera de récupérer après erreurs\n");
    printf("Token 'error' permet de continuer l'analyse\n\n");
    return yyparse();
}
