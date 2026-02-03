/*
 * PROBLÈME 09 : GESTION D'ERREURS SYNTAXIQUES
 * TYPE D'ANALYSE : SYNTAXIQUE
 * NOTION : Detection et rapport d'erreurs syntaxiques
 */
%{
#include <stdio.h>
extern int yylex();
extern int line_num;
void yyerror(const char *s);
%}
%token NUM PLUS MULT SEMI
%%
program: stmts { printf("Programme syntaxiquement correct\n"); }
       ;
stmts: stmt | stmts stmt ;
stmt: expr SEMI { printf("Statement valide\n"); }
    | error SEMI { 
        printf("ERREUR récupérée à la ligne %d\n", line_num);
        yyerrok; 
      }
    ;
expr: expr PLUS term | term ;
term: term MULT factor | factor ;
factor: NUM ;
%%
void yyerror(const char *s) {
    fprintf(stderr, "ERREUR SYNTAXIQUE ligne %d: %s\n", line_num, s);
}
int main(void) {
    printf("=== GESTION D'ERREURS SYNTAXIQUES ===\n");
    printf("Token 'error' permet la récupération\n\n");
    return yyparse();
}
