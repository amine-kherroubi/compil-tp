/*
 * PROBLÈME 02 : AMBIGUÏTÉ GRAMMATICALE
 * 
 * TYPE D'ANALYSE : SYNTAXIQUE
 * 
 * NOTION THÉORIQUE : Ambiguïté dans les grammaires formelles
 * 
 * DÉFINITION D'AMBIGUÏTÉ :
 * Une grammaire est ambiguë si et seulement si il existe au moins une chaîne
 * qui possède DEUX arbres de dérivation différents (ou plus).
 * 
 * POURQUOI CE PROBLÈME À L'EXAMEN ?
 * - Concept fondamental en théorie des langages
 * - Souvent demandé : "Cette grammaire est-elle ambiguë ? Prouvez-le."
 * - Lié aux conflits shift/reduce et reduce/reduce
 * 
 * ERREURS CLASSIQUES DES ÉTUDIANTS :
 * 1. Confondre "ambiguïté" et "non-déterminisme"
 * 2. Ne pas savoir construire deux arbres de dérivation différents
 * 3. Penser qu'une grammaire avec conflits est forcément ambiguë
 * 4. Ne pas comprendre que l'ambiguïté est une propriété de la GRAMMAIRE, pas du langage
 * 
 * EXEMPLE CLASSIQUE :
 * Grammaire ambiguë pour les expressions arithmétiques :
 * 
 *   E -> E + E
 *   E -> E * E
 *   E -> NUMBER
 * 
 * La chaîne "2 + 3 * 4" peut être dérivée de DEUX façons :
 * 
 * Arbre 1 :        E              Arbre 2 :        E
 *               /  |  \                         /  |  \
 *              E   +   E                       E   *   E
 *             / \                             / \
 *            2   E                           E   4
 *               / \                         / \
 *              3   *   4                   2   +   3
 * 
 * Résultat arbre 1 : 2 + (3 * 4) = 14  (CORRECT mathématiquement)
 * Résultat arbre 2 : (2 + 3) * 4 = 20  (INCORRECT)
 * 
 * SOLUTION RETENUE :
 * - Grammaire volontairement ambiguë pour démonstration
 * - Bison génèrera des avertissements de conflits shift/reduce
 * - Ces conflits PROUVENT l'ambiguïté
 */

%{
#include <stdio.h>
#include <stdlib.h>

extern int yylex();
extern int line_num;
void yyerror(const char *s);
%}

%token NUMBER PLUS MULT LPAREN RPAREN NEWLINE

%%

/*
 * GRAMMAIRE AMBIGUË - VOLONTAIRE
 * 
 * Cette grammaire génère des conflits shift/reduce car pour "E + E * E",
 * le parser ne sait pas s'il doit :
 * - Réduire "E + E" d'abord (associativité gauche)
 * - Shifter "*" pour construire "E * E" d'abord (priorité de *)
 * 
 * Bison choisira par défaut shift, ce qui donne la priorité à *
 * mais l'ambiguïté subsiste dans la grammaire elle-même.
 */

input:
    /* vide */
    | input line
    ;

line:
    NEWLINE
    | expr NEWLINE { printf("Expression valide - arbre construit\n"); }
    ;

/*
 * RÈGLES AMBIGUËS
 * Chaque règle peut s'appliquer récursivement sans contrainte de priorité
 */
expr:
    expr PLUS expr  { printf("Réduction: E -> E + E\n"); }
    | expr MULT expr { printf("Réduction: E -> E * E\n"); }
    | LPAREN expr RPAREN { printf("Réduction: E -> (E)\n"); }
    | NUMBER { printf("Réduction: E -> NUMBER\n"); }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Erreur syntaxique ligne %d: %s\n", line_num, s);
}

int main(void) {
    printf("=== DÉMONSTRATION D'AMBIGUÏTÉ GRAMMATICALE ===\n");
    printf("Grammaire ambiguë pour expressions arithmétiques\n\n");
    printf("Grammaire:\n");
    printf("  E -> E + E\n");
    printf("  E -> E * E\n");
    printf("  E -> (E)\n");
    printf("  E -> NUMBER\n\n");
    printf("IMPORTANT: Cette grammaire est AMBIGUË car elle ne spécifie pas:\n");
    printf("  - La priorité des opérateurs (+ vs *)\n");
    printf("  - L'associativité (gauche ou droite)\n\n");
    printf("Exemple: '2 + 3 * 4' a DEUX arbres de dérivation:\n");
    printf("  1) (2 + 3) * 4 = 20\n");
    printf("  2) 2 + (3 * 4) = 14\n\n");
    printf("Entrez des expressions (Ctrl+D pour terminer):\n");
    
    return yyparse();
}
