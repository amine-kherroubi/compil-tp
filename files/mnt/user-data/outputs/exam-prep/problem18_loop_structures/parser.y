/*
 * PROBLÈME 18 : STRUCTURES DE BOUCLES
 * TYPE D'ANALYSE : SYNTAXIQUE
 * NOTION : Boucles for, while, do-while, break, continue
 */
%{
#include <stdio.h>
extern int yylex();
void yyerror(const char *s);
int loop_depth = 0;
%}

%union { char* str; int num; }
%token <str> ID
%token <num> NUM
%token FOR WHILE DO BREAK CONTINUE
%token LT ASSIGN PLUS INCR SEMI LBRACE RBRACE LPAREN RPAREN

%%
program: stmts { printf("\nProgramme avec boucles valide\n"); }
       ;

stmts: stmt | stmts stmt ;

stmt: FOR LPAREN init SEMI cond SEMI update RPAREN {
        loop_depth++;
      } stmt {
        loop_depth--;
        printf("Boucle for\n");
      }
    | WHILE LPAREN cond RPAREN {
        loop_depth++;
      } stmt {
        loop_depth--;
        printf("Boucle while\n");
      }
    | DO {
        loop_depth++;
      } stmt WHILE LPAREN cond RPAREN SEMI {
        loop_depth--;
        printf("Boucle do-while\n");
      }
    | BREAK SEMI {
        if (loop_depth == 0) 
            printf("ERREUR: break hors de boucle\n");
        else
            printf("Break\n");
      }
    | CONTINUE SEMI {
        if (loop_depth == 0)
            printf("ERREUR: continue hors de boucle\n");
        else
            printf("Continue\n");
      }
    | LBRACE stmts RBRACE
    | ID ASSIGN NUM SEMI
    ;

init: ID ASSIGN NUM { printf("Initialisation boucle\n"); }
    ;

cond: ID LT NUM { printf("Condition boucle\n"); }
    ;

update: ID INCR { printf("Incrément boucle\n"); }
      | ID ASSIGN ID PLUS NUM
      ;
%%

void yyerror(const char *s) { fprintf(stderr, "Erreur: %s\n", s); }
int main() {
    printf("=== STRUCTURES DE BOUCLES ===\n");
    printf("Boucles supportées:\n");
    printf("- for (i=0; i<10; i++) { }\n");
    printf("- while (i<10) { }\n");
    printf("- do { } while (i<10);\n");
    printf("- break / continue\n\n");
    return yyparse();
}
