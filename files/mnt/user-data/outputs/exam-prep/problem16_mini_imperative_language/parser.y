/*
 * PROBLÈME 16 : MINI-LANGAGE IMPÉRATIF
 * TYPE D'ANALYSE : SYNTAXIQUE + SÉMANTIQUE
 * NOTION : Langage complet avec variables, conditions, boucles
 */
%{
#include <stdio.h>
extern int yylex();
void yyerror(const char *s);
%}

%union { char* str; int num; }
%token <str> ID
%token <num> NUM
%token INT IF ELSE WHILE RETURN
%token EQ LT ASSIGN PLUS MINUS SEMI LBRACE RBRACE LPAREN RPAREN

%%
program: stmts { printf("\nProgramme valide\n"); }
       ;

stmts: stmt | stmts stmt ;

stmt: INT ID SEMI                          { printf("Déclaration: %s\n", $2); }
    | ID ASSIGN expr SEMI                  { printf("Affectation: %s\n", $1); }
    | IF LPAREN cond RPAREN stmt           { printf("If statement\n"); }
    | IF LPAREN cond RPAREN stmt ELSE stmt { printf("If-else statement\n"); }
    | WHILE LPAREN cond RPAREN stmt        { printf("While loop\n"); }
    | RETURN expr SEMI                     { printf("Return statement\n"); }
    | LBRACE stmts RBRACE                  { printf("Block\n"); }
    ;

cond: expr EQ expr  { printf("Comparaison ==\n"); }
    | expr LT expr  { printf("Comparaison <\n"); }
    ;

expr: expr PLUS term  { printf("Addition\n"); }
    | expr MINUS term { printf("Soustraction\n"); }
    | term
    ;

term: NUM | ID ;

%%
void yyerror(const char *s) { fprintf(stderr, "Erreur: %s\n", s); }
int main() {
    printf("=== MINI-LANGAGE IMPÉRATIF ===\n");
    printf("Instructions supportées:\n");
    printf("- Déclarations: int x;\n");
    printf("- Affectations: x = 5;\n");
    printf("- Conditions: if (x < 10) { }\n");
    printf("- Boucles: while (x < 10) { }\n");
    printf("- Return: return x;\n\n");
    return yyparse();
}
