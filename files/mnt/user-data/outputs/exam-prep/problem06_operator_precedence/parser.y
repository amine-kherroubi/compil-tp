/*
 * PROBLÈME 06 : PRIORITÉ DES OPÉRATEURS
 * 
 * TYPE D'ANALYSE : SYNTAXIQUE
 * 
 * NOTION THÉORIQUE : Priorité (précédence) des opérateurs
 * 
 * DÉFINITION :
 * La priorité détermine l'ordre d'évaluation des opérateurs dans une expression.
 * Opérateurs haute priorité sont évalués AVANT ceux de basse priorité.
 * 
 * PRIORITÉS MATHÉMATIQUES STANDARD :
 * 1. Parenthèses ( )       - Plus haute
 * 2. * et /                - Moyenne
 * 3. + et -                - Plus basse
 * 
 * POURQUOI CE PROBLÈME À L'EXAMEN ?
 * - Fondamental : 2 + 3 * 4 doit donner 14, pas 20
 * - Question fréquente : "Ajoutez la priorité correcte"
 * - Erreur classique : tous les opérateurs au même niveau
 * 
 * ERREURS CLASSIQUES :
 * 1. Mettre tous les opérateurs dans une seule règle (pas de priorité)
 * 2. Inverser l'ordre des non-terminaux (basse priorité en haut)
 * 3. Oublier les parenthèses
 * 
 * SOLUTION : HIÉRARCHIE DE NON-TERMINAUX
 * 
 * expr  (+ -)   Basse priorité
 *   |
 * term  (* /)   Moyenne priorité
 *   |
 * factor (num, ()) Haute priorité
 * 
 * RÈGLE : Plus un opérateur est "bas" dans la hiérarchie,
 * plus sa priorité est HAUTE (évalué en premier).
 */

%{
#include <stdio.h>
#include <stdlib.h>
extern int yylex();
void yyerror(const char *s);
%}

%token NUMBER PLUS MINUS MULT DIV LPAREN RPAREN NEWLINE

%%

input:
    | input line
    ;

line:
    NEWLINE
    | expr NEWLINE { printf("Résultat avec priorité correcte\n"); }
    ;

/*
 * NIVEAU 1 : ADDITION ET SOUSTRACTION (Priorité BASSE)
 * 
 * expr se décompose en terme avec + ou -
 * Les + et - sont évalués EN DERNIER
 */
expr:
    expr PLUS term   { printf("expr + term (priorité basse)\n"); }
    | expr MINUS term { printf("expr - term (priorité basse)\n"); }
    | term            { printf("expr -> term\n"); }
    ;

/*
 * NIVEAU 2 : MULTIPLICATION ET DIVISION (Priorité MOYENNE)
 * 
 * term se décompose en facteur avec * ou /
 * Les * et / sont évalués AVANT + et -
 */
term:
    term MULT factor  { printf("term * factor (priorité moyenne)\n"); }
    | term DIV factor { printf("term / factor (priorité moyenne)\n"); }
    | factor          { printf("term -> factor\n"); }
    ;

/*
 * NIVEAU 3 : FACTEURS (Priorité HAUTE)
 * 
 * Un facteur est soit :
 * - Un nombre (atomique)
 * - Une expression entre parenthèses (force la priorité)
 * 
 * Les facteurs sont évalués EN PREMIER
 */
factor:
    NUMBER { printf("factor -> NUMBER\n"); }
    | LPAREN expr RPAREN { printf("factor -> (expr) [parenthèses forcent priorité]\n"); }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Erreur: %s\n", s);
}

int main(void) {
    printf("=== PRIORITÉ DES OPÉRATEURS ===\n\n");
    printf("HIÉRARCHIE (du bas vers le haut = haute vers basse priorité) :\n");
    printf("  factor : NUMBER | (expr)    [Priorité HAUTE - évalué EN PREMIER]\n");
    printf("     ↑\n");
    printf("  term : term * factor | term / factor | factor  [Priorité MOYENNE]\n");
    printf("     ↑\n");
    printf("  expr : expr + term | expr - term | term  [Priorité BASSE - évalué EN DERNIER]\n\n");
    
    printf("EXEMPLES :\n");
    printf("  2 + 3 * 4  =  2 + (3 * 4)  =  2 + 12  =  14\n");
    printf("  (2 + 3) * 4  =  5 * 4  =  20\n");
    printf("  2 * 3 + 4 * 5  =  (2 * 3) + (4 * 5)  =  6 + 20  =  26\n\n");
    
    printf("POURQUOI CETTE STRUCTURE ?\n");
    printf("- expr contient term → + et - doivent attendre term\n");
    printf("- term contient factor → * et / doivent attendre factor\n");
    printf("- factor est atomique → évalué immédiatement\n\n");
    
    printf("Entrez des expressions:\n");
    return yyparse();
}
