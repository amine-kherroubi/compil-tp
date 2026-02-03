/*
 * PROBLÈME 04 : ÉLIMINATION DE LA RÉCURSIVITÉ GAUCHE
 * Lexer support
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
.           { /* ignore */ }

%%

int yywrap() { return 1; }
