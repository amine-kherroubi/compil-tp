/*
 * PROBLÈME 03 : RÉCURSIVITÉ GAUCHE
 * 
 * TYPE D'ANALYSE : SYNTAXIQUE
 * 
 * NOTION THÉORIQUE : Récursivité gauche dans les grammaires
 * 
 * DÉFINITION :
 * Une production est récursive à gauche si elle a la forme :
 *   A -> A α
 * où A est un non-terminal et α est une séquence quelconque.
 * 
 * TYPES DE RÉCURSIVITÉ GAUCHE :
 * 1. DIRECTE : A -> A α | β
 * 2. INDIRECTE : A -> B α, B -> A β
 * 
 * POURQUOI CE PROBLÈME À L'EXAMEN ?
 * - Fondamental pour les parsers LL (récursifs descendants)
 * - Les parsers LL ne peuvent PAS gérer la récursivité gauche
 * - Question fréquente : "Éliminez la récursivité gauche de cette grammaire"
 * - Bison (LR) accepte la récursivité gauche, mais il faut comprendre le concept
 * 
 * ERREURS CLASSIQUES DES ÉTUDIANTS :
 * 1. Confondre récursivité gauche et récursivité droite
 * 2. Ne pas voir la récursivité gauche indirecte
 * 3. Mal appliquer l'algorithme d'élimination
 * 4. Penser que TOUTE récursivité est problématique (faux : seulement la gauche pour LL)
 * 
 * EXEMPLE DE PROBLÈME :
 * 
 * Grammaire avec récursivité gauche DIRECTE :
 *   E -> E + T  
 *   E -> T
 *   T -> NUM
 * 
 * Pour un parser LL, cela cause une boucle infinie car :
 * - Pour reconnaître E, on doit d'abord reconnaître E
 * - C'est une dépendance circulaire immédiate
 * 
 * SOLUTION (voir problem04 pour l'élimination) :
 * La récursivité gauche est acceptable pour les parsers LR (Bison)
 * mais doit être éliminée pour les parsers LL (JavaCC, parseurs récursifs).
 * 
 * AVANTAGE DE LA RÉCURSIVITÉ GAUCHE POUR LR :
 * - Associativité gauche naturelle : 1 + 2 + 3 = (1 + 2) + 3
 * - Arbre de dérivation "penche" à gauche
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
    | expr NEWLINE { printf("Expression valide avec récursivité gauche\n"); }
    ;

/*
 * RÉCURSIVITÉ GAUCHE DIRECTE - FONCTIONNELLE AVEC BISON (LR)
 * 
 * Ces règles sont récursives à gauche car 'expr' apparaît en PREMIÈRE position
 * dans les productions récursives.
 * 
 * Pour la chaîne "1 + 2 + 3", cela construit :
 *        expr
 *       /  |  \
 *    expr  +  term
 *    / | \        \
 * expr + term    NUM(3)
 *   |       \
 * term    NUM(2)
 *   |
 * NUM(1)
 * 
 * Résultat : ((1 + 2) + 3) - associativité GAUCHE
 */

expr:
    expr PLUS term    { printf("Réduction: expr -> expr + term (RÉCURSIVITÉ GAUCHE)\n"); }
    | expr MINUS term { printf("Réduction: expr -> expr - term (RÉCURSIVITÉ GAUCHE)\n"); }
    | term            { printf("Réduction: expr -> term\n"); }
    ;

term:
    NUM { printf("Réduction: term -> NUM\n"); }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Erreur: %s\n", s);
}

int main(void) {
    printf("=== DÉMONSTRATION DE RÉCURSIVITÉ GAUCHE ===\n\n");
    printf("Grammaire avec récursivité gauche DIRECTE:\n");
    printf("  expr -> expr + term   (récursif à gauche)\n");
    printf("  expr -> expr - term   (récursif à gauche)\n");
    printf("  expr -> term\n");
    printf("  term -> NUM\n\n");
    
    printf("IMPORTANT:\n");
    printf("- Cette grammaire fonctionne avec Bison (parser LR)\n");
    printf("- Elle NE fonctionnerait PAS avec un parser LL (récursif descendant)\n");
    printf("- La récursivité gauche donne l'associativité GAUCHE\n");
    printf("- Pour '1 + 2 + 3' : ((1 + 2) + 3) = 6\n\n");
    
    printf("Entrez des expressions (Ctrl+D pour terminer):\n");
    printf("Exemples: 5 + 3\n");
    printf("          1 + 2 + 3 + 4\n");
    printf("          10 - 3 - 2\n\n");
    
    return yyparse();
}
