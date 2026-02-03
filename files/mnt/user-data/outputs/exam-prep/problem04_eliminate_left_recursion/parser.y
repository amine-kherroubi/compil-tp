/*
 * PROBLÈME 04 : ÉLIMINATION DE LA RÉCURSIVITÉ GAUCHE
 * 
 * TYPE D'ANALYSE : SYNTAXIQUE
 * 
 * NOTION THÉORIQUE : Transformation de grammaire pour éliminer la récursivité gauche
 * 
 * POURQUOI CE PROBLÈME À L'EXAMEN ?
 * - Exercice classique : "Éliminez la récursivité gauche de cette grammaire"
 * - Essentiel pour construire des parsers LL (récursifs descendants)
 * - Algorithme mécanique souvent demandé
 * 
 * ALGORITHME D'ÉLIMINATION (DIRECTE) :
 * 
 * Grammaire AVEC récursivité gauche :
 *   A -> A α₁ | A α₂ | ... | A αₘ | β₁ | β₂ | ... | βₙ
 * 
 * Où :
 * - A α₁, A α₂, ..., A αₘ sont les productions récursives à gauche
 * - β₁, β₂, ..., βₙ sont les productions NON récursives à gauche
 * - Aucun βᵢ ne commence par A (important !)
 * 
 * Transformation :
 *   A  -> β₁ A' | β₂ A' | ... | βₙ A'
 *   A' -> α₁ A' | α₂ A' | ... | αₘ A' | ε
 * 
 * EXEMPLE CONCRET :
 * 
 * AVANT (récursivité gauche) :
 *   expr -> expr + term  (récursif)
 *   expr -> expr - term  (récursif)
 *   expr -> term         (non récursif)
 * 
 * Identification :
 * - A = expr
 * - α₁ = + term
 * - α₂ = - term
 * - β₁ = term
 * 
 * APRÈS (sans récursivité gauche) :
 *   expr  -> term expr'
 *   expr' -> + term expr'
 *   expr' -> - term expr'
 *   expr' -> ε
 * 
 * ERREURS CLASSIQUES :
 * 1. Oublier le cas ε (epsilon) dans A'
 * 2. Ne pas appliquer A' après chaque βᵢ
 * 3. Confondre l'ordre des symboles dans A'
 * 4. Ne pas traiter la récursivité gauche indirecte
 */

%{
#include <stdio.h>
extern int yylex();
void yyerror(const char *s);
%}

%token NUM PLUS MINUS NEWLINE

%%

input:
    /* vide */
    | input line
    ;

line:
    NEWLINE
    | expr NEWLINE { printf("Expression valide SANS récursivité gauche\n"); }
    ;

/*
 * GRAMMAIRE TRANSFORMÉE - SANS RÉCURSIVITÉ GAUCHE
 * 
 * Cette grammaire reconnaît le MÊME LANGAGE que problem03
 * mais utilise la récursivité DROITE au lieu de gauche.
 * 
 * Compatible avec les parsers LL (récursifs descendants).
 */

expr:
    term expr_prime { printf("Réduction: expr -> term expr'\n"); }
    ;

/*
 * expr_prime représente la "queue" de l'expression
 * C'est le A' de l'algorithme
 * 
 * Attention : expr_prime est récursif à DROITE (+ term expr_prime)
 * et contient le cas epsilon (production vide)
 */
expr_prime:
    PLUS term expr_prime  { printf("Réduction: expr' -> + term expr' (RÉCURSIVITÉ DROITE)\n"); }
    | MINUS term expr_prime { printf("Réduction: expr' -> - term expr' (RÉCURSIVITÉ DROITE)\n"); }
    | /* epsilon */         { printf("Réduction: expr' -> ε (epsilon)\n"); }
    ;

term:
    NUM { printf("Réduction: term -> NUM\n"); }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Erreur: %s\n", s);
}

int main(void) {
    printf("=== ÉLIMINATION DE LA RÉCURSIVITÉ GAUCHE ===\n\n");
    
    printf("GRAMMAIRE ORIGINALE (avec récursivité gauche) :\n");
    printf("  expr -> expr + term\n");
    printf("  expr -> expr - term\n");
    printf("  expr -> term\n\n");
    
    printf("GRAMMAIRE TRANSFORMÉE (sans récursivité gauche) :\n");
    printf("  expr  -> term expr'\n");
    printf("  expr' -> + term expr'\n");
    printf("  expr' -> - term expr'\n");
    printf("  expr' -> ε\n\n");
    
    printf("ALGORITHME APPLIQUÉ :\n");
    printf("  1. Identifier A (expr), α (+ term, - term), β (term)\n");
    printf("  2. Créer nouveau non-terminal A' (expr')\n");
    printf("  3. A -> β A'\n");
    printf("  4. A' -> α A' | ε\n\n");
    
    printf("ATTENTION - ASSOCIATIVITÉ :\n");
    printf("  La récursivité DROITE donne l'associativité DROITE\n");
    printf("  Pour '5 - 2 - 1' :\n");
    printf("    Gauche : (5 - 2) - 1 = 2 (correct pour soustraction)\n");
    printf("    Droite : 5 - (2 - 1) = 4 (incorrect !)\n");
    printf("  Solution : traitement sémantique pour corriger\n\n");
    
    printf("Entrez des expressions (Ctrl+D pour terminer):\n");
    
    return yyparse();
}
