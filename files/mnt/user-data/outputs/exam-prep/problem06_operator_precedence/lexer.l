/* PROBLÈME 06 : PRIORITÉ DES OPÉRATEURS - Lexer */
%{
#include "y.tab.h"
%}
%%
[0-9]+      { return NUMBER; }
"+"         { return PLUS; }
"-"         { return MINUS; }
"*"         { return MULT; }
"/"         { return DIV; }
"("         { return LPAREN; }
")"         { return RPAREN; }
[ \t]+      { }
"\n"        { return NEWLINE; }
.           { }
%%
int yywrap() { return 1; }
