/*
 * PROBLÈME 07 : ASSOCIATIVITÉ DES OPÉRATEURS
 * 
 * TYPE D'ANALYSE : SYNTAXIQUE
 * 
 * NOTION THÉORIQUE : Associativité (gauche vs droite)
 * 
 * DÉFINITION :
 * L'associativité détermine l'ordre d'évaluation pour opérateurs de MÊME priorité.
 * 
 * ASSOCIATIVITÉ GAUCHE : (a ⊕ b) ⊕ c
 * ASSOCIATIVITÉ DROITE : a ⊕ (b ⊕ c)
 * 
 * EXEMPLES MATHÉMATIQUES :
 * - Addition : 5 - 2 - 1 = (5 - 2) - 1 = 2  [GAUCHE]
 * - Puissance : 2 ^ 3 ^ 2 = 2 ^ (3 ^ 2) = 512  [DROITE]
 * - Affectation : a = b = 5 → a = (b = 5)  [DROITE]
 * 
 * POURQUOI CE PROBLÈME À L'EXAMEN ?
 * - Distinction priorité vs associativité (souvent confondus)
 * - Impact crucial sur résultats : 5-2-1 ≠ 5-(2-1)
 * - Opérateur ^ (puissance) : cas spécial droite
 * 
 * ERREURS CLASSIQUES :
 * 1. Confondre priorité et associativité
 * 2. Appliquer associativité gauche à tous les opérateurs
 * 3. Ne pas voir que 2^3^2 ≠ (2^3)^2
 * 
 * IMPLÉMENTATION :
 * - Récursivité GAUCHE → Associativité GAUCHE
 * - Récursivité DROITE → Associativité DROITE
 */

%{
#include <stdio.h>
extern int yylex();
void yyerror(const char *s);
%}

%token NUM PLUS MINUS POWER ASSIGN VAR NEWLINE

%%

input:
    | input line
    ;

line:
    NEWLINE
    | expr NEWLINE { printf("Expression évaluée\n\n"); }
    ;

/* 
 * ASSOCIATIVITÉ GAUCHE : + et -
 * expr -> expr + term (récursivité GAUCHE)
 * 
 * Pour 5 - 2 - 1 :
 *     expr
 *    / | \
 * expr - term(1)
 *  / | \
 *expr- term(2)
 *  |
 *term(5)
 * 
 * Résultat : ((5 - 2) - 1) = 2
 */
expr:
    expr PLUS term  { printf("(expr + term) - associativité GAUCHE\n"); }
    | expr MINUS term { printf("(expr - term) - associativité GAUCHE\n"); }
    | term
    ;

term:
    power
    ;

/* 
 * ASSOCIATIVITÉ DROITE : ^ (puissance)
 * power -> factor ^ power (récursivité DROITE)
 * 
 * Pour 2 ^ 3 ^ 2 :
 *     power
 *    / | \
 *factor(2) ^ power
 *           / | \
 *      factor(3) ^ power
 *                   |
 *                factor(2)
 * 
 * Résultat : 2 ^ (3 ^ 2) = 2 ^ 9 = 512
 * PAS (2 ^ 3) ^ 2 = 8 ^ 2 = 64
 */
power:
    factor POWER power { printf("(factor ^ power) - associativité DROITE\n"); }
    | factor
    ;

factor:
    NUM { printf("NUM\n"); }
    | VAR { printf("VAR\n"); }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Erreur: %s\n", s);
}

int main(void) {
    printf("=== ASSOCIATIVITÉ DES OPÉRATEURS ===\n\n");
    printf("ASSOCIATIVITÉ GAUCHE (+ et -) :\n");
    printf("  expr -> expr OP term  (récursivité GAUCHE)\n");
    printf("  Exemple : 5 - 2 - 1 = (5 - 2) - 1 = 2\n\n");
    
    printf("ASSOCIATIVITÉ DROITE (^) :\n");
    printf("  power -> factor ^ power  (récursivité DROITE)\n");
    printf("  Exemple : 2 ^ 3 ^ 2 = 2 ^ (3 ^ 2) = 512\n");
    printf("  PAS (2 ^ 3) ^ 2 = 64\n\n");
    
    printf("POURQUOI C'EST IMPORTANT ?\n");
    printf("  Soustraction : 10 - 3 - 2\n");
    printf("    Gauche : (10 - 3) - 2 = 5 ✓\n");
    printf("    Droite : 10 - (3 - 2) = 9 ✗\n\n");
    
    printf("Entrez des expressions:\n");
    return yyparse();
}
