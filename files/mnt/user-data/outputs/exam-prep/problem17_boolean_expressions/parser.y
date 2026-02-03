/*
 * PROBLÈME 17 : EXPRESSIONS BOOLÉENNES
 * TYPE D'ANALYSE : SYNTAXIQUE + SÉMANTIQUE
 * NOTION : Logique booléenne, priorité des opérateurs logiques
 */
%{
#include <stdio.h>
extern int yylex();
void yyerror(const char *s);
%}

%token TRUE FALSE AND OR NOT LPAREN RPAREN

%%
program: expr { printf("\nExpression booléenne valide\n"); }
       ;

/* Priorité : NOT > AND > OR */
expr: expr OR and_expr   { printf("OR\n"); }
    | and_expr
    ;

and_expr: and_expr AND not_expr { printf("AND\n"); }
        | not_expr
        ;

not_expr: NOT not_expr { printf("NOT\n"); }
        | primary
        ;

primary: TRUE           { printf("TRUE\n"); }
       | FALSE          { printf("FALSE\n"); }
       | LPAREN expr RPAREN { printf("Parenthèses\n"); }
       ;
%%

void yyerror(const char *s) { fprintf(stderr, "Erreur: %s\n", s); }
int main() {
    printf("=== EXPRESSIONS BOOLÉENNES ===\n");
    printf("Priorité: NOT > AND > OR\n");
    printf("Exemples:\n");
    printf("- true and false\n");
    printf("- not true or false\n");
    printf("- (true or false) and not true\n\n");
    return yyparse();
}
