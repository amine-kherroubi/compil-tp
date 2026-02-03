/*
 * PROBLÈME 03 : RÉCURSIVITÉ GAUCHE
 * 
 * TYPE D'ANALYSE : LEXICALE (support)
 * 
 * Lexer simple pour le problème de récursivité gauche.
 */

%{
#include "y.tab.h"
%}

%%

[0-9]+      { return NUM; }
"+"         { return PLUS; }
"-"         { return MINUS; }
[ \t]+      { /* ignore */ }
"\n"        { return NEWLINE; }
.           { printf("Caractère illégal\n"); }

%%

int yywrap() { return 1; }
