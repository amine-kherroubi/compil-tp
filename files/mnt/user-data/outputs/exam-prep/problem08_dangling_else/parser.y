/*
 * PROBLÈME 08 : DANGLING ELSE
 * 
 * TYPE D'ANALYSE : SYNTAXIQUE
 * 
 * NOTION THÉORIQUE : Ambiguïté du "else" non apparié
 * 
 * LE PROBLÈME CLASSIQUE :
 * 
 *   if (cond1)
 *     if (cond2)
 *       stmt1
 *   else
 *     stmt2
 * 
 * QUESTION : À quel "if" appartient le "else" ?
 * 
 * DEUX INTERPRÉTATIONS POSSIBLES :
 * 
 * Interprétation 1 (else avec if intérieur) :
 *   if (cond1) {
 *     if (cond2)
 *       stmt1
 *     else
 *       stmt2
 *   }
 * 
 * Interprétation 2 (else avec if extérieur) :
 *   if (cond1) {
 *     if (cond2)
 *       stmt1
 *   }
 *   else
 *     stmt2
 * 
 * POURQUOI CE PROBLÈME À L'EXAMEN ?
 * - Exemple classique d'ambiguïté grammaticale
 * - Provoque conflit shift/reduce dans Bison
 * - Question fréquente : "Résolvez le dangling else"
 * 
 * GRAMMAIRE AMBIGUË :
 *   stmt -> if expr then stmt
 *        -> if expr then stmt else stmt
 *        -> ID
 * 
 * SOLUTION STANDARD :
 * Le else doit être lié au "if" le PLUS PROCHE (interprétation 1).
 * Bison le résout automatiquement en choisissant shift sur reduce.
 */

%{
#include <stdio.h>
extern int yylex();
void yyerror(const char *s);
%}

%token IF THEN ELSE TRUE FALSE ID SEMI

%%

program:
    stmt { printf("\n=== Programme analysé ===\n"); }
    ;

/*
 * GRAMMAIRE AMBIGUË - GÉNÈRE CONFLIT SHIFT/REDUCE
 * 
 * Quand le parser voit :
 *   if expr then if expr then stmt • else stmt
 *                                  ↑
 * Il doit choisir :
 * - SHIFT else (lier au if intérieur) → Correct
 * - REDUCE stmt (finir if intérieur, lier else au if extérieur) → Incorrect
 * 
 * Bison choisit SHIFT par défaut → Comportement correct
 */

stmt:
    IF expr THEN stmt ELSE stmt { 
        printf("if-then-else complet\n");
    }
    | IF expr THEN stmt {
        printf("if-then (sans else)\n");
    }
    | ID SEMI {
        printf("instruction simple\n");
    }
    ;

expr:
    TRUE { printf("condition true\n"); }
    | FALSE { printf("condition false\n"); }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Erreur: %s\n", s);
}

int main(void) {
    printf("=== PROBLÈME DU DANGLING ELSE ===\n\n");
    
    printf("CAS AMBIGU :\n");
    printf("  if C1 then if C2 then S1 else S2\n\n");
    
    printf("DEUX INTERPRÉTATIONS :\n");
    printf("  1) if C1 then (if C2 then S1 else S2)  [else avec if intérieur]\n");
    printf("  2) if C1 then (if C2 then S1) else S2  [else avec if extérieur]\n\n");
    
    printf("RÈGLE STANDARD :\n");
    printf("  Le else se lie au if le PLUS PROCHE (interprétation 1)\n\n");
    
    printf("CONFLIT SHIFT/REDUCE :\n");
    printf("  Bison doit choisir entre :\n");
    printf("    - SHIFT else (lier au if proche) → Solution retenue\n");
    printf("    - REDUCE (finir if proche) → Solution rejetée\n\n");
    
    printf("Test : if true then if false then a; else b;\n");
    printf("Attendu : else lié au deuxième if\n\n");
    
    return yyparse();
}
